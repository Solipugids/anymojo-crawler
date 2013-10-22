package Crawler;

use Moo;
use Smart::Comments;
use YAML qw(LoadFile Dump);
use Crawler::Base -strict;
use MP3::Tag;
use Crawler::Logging;
use Crawler::Entry;
use Digest::MD5 qw(md5_hex);
use Mojo::Collection;
use Crawler::UserAgent;
use Crawler::DB;
use Encode qw(encode decode);
use Mojo::DOM;
use Crawler::DB::Schema;
use Crawler::Parser;

#use EV;
use TryCatch;
use AnyEvent;
use Encode qw(decode encode);
use Time::HiRes qw(sleep);

with 'Crawler::Logging';

# todo: validte site url for example: www.baidu.com
has site     => ( is => 'ro', required => 1 );
has charset  => ( is => 'rw', default  => 'utf8', lazy => 1 );
has is_debug => ( is => 'rw', default  => 0, lazy => 1 );
has parsed_result => (
    is      => 'rw',
    default => sub {
        my $parsed_result = {};
    },
    lazy => 1
);
has parser_option => ( is => 'rw', default => sub { {} }, lazy => 1 );
has scan_stop_time  => ( is => 'ro', default => sub { undef } );
has scan_start_time => ( is => 'ro', default => sub { undef } );
has debug           => ( is => 'ro', default => 0 );
has sample          => ( is => 'rw' );
has parser =>
  ( is => 'rw', default => sub { Crawler::Parser->new(); }, lazy => 1 );
has user_agent =>
  ( is => 'rw', default => sub { Crawler::UserAgent->new(); }, lazy => 1 );
has conf     => ( is => 'rw' );
has option   => ( is => 'rw' );
has schema   => ( is => 'rw' );
has crawl_cv => ( is => 'rw', default => sub { AnyEvent->condvar }, lazy => 1 );
has stat => (
    is      => 'rw',
    default => sub {
        my $stat = {
            success_urls => [],
            fail_urls    => [],
            success_rows => 0,
            fail_rows    => 0,
            total        => 0,
            status       => 'success',
        };
    },
    lazy => 1
);

sub BUILD {
    my ( $self, @args ) = @_;

    if ( not ref( $self->conf ) and -e $self->conf ) {
        $self->option( LoadFile( $self->conf ) );
    }
    elsif ( ref( $self->conf ) eq 'HASH' ) {
        $self->option( $self->conf );
    }
    die "check you conf" if not $self->option;

    $self->log->path( $self->option->{log}{path}   || $ENV{CRAWLER_LOG_PATH} );
    $self->log->level( $self->option->{log}{level} || $ENV{CRAWLER_LOG_LEVEL} );
    $self->schema(
        Crawler::DB::Schema->connect(
            $self->option->{task_db}{dsn},
            $self->option->{task_db}{user},
            $self->option->{task_db}{passwd},
            $self->option->{task_db}{option}
        )
    );

    if ( not exists $self->option->{ $self->site } ) {
        Carp::croak( "check you sitename "
              . $self->site
              . " is same with config website data" );
    }
    my %site_option   = %{ $self->option->{ $self->site } };
    my $parser_option = $self->option->{ $self->site }->{parser};
    $self->charset( $parser_option->{charset} ) if $parser_option;
    $self->parser_option($parser_option)        if $parser_option;
    $self->charset( $site_option{charset} )     if $site_option{charset};

    if ( $site_option{proxy} ) {
        $self->log->debug( "set proxy: " . $site_option{proxy} );

        #$self->user_agent->http_proxy( $site_option{proxy} );
    }
    if ( not -d $site_option{ready_path} ) {
        mkdir $site_option{ready_path};
    }

    # plugin : Mojo::UserAgent=>CookieJar
    if ( $site_option{plugin} ) {
        require Moo::Role;
        for my $plugin ( split( ",", $site_option{plugin} ) ) {
            Moo::Role->apply_roles_to_object( $self, $plugin );
        }
    }
    if ( $site_option{agent} ) {
        $self->user_agent->agent( $site_option{agent} );
    }
    if ( $site_option{cookie} ) {
        require Mojo::UserAgent::CookieJar;
        $self->user_agent->cookie_jar( Mojo::UserAgent::CookieJar->new );
    }
    $self->user_agent->max_connections(5);
    $self->user_agent->max_redirects(5);
}

