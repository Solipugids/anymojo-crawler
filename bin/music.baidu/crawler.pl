use Crawler::Base -strict;
use Getopt::Long;
use File::Spec;
use Crawler;
use File::Path qw(make_path remove_tree);
use YAML qw(Dump);
use Digest::MD5 qw(md5_hex);
use Mojo::JSON;
use Mojo::DOM;
use Mojo::Util 'spurt';
use Encode qw(encode_utf8 decode_utf8);

my $usage = <<EOF;
$0 -task_id xx -conf xxx.yaml -debug 1 -site xxx
*******************************************************************************
Example:
    $0 -task_id 1 -conf ./crawler.yaml  -site mgpyh -debug 1
EOF

my $task_id;
my $config = File::Spec->catfile( split( '/', $ENV{PROJECT_PATH} ),
    'conf', 'crawler.yaml' );
my $site     = 'music.baidu';
my $base_url = 'http://music.baidu.com';
my $debug;
GetOptions(
    'task_id=s' => \$task_id,    # numeric task_id
    'site|s=s'  => \$site,
    'conf=s'    => \$config,
    'debug|d'   => \$debug,
) or die("Get command args Error!!!");

unless ($task_id) {
    die $usage;
}

my $c = Crawler->new(
    conf => $config,
    site => $site,
);
$c->schema->storage->debug(1) if $debug;
$c->is_debug(1) if $debug;
$c->log->path('/tmp/fork.log');
$c->log->level('info');
$c->register_parser(
    artist => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        my $category = $attr->{entry}->category;

        eval {
            my $ting_uid = $dom->at('#baseInfo')->{ting_uid};
            my $hot_num  = $dom->at('span.hot-num > span.num')->text;
            $hot_num =~ s/,//g;
            my ($hot_max) = $attr->{html} =~ m{var\s+hotbarMax\s*=\s*(\d+)}six;

            my @pages = ();
            my $page_count;
            my $singer_name = $dom->at('h2.singer-name')->text;
            my $c           = $dom->at('div.page-inner')->find('a');
            if ( $c->size > 0 ) {
                $page_count = $dom->at('div.page-inner')->find('a')->[-2]->text;
                for my $page_num ( 0 .. $page_count - 1 ) {
                    my $page_hashref = {};
                    my $start        = $page_num * 20;
                    my $page_url =
                      join( '/', $base_url, 'data', 'user', 'getsongs' )
                      . "?start=${start}&ting_uid=${ting_uid}&order=hot&hotmax=$hot_num";

                    #$page_hashref->{hot_num}     = $hot_num;
                    $page_hashref->{url}         = $page_url;
                    $page_hashref->{hot_num}     = $hot_num;
                    $page_hashref->{hot_max}     = $hot_max;
                    $page_hashref->{page_num}    = $page_num + 1;
                    $page_hashref->{url_md5}     = md5_hex($page_url);
                    $page_hashref->{status}      = 'undo';
                    $page_hashref->{singer_name} = $singer_name;
                    $page_hashref->{website_id}  = $attr->{website_id};
                    $page_hashref->{category}  = $category;
                    push @{ $parsed_result->{page} }, $page_hashref;
                }
            }
            else {
                push @{ $parsed_result->{page} },
                  {
                      category => $category,
                    hot_num     => $hot_num,
                    hot_max     => $hot_max,
                    singer_name => $singer_name,
                    url         => $attr->{url},
                    url_md5     => md5_hex($attr->{url}),
                    status      => 'undo',
                    website_id  => $attr->{website_id},
                    page_num    => 1,
                  };
            }
        };
        return 0 if @{ $parsed_result->{page} } ==0;
        if ($@) {
            print "get page count failed: $@\n";
            return 0;
        }
        return 1;
    },
    home => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        my $category;
        if( $attr->{url}=~ m{cn/male} ){
            $category = '华语男歌手';
        }elsif( $attr->{url}=~ m{cn/female} ){
            $category ='华语女歌手';
        }elsif( $attr->{url}=~ m{western/male} ){
            $category ='欧美男歌手';
        }elsif( $attr->{url}=~ m{western/female} ){
            $category ='欧美女歌手';
        }elsif( $attr->{url}=~ m{western/group} ){
            $category ='欧美组合';
        }elsif( $attr->{url}=~ m{jpkr/male} ){
            $category ='日韩男歌手';
        }elsif( $attr->{url}=~ m{jpkr/female} ){
            $category ='日韩女歌手';
        }elsif( $attr->{url}=~ m{jpkr/group} ){
            $category ='日韩组合';
        }else{
            $category= '华语组合';
        }

        # http://music.baidu.com/artist
        # parse singer link
        eval {
            $dom->find('a')->grep(
                sub {
                    my $e = shift;
                    $e and $e->{href} and $e->{href} =~ m#/artist/\d+$#;
                }
              )->map(
                sub {
                    my $artist_hashref = {};
                    my $e              = shift;
                    return if not $e->{title};
                    $artist_hashref->{url} = $base_url . $e->{href};
                    $artist_hashref->{category} = $category;
                    $artist_hashref->{url_md5} =
                      md5_hex( $base_url . $e->{href} );
                    $artist_hashref->{status}     = 'undo';
                    $artist_hashref->{name}       = $e->{title};
                    $artist_hashref->{website_id} = $attr->{website_id};
                    $artist_hashref->{website_id} = $attr->{website_id};
                    push @{ $parsed_result->{ ucfirst 'artist' } },
                      $artist_hashref;
                }
              );
        };
        return 0 if $@;
        return 1;

    },
    singer => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;

        return 0 if @{ $parsed_result->{archive} } == 0;
        return 1;
    },
    page => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        my $feed   = $attr->{url};
        my $string = $attr->{html};
        my $entry  = $attr->{entry};
        if ( $attr->{url} =~ m/getsong/ ) {
            my $j = Mojo::JSON->new;
            $dom = Mojo::DOM->new( $j->decode($string)->{data}{html} )
              ->charset("UTF-8");
        }

        my @songs = ();
        eval {
            for my $e ( $dom->find('div.song-item')->each ) {
                #my $node = $e->find('span.[class="song-title "] > a')->first;
                my $node = $e->find('span.[class="song-title "] > a')->first;
                my ( $href, $song_id ) = $node->{href} =~ m/(.*?(\d+))/;

                unless ($song_id) {
                    next;
                }
                my $album = '';
                my $hot_num = 0;
                eval{
                    $album = $e->at('span.album-title > a')->{title};
                    ( $hot_num = $e->at('span.hot-num')->text ) =~ s/,//g;
                };
                my $song_url = $base_url . $href;
                push @songs,
                  {
                    author=> $entry->singer_name,
                    artist_id   => $entry->url_md5,
                    hot_num     => $hot_num,
                    album       => $album,
                    url         => $song_url,
                    url_md5     => md5_hex($song_url),
                    name        => $node->{title},
                    website_id  => $attr->{website_id},
                    status      => 'undo',
                    page_id => $entry->url_md5,
                    download    => $base_url
                      . "song/${song_id}/download?__o=/song/${song_id}",
                  };
            }
            $parsed_result->{song} = \@songs;
        };

        $attr->{is_success} = 0  if @songs == 0;
        $attr->{is_success} = 0  if $@;
    },
    song => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        #$dom->charset('UTF-8');

        my $entry = $attr->{entry};
        eval {
            my $dbox_hashref = {};
            $dbox_hashref->{name} = $entry->name;
            $dbox_hashref->{hot_num} = $entry->hot_num;
            $dbox_hashref->{author} = $entry->author;
		    #<div class="info-holder clearfix">
            $dbox_hashref->{album} = $dom->at('li.clearfix > a')->text;
            ($dbox_hashref->{lrc}   = $dom->at('#lyricCont')->content_xml)=~ s{<br />}{}sig;
            $dbox_hashref->{status}   = 'undo';
            $dbox_hashref->{website_id} = $attr->{website_id};
            my ($sid) = $attr->{url} =~ m{(\d+)$};
            my $dbox_url = $base_url . "/song/${sid}/download?__o=/song/${sid}";
            $dbox_hashref->{url} = $dbox_url;
            if( not $dbox_hashref->{album}){
                $dbox_hashref->{album} = $entry->{album} if $entry->{album};
                $dbox_hashref->{album} = 'single' if not $dbox_hashref->{album};
            }
            use utf8;
            $dbox_hashref->{album} =~ s/《//g;
            $dbox_hashref->{album} =~ s/》//g;
            $dbox_hashref->{album} = decode_utf8($dbox_hashref->{album});
            my $download_path = File::Spec->catfile( $parser->conf->{music_path},
                $dbox_hashref->{author},$dbox_hashref->{album},$dbox_hashref->{name});
            make_path $download_path if not -d $download_path;
            if( my $lrc_node = $dom->at('a.down-lrc-btn') ){
                my $lrc_file = File::Spec->catfile($download_path,($dbox_hashref->{name}).".lrc");
                my $lrc_url = $lrc_node->{'data-lyricdata'};
                if( $lrc_url ){
                    my $json = Mojo::JSON->new;
                    $lrc_url = $base_url.$json->decode($lrc_url)->{href};
                     system("wget",$lrc_url,"-O",$lrc_file)==0 or die "wget failed";
                }
            }
            $dbox_hashref->{download_path} = $download_path;
            push @{ $parsed_result->{dbox} }, $dbox_hashref;
        };
        $attr->{is_success} = 0  if $@;
        $attr->{is_success} = 0  if exists $parsed_result->{dbox};
    },
    dbox => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        my ($url) = $attr->{url};
        my $name = $dom->at('a.song-link-hook')->text;
        for my $e (
            $dom->find('a')->grep( sub { index( $_->{href}, 'mp3' ) != -1 } )
            ->each )
        {
            my ($download_url) = $e->{href} =~ m{link=(.*)}six;
            push @{ $parsed_result->{download} },
              {
                url  => $download_url,
                name => $name,
                rate => $e->{id} . "k",
              };
        }

    },
    download => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        1;
    },
);

$c->run($task_id);
