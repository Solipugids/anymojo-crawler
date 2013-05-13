package Crawler;

use Moo;
use Smart::Comments;
use YAML qw(LoadFile);
use Crawler::Base;
use Crawler::Logging;
use Crawler::Entry;
use Crawler::UserAgent;
use Crawler::DB;
use Crawler::Parser;
use Crawler::Data::Meta;
use Crawler::Data::Caculator;
use EV;
use AnyEvent;

with 'Crawler::Logging';

# todo: validte site url for example: www.baidu.com
has site            => ( is => 'ro', required => 1 );
has scan_stop_time  => ( is => 'ro', default  => sub { undef } );
has scan_start_time => ( is => 'ro', default  => sub { undef } );
has debug           => ( is => 'ro', default  => 0 );
has caculator =>
  ( is => 'rw', default => sub { Crawler::Data::Caculator->new }, lazy => 1 );
has parser =>
  ( is => 'rw', default => sub { Crawler::Parser->new(); }, lazy => 1 );
has user_agent =>
  ( is => 'rw', default => sub { Crawler::UserAgent->new(); }, lazy => 1 );
has entry =>
  ( is => 'rw', default => sub { Crawler::Entry->new(); }, lazy => 1 );
has meta_data =>
  ( is => 'rw', default => sub { Crawler::Data::Meta->new }, lazy => 1 );
has conf        => ( is => 'rw' );
has option      => ( is => 'rw' );
has source_type => ( is => 'rw', required => 1 );

sub BUILD {
    my ( $self, @args ) = @_;

    if ( not ref( $self->conf ) and -e $self->conf ) {
        $self->option( LoadFile( $self->conf ) );
    }
    elsif ( ref( $self->conf ) eq 'HASH' ) {
        $self->option( $self->conf );
    }

    $self->log->path( $self->option->{log}{path}   || $ENV{CRAWLER_LOG_PATH} );
    $self->log->level( $self->option->{log}{level} || $ENV{CRAWLER_LOG_LEVEL} );

    # here handle metadb operation
    my $source_db_dsn    = $self->option->{ $self->site }{source_db_dsn};
    my $source_db_user   = $self->option->{ $self->site }{source_db_user};
    my $source_db_passwd = $self->option->{ $self->site }{source_db_passwd};
    my $dest_db_dsn      = $self->option->{ $self->site }{dest_db_dsn};
    my $dest_db_user     = $self->option->{ $self->site }{dest_db_user};
    my $dest_db_passwd   = $self->option->{ $self->site }{dest_db_passwd};

    $self->meta_data->connect_db(
        dsn    => $source_db_dsn,
        user   => $source_db_user,
        passwd => $source_db_passwd
    );
    $self->caculator->connect_db(
        dsn    => $dest_db_dsn,
        user   => $dest_db_user,
        passwd => $dest_db_passwd
    );
    $self->log->debug("init connect meta db and dest db successful!");
    my %site_option = %{ $self->option->{ $self->site } };

    if ( $site_option{proxy} ) {
        $self->user_agent->proxy( $site_option{proxy} );
    }
    # plugin : Mojo::UserAgent=>CookieJar
    if ( $site_option{plugin} ) {
        for my $plugin ( split( ",", $site_option{plugin} ) ) {
            my ( $package_name, $plugin ) = split( "=>", $plugin );
            require Moo::Role;
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
}

sub run {
    my ( $self, $task_id ) = @_;
    my $parsed_result = {};
    my $cv            = AnyEvent->condvar;
    my $index_url     = 'http://' . $self->site;
    $self->user_agent->get(
        $index_url => sub {
            my ( $ua, $tx ) = @_;
            my $feeder_parser =
              $self->parser->get_parser_by_urlpattern($index_url);
            if ( $tx->success ) {
                $self->parser->parse( $self, $ua, $tx->res->body,
                    $parsed_result );
                my $feeder_condvar = AnyEvent->condvar;

                # foreach every feeder of this website
                for my $feeder_url ( @{ $parsed_result->{feeders} } ) {
                    $feeder_condvar->begin;
                    my $page_parser =
                      $self->parser->get_parser_by_urlpattern($feeder_url);
                    $self->user_agent->get(
                        $feeder_url,
                        sub {
                            my ( $ua, $tx ) = @_;
                            if ( $tx->success ) {
                                $page_parser->parse( $self, $ua,
                                    $tx->res->body, $parsed_result );
                            }
                            else {
                                $self->log->error(
                                    "Download pages => $feeder_url failed");
                            }
                            $feeder_condvar->end;
                        }
                    );
                }
            }
            else {
                $self->log->error("Download index => $index_url failed");
            }
        },
    );
    $cv->recv;
}

sub register_parser {
    my ( $self, $subscribe, $cb ) = @_;

    1;

## Please see file perltidy.ERR
## Please see file perltidy.ERR
## Please see file perltidy.ERR