sub run {
    my ( $self, $task_id ) = @_;
    use Mojo::IOLoop;
    my $parser_option = $self->option->{ $self->site }->{parser};
    my $task_count =
      $self->schema->resultset('TaskDetail')->search( { id => $task_id } )
      ->count;
    my $page_count = int( $task_count / 5 ) + 1;
    my $detail_rs =
      $self->schema->resultset('TaskDetail')
      ->search( { id => $task_id }, { page => $page_count, rows => 5 }, );
    my $task_rs =
      $self->schema->resultset('Task')->find( { id => $task_id } );
    my $stat  = $self->stat;
    my $proxy = $self->option->{ $self->site }->{proxy};

    my $count = 0;
    use Parallel::ForkManager;
    my $max_process = $self->option->{ $self->site }->{max_process} || 1;
    $max_process = 0 if $self->is_debug;
    my $pm = Parallel::ForkManager->new($max_process);

    for my $page_num ( 1 .. $page_count ) {
        my $pid = $pm->start and next if not $self->is_debug;
        {
            my $page = $detail_rs->page($page_num);

            #my $loop    = AnyEvent->condvar;
            my $loop    = Mojo::IOLoop->delay;
            my @list    = $page->all;
            my $shuffle = Mojo::Collection->new(@list);

            #my $cv      = AnyEvent->condvar;
            for my $row ( $shuffle->shuffle->each ) {

                #my $pid = $pm->start and next if not $self->is_debug;
                #$loop->begin ;
                my $url = $row->url;
                $self->user_agent->http_proxy( $self->get_proxy ) if $proxy;

                #$self->user_agent->http_proxy( $self->get_proxy ) if $proxy;
                my $entry = $self->parser->get_parser_by_urlpattern($url);
                $self->log->debug("get parser: $entry by url: $url");
                my $entry_rs = $self->schema->resultset(
                    join( '', map { ucfirst $_ } split( '_', $entry ) ) )
                  ->find( { url_md5 => md5_hex($url) } );
                if (    not $self->is_debug
                    and defined $entry_rs
                    and $entry_rs->status =~ m/success/ )
                {
                    $self->log->debug(
                        "this url : $url => is processed,next....");
                    next;
                }
                if ( not $entry ) {
                    Carp::croak( "not find parse entry by url: " . $url );
                }
                eval {
                    $self->download_mp3( $url, $entry, $task_rs, $entry_rs,
                        $loop );
                };
            }

            $loop->wait unless Mojo::IOLoop->is_running;
            undef $loop;
        }

        #$self->crawl_cv->recv;
        $pm->finish if not $self->is_debug;
    }
    $pm->wait_all_children if not $self->is_debug;
}

sub download_mp3 {
    my ( $self, $url, $entry, $task_rs, $entry_rs, $loop ) = @_;

    if ( $url =~ m/(\d+)/ ) {
        my $song_id = $1;
        my $file =
          File::Spec->catfile( $self->option->{ $self->site }{music_path},
            $song_id, "${song_id}.mp3" );
        if ( -e $file and -s _ >= $entry_rs->size and not $self->is_debug ) {
            $self->log->debug("$song_id => $file is downloaded,next#########");
        }
        if ( my $location = $self->track_hq_location($song_id) ) {
            $self->log->debug("Begin download $song_id => $location");
            my $rc = system( "wget", $location, "-O", $file );
            if ( -s $file >= $entry_rs->size ) {
                $self->log->debug(
"downloaded file => $file success with link => $location, size => "
                      . $entry_rs->size );
                if ( my $bitrate = MP3::Tag->new($file)->bitrate_kbps ) {
                    $self->log->debug("get bitkps => $bitrate");
                    $entry_rs->bitrate( int($bitrate) );
                }
                $entry_rs->status('success');
                $entry_rs->update;
            }

=pod
            $self->user_agent->get(
                $location => sub {
                    my ( $ua, $tx ) = @_;
                    my $content_lenth = $tx->res->headers->content_length;
                    $tx->res->content->asset->move_to($file);
                    if ( -s $file >= $content_lenth and $content_lenth >= $entry_rs->size){
                        $self->log->debug(
"downloaded file => $file success with link => $location, size => $content_lenth=>".$entry_rs->size
                        );
                        if ( my $bitrate = MP3::Tag->new($file)->bitrate_kbps ) {
                            $self->log->debug("get bitkps => $bitrate");
                            $entry_rs->bitrate(int($bitrate));
                        }
                        $entry_rs->status('success');
                        $entry_rs->update;
                    }
                },
            );
=cut

        }
    }
}

sub process_download {
    my ( $self, $url, $entry, $task_rs, $entry_rs, $loop ) = @_;

    my $site_id       = $task_rs->site_id;
    my $parsed_result = {};
    my $parser_option = $self->parser_option;

    # if this parsed result not exists ,defined a empty arrayref
    $parsed_result->{$entry} = [];
    my $is_success = 1;

    #$self->user_agent->http_proxy($self->get_proxy);
    #my $tx = $self->user_agent->get($url => $cb);
    my $attr;
    my $cb = sub {
        my ( $ua, $tx ) = @_;
        if ( $tx->success ) {
            $self->log->debug("Download url: $url return success");
            my $html = $tx->res->body;
            $self->log->debug( "set charset" . $self->parser->conf->{charset} );
            if ( my $decode = $self->parser->conf->{charset} ) {
                $html = decode( $decode, $html );
            }
            my $dom = Mojo::DOM->new($html);
            $attr = {
                html       => $html,
                base_url   => $parser_option->{base_url},
                website_id => $site_id,
                url        => $url,
                ua         => $ua,
                entry      => $entry_rs,
                is_success => 1,
            };
            eval {
                $self->parser->parse( $entry, $dom, $parsed_result, $attr );
            };
            if ($@) {
                $attr->{is_success} = 0;
                $self->log->error("parsed err!!! => $@");
            }
        }
        else {
            $self->log->error("Oops!!!,download url => $url failed");
            $is_success = 0;

            #$loop->end;
        }
        $self->log->error("parsed error in $url") if not $attr->{is_success};
        $self->log->debug( Dump $parsed_result)   if $self->is_debug;
        $self->save_data($parsed_result);
        $attr->{is_success}
          ? $entry_rs->status('success')
          : $entry_rs->status('fail');
        $entry_rs->update;

        #$loop->end;
    };

    #$loop->begin;
    my $tx = $self->user_agent->get( $url => $cb );
}

