use Crawler::Base -strict;
use Getopt::Long;
use File::Spec;
use Crawler;
use YAML qw(Dump);
use Mojo::UserAgent;
use Digest::MD5 qw(md5_hex);
use Mojo::DOM;
use utf8;

my $usage = <<EOF;
$0 -task_id xx -conf xxx.yaml -debug 1 -site xxx
*******************************************************************************
Example:
    $0 -task_id 1 -conf ./crawler.yaml  -site mgpyh -debug 1
EOF

my $task_id;
my $config = File::Spec->catfile( split( '/', $ENV{PROJECT_PATH} ),
    'conf', 'crawler.yaml' );
my $site     = 'xiami.com';
my $base_url = 'http://xiami.com';
my $debug;

GetOptions(
    'task_id|t=s' => \$task_id,    # numeric task_id
    'site|s=s'    => \$site,
    'conf|c=s'    => \$config,
    'debug|d'     => \$debug,
) or die("Get command args Error!!!");

unless ($task_id) {
    die $usage;
}

my $c = Crawler->new(
    conf => $config,
    site => $site,
);

use Mojo::JSON;
my $json = Mojo::JSON->new;
my $lua  = Mojo::UserAgent->new;

$c->schema->storage->debug(1) if $debug;
$c->is_debug(1) if $debug;
$c->log->path("/tmp/xiami.log");
$debug ? $c->log->level('debug') : $c->log->level('info');

$c->register_parser(
    home => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        my $entry = $attr->{entry};
        eval {
            for my $e ( $dom->find('#tab > span')
                ->grep( sub { shift->{'data-tab'} =~ m/cn|us|jp|kr/ } )->each )
            {
                next unless defined $e;
                my $big_category = $e->at('a')->text;
                for my $c (
                    $e->find('li')->grep(
                        sub { shift->{'data-action'} =~ m/male|famale|band/ }
                    )->each
                  )
                {
                    push @{ $parsed_result->{feeder} },
                      {
                        url     => $base_url . $c->at('a')->{href},
                        url_md5 => md5_hex( $base_url . $c->at('a')->{href} ),
                        website_id => $attr->{website_id},
                        status     => 'undo',
                        category   => $big_category . $c->at('a')->all_text,
                      };
                }
            }
        };
        $attr->{is_success} = 0 if $@;
        $attr->{is_success} = 0 if @{ $parsed_result->{feeder} } == 0;
    },
    feeder => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        my $entry = $attr->{entry};
        eval {
            for my $e ( $dom->find('div.all_page > a')->each ) {
                next if not $e;
                my $link;
                if ( $e->{class} eq 'p_num p_curpage' ) {

#http://www.xiami.com/artist/index/c/1/type/0/class/0/page/2?spm=a1z1s.3057853.6863617.1.iv0dXI
                    $link = $attr->{url} . "/page/1";
                }
                else {
                    $link = $base_url . $e->{href};
                }
                $link =~ s{\?spm=.*}{}sig;
                push @{ $parsed_result->{artist_page} },
                  {
                    url        => $link,
                    url_md5    => md5_hex($link),
                    status     => 'undo',
                    category   => $entry->category,
                    website_id => $attr->{website_id},
                  };
            }
        };
        $attr->{is_success} = 0 if $@;
        $attr->{is_success} = 0 if @{ $parsed_result->{artist_page} } == 0;
    },
    artist_index => sub {
    },
    artist_page => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        my $entry = $attr->{entry};

        eval {
            for my $e ( $dom->find('div.info')->each ) {
                next if not $e;
                my $link = $base_url . $e->at('a')->{href};
                my ($id) = $link =~ m{(\d+)$}six;

 # http://www.xiami.com/artist/album/id/61443?spm=a1z1s.6659509.6856549.3.MoJO6j
                $link = $base_url . "/artist/album/id/${id}";

  #http://www.xiami.com/artist/album/id/10637?spm=a1z1s.6659509.6856549.3.CJAfDD
  # http://www.xiami.com/artist/album/id/11768
                push @{ $parsed_result->{album_index} },
                  {
                    url        => $link,
                    url_md5    => md5_hex($link),
                    status     => 'undo',
                    category   => $entry->category,
                    website_id => $attr->{website_id},
                  };
            }
        };
        $attr->{is_success} = 0 if $@;
        $attr->{is_success} = 0 if not exists $parsed_result->{album_index};
    },
    album_index => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        my $entry = $attr->{entry};
        my ($id) = $attr->{url} =~ m{(\d+)}six;

        if ( $attr->{html} =~ m{.status.:.ok.}six ) {
            $attr->{is_success} = 1;
            my $hashref = $json->decode( $attr->{html} );
            if ( $hashref->{artist}{artist_id} ) {
                my $page_count = $hashref->{artist}{album_count} / 20;
                if ( $page_count < 1 ) {
                    my $link =
"http://www.xiami.com/app/iphone/artist-albums?id=${id}&page=1";
                    push @{ $parsed_result->{album_page} },
                      {
                        url        => $link,
                        url_md5    => md5_hex($link),
                        category   => $entry->category,
                        status     => 'undo',
                        website_id => $attr->{website_id},
                      };
                }
                else {
                    for ( 1 .. ( int($page_count) + 1 ) ) {
                        my $link =
"http://www.xiami.com/app/iphone/artist-albums?id=${id}&page=$_";
                        push @{ $parsed_result->{album_page} },
                          {
                            url        => $link,
                            url_md5    => md5_hex($link),
                            category   => $entry->category,
                            status     => 'undo',
                            website_id => $attr->{website_id},
                          };
                    }
                }
            }
            return;
        }
        eval {
            for my $e ( $dom->find('div.all_page > a')->each ) {
                next unless $e;
                my $link;
                if ( $e->{class} eq 'p_num p_curpage' ) {
                    $link = $base_url . "/artist/album/id/${id}/d/p/page/1";
                }
                else {
                    # http://www.xiami.com/artist/album/id/11768/d//p//page/7
                    $link = $base_url . $e->{href};
                }
                $link =~ s{\?spm=.*}{}sig;
                push @{ $parsed_result->{album_page} },
                  {
                    url        => $link,
                    url_md5    => md5_hex($link),
                    category   => $entry->category,
                    status     => 'undo',
                    website_id => $attr->{website_id},
                  };
            }
            if ( not exists $parsed_result->{album_page} ) {
                my $link = $base_url . "/artist/album/id/${id}/d/p/page/1";
                push @{ $parsed_result->{album_page} },
                  {
                    url        => $link,
                    url_md5    => md5_hex($link),
                    category   => $entry->category,
                    status     => 'undo',
                    website_id => $attr->{website_id},
                  };
            }

        };
        $attr->{is_success} = 0 if $@;
        $attr->{is_success} = 0 if not exists $parsed_result->{album_page};
    },
    album_page => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        my $entry = $attr->{entry};
        if ( $attr->{url} =~ m{page/} ) {
            $attr->{is_success} = 1;
            return;
        }

        if ( $attr->{html} =~ m{.status.:.ok.}six ) {
            $attr->{is_success} = 1;
            my $hashref = $json->decode( $attr->{html} );

# {"status":"ok","albums":[{"album_id":"1961493725","album_name":"\u4e09\u5ce1\u7684\u8bb0\u5fc6","album_logo":"http:\/\/img.xiami.com\/images\/album\/img23\/493723\/4937231361493724_1.jpg","song_count":null},{"album_id":"171300","album_name":"\u6211\u6700\u7231\u7684\u4eba","album_logo":"http:\/\/img.xiami.com\/images\/album\/img7\/7\/171300_1.jpg","song_count":"10"},{"album_id":"21","album_name":"\u597d\u82b1\u4e0d\u5e38\u5f00","album_logo":"http:\/\/img.xiami.com\/images\/album\/img0\/211281605683_1.jpg","song_count":"10"}],"more":"false"}
            if ( $hashref->{albums} ) {
                for my $e ( @{ $hashref->{albums} } ) {
                    my $link = "http://www.xiami.com/app/iphone/album?id="
                      . $e->{album_id};
                    push @{ $parsed_result->{album} }, {
                        url        => $link,
                        url_md5    => md5_hex($link),
                        status     => 'undo',
                        name       => $e->{album_name},
                        company    => 'no',
                        author     => 'no',
                        category   => $entry->category,
                        website_id => $attr->{website_id},

                    };
                }
            }
            return;
        }

        eval {
            # http://www.xiami.com/artist/album/id/11768/d//p//page/7
            #
            my $author = $dom->at('#artist_albums > h3')->text;
            for my $e ( $dom->find('div.detail')->each ) {
                next unless $e;
                my $name = $e->at('strong')->text;
                my $href = $e->at('a')->{href};
                my $link = $base_url . $href;
                $link =~ s{\?spm=.*}{}sig;
                my $company = $e->at('p.company > a')->text;
                push @{ $parsed_result->{album} },
                  {
                    url        => $link,
                    url_md5    => md5_hex($link),
                    status     => 'undo',
                    name       => $name,
                    company    => $company,
                    author     => $author,
                    category   => $entry->category,
                    website_id => $attr->{website_id},
                  };
            }
        };
        $attr->{is_success} = 0 if $@;
        $attr->{is_success} = 0 if not exists $parsed_result->{album};
    },
    album => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        my $entry     = $attr->{entry};
        my ($id)      = $attr->{url} =~ m{album.*?(\d+)$}six;
        my $published = 1;
        my $language;
        my $publish_date;
        my $company;
        my $album_type;

        my $album_url = "http://www.xiami.com/album/$id";

        eval {
            eval{
            if ( my $c =
                $lua->get($album_url)->res->dom->charset('UTF-8')
                ->at('#album_info > table')->find('tr') )
            {
                if ( $c->size > 0 ) {
                    for my $e ( $c->each ) {
                        next if not $e;
                        if ( $e->all_text =~
                            m/\x{8BED}\x{79CD}\x{FF1A}\s*(.+)\s*/six )
                        {
                            $language = $1;
                        }
                        if ( $e->all_text =~
m/\x{53D1}\x{884C}\x{65F6}\x{95F4}\x{FF1A}\s*(\d+).(\d+).(\d+)/six
                          )
                        {
                            $publish_date = join( '-', $1, $2, $3 );
                        }
                        if ( $e->all_text =~
m/\x{5531}\x{7247}\x{516C}\x{53F8}\x{FF1A}\s*(.+)\s*/six
                          )
                        {
                            $company = $1;
                        }
                        if ( $e->all_text =~ m/专辑类别：\s*(.+)\s*/six ) {
                            $album_type = $1;
                        }
                    }
               }
            }};

            if ( $attr->{html} =~ m{.status.:.ok.}six ) {
                $attr->{is_success} = 1;
                my $hashref = $json->decode( $attr->{html} );
                if ( my $node = $hashref->{album}{songs} ) {
                    if ( ref $node eq 'HASH' ) {
                        my $desc;
                        if( $hashref->{album}{description} ){
                         $desc = Mojo::DOM->new->xml(1)->parse($hashref->{album}{description})->all_text;
                        $desc =~ s{<br />}{\n}g;
                        $desc =~ s{<.+?>}{}g;
                         }
                        for my $song_id ( keys %$node ) {

                            #http://www.xiami.com/song
                            my $link = "http://www.xiami.com/song/$song_id";
                            $hashref->{publish_date} = $publish_date;
                            $hashref->{company}      = $company;
                            $hashref->{language}     = $language;
                            $hashref->{style}        = $album_type;
                            push @{ $parsed_result->{xiage} }, {
                                url        => $link,
                                url_md5    => md5_hex($link),
                                website_id => $attr->{website_id},
                                publisher  => 'no',
                                type       => $node->{$song_id}{category},
                                status     => 'update',
                                album      => $entry->name,
                                hot_num    => $node->{$song_id}{year_play},
                                name       => $node->{$song_id}{name},
                                album_id   => $entry->url_md5,
                                author     => $node->{$song_id}{artist_name},
                                size => $node->{$song_id}{content_size} || 0,

                                # add for buyer
                                company     => $hashref->{company},
                                composer    => $node->{$song_id}{composer},
                                songwriters => $node->{$song_id}{songwriters},
                                style       => $node->{$song_id}{style}
                                  || $hashref->{style},
                                track        => $node->{$song_id}{track},
                                description  => $desc,
                                publish_date => $hashref->{publish_date},
                                lyric        => $node->{$song_id}->{lyric},
                                album_logo   => $node->{$song_id}->{album_logo},
                                title        => $node->{$song_id}->{title},
                                language     => $hashref->{language},
                                location     => $node->{$song_id}{location},
                            };
                        }
                    }
                }
            }
        };
        if( $@ ) {
            $c->log->error("parsing error: $@");
            $attr->{is_success} = 0;
        }
    },
    xiage => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        my $entry = $attr->{entry};
        eval {
            my $json_hashref = $json->decode( delete $attr->{html} );
            die 'get undef json' if not ref $json_hashref;
            my $hq_location = $c->track_hq_location( $json_hashref->{song_id} );
            die 'get hq location failed' if not $hq_location;
            my $download_info = {
                album     => $entry->album,
                song_id   => $json_hashref->{song_id},
                song_name => $entry->name,
                category  => $entry->type,
                size      => $json_hashref->{content_size},
                artist    => $json_hashref->{singers},
                resource  => {
                    lrc => {
                        name     => $entry->name . ".lrc",
                        location => $json_hashref->{lyric},
                    },
                    mp3 => {
                        location => $hq_location || $json_hashref->{location},
                        size => $json_hashref->{content_size},
                        name =>
                          join( "_", $entry->name, $json_hashref->{song_id} )
                          . ".mp3",
                    },
                    logo => {
                        location => $json_hashref->{album_logo},
                        name =>
                          join( "_", $entry->name, $json_hashref->{song_id} )
                          . ".jpg",
                    },
                }
            };
            my $ok =
              $c->multi_download( $c->spec_mp3_download_path($download_info) );
            die "multi_download failed" unless $ok;

            my $dl_path = File::Spec->catdir(
                $c->option->{$site}->{music_path},
                $entry->type, $json_hashref->{singers},
                $entry->album, $entry->name
            );
            my $mp3_file = File::Spec->catfile( $dl_path,
                $download_info->{resource}{mp3}{name} );
            my $logo = File::Spec->catfile( $dl_path,
                $download_info->{resource}{logo}{name} );
            eval {
                $c->modify_id3_info(
                    $mp3_file,
                    {
                        artist     => $json_hashref->{singers},
                        album      => $entry->album,
                        title      => $entry->{singers},
                        album_logo => $logo,
                    }
                );
                $c->log->debug("make a mp3 tag success");
            };
            die if $@;

=pod
    album      => '无与伦比的美丽',
    artist     => '苏打绿',
    title      => '无与伦比的美丽',
    album_logo => $image,
=cut

        };
        if ($@) {
            $attr->{is_success} = 0;
            $c->log->debug("this is a error : $@");
        }
    },
);

$c->run($task_id);