sub flush_entry_status {
    my ( $self, $url, @entry_rs ) = @_;
    my $stat = $self->stat;

    if ( $stat->{status} eq 'success' ) {
        push @{ $stat->{success_urls} }, $url;
        $stat->{success_rows}++;
    }
    else {
        push @{ $stat->{fail_urls} }, $url;
        $stat->{fail_rows}++;
    }

    for my $rs (@entry_rs) {
        $rs->status( $stat->{status} );
        $rs->update;
    }
}

sub single_run {
    my ( $self, $feed_url, $entry ) = @_;

    my $parsed_result = {};
    my $html          = $self->user_agent->get($feed_url)->res->body;
    $self->log->debug( "add html body:" . $html );
    my $dom = Mojo::DOM->new($html);
    eval {
        $self->parser->parse( $entry, $dom, $parsed_result,
            { ua => $self->user_agent, html => $html } );
    };
    $self->save_data($parsed_result);
}

sub save_data {
    my ( $self, $parsed_result ) = @_;

    for my $t ( keys %{$parsed_result} ) {
        if ( scalar( @{ $parsed_result->{$t} } ) > 0 ) {
            for my $data ( @{ $parsed_result->{$t} } ) {
                $self->log->debug( "Insert new data :" . Dump($data) );
                my $rc = $self->schema->resultset(
                    join( '', map { ucfirst $_ } split( '_', $t ) ) )
                  ->find_or_create($data);

=pod
                if ($rc->in_storage) {
                    $self->log->debug("updated this row");
                }else{
                    $rc->insert;
                }
=cut

            }
        }
    }
}

sub process_rss_download {
    my ( $self, $rss_url ) = @_;
    my $parsed_result = $self->parsed_result;
    my $html;

    my $target;
    $target = $self->parser->conf->{target} || 'WpPost';
    $parsed_result->{$target} = [];
    my $tx = $self->user_agent->get($rss_url);
    if ( $tx->success ) {
        $self->log->debug("Download rss url: $rss_url success!");
        $html = $tx->res->body;
        if ( $self->charset ) {
            $html = decode( $self->charset, $html );
        }
    }
    else {
        Carp::croak("Download rss url => $rss_url failed!");
    }

    $self->parser->parse(
        'rss',
        Mojo::DOM->new($html),
        $parsed_result,
        {
            ua       => $self->user_agent,
            html     => $html,
            base_url => $rss_url,
            target   => $target
        },
    );
    return $parsed_result if $self->parser->conf->{no_extract};
    my $index = 0;
    my $items;
    if ( $self->is_debug ) {
        $items = Mojo::Collection->new( { url => $self->sample }
              || $parsed_result->{$target}->[0] );
    }
    else {
        $items =
          Mojo::Collection->new( @{ $parsed_result->{$target} } )->shuffle;
    }
    for my $item ( $items->each ) {
        $self->crawl_cv->begin;
        $self->user_agent->get(
            $item->{url} => sub {
                my ( $ua, $tx ) = @_;
                my $entry;
                $entry =
                  $self->parser->get_parser_by_urlpattern( $item->{url} );
                $entry = 'web' if not $entry;
                if ( $tx->success ) {
                    if (
                        not $self->parser->parse(
                            $entry,
                            $tx->res->dom,
                            $item,
                            {
                                ua       => $self->user_agent,
                                $html    => $tx->res->body,
                                base_url => $item->{url},
                            }
                        )
                      )
                    {
                        $self->log->error(
                            "wrong parser of this url => " . $item->{url} );
                    }
                }
                else {
                    $self->log->error(
                        "Download item => " . $item->{url} . "  failed" );
                }
                $self->crawl_cv->end;
            }
        );
    }
    $self->crawl_cv->recv;
    return $parsed_result;
}

sub register_parser {
    my ( $self, %parse_map ) = @_;
    my $parser_option = $self->option->{ $self->site }->{parser};
    $self->parser->conf($parser_option);

    while ( my ( $entry, $callback ) = each %parse_map ) {
        if ( ref($callback) ne 'CODE' ) {
            Carp::croak(
                "register parser failed,parse callback must be coderef");
        }
        $self->log->debug("add  $entry parser to crawler");
        $self->parser->reg_cb( $entry => $callback );
    }
}

sub get_proxy {
    my @proxy_list = qw(
      http://sri:secret@95.78.123.159:3128
    );
    return $proxy_list[ int( rand @proxy_list ) ];
}

1;

