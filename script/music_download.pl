use AnyEvent;
use AnyEvent::Handle;
use AnyEvent::MultiDownload;
use HTTP::Request;
use Crawler::Base -strict;
use AnyEvent::Curl::Multi;
use File::Spec;
use Mojo::Util qw(slurp spurt);
use File::Basename qw(basename dirname);
use File::Find;
use List::Util qw(shuffle);
use Parallel::ForkManager;
use Mojo::JSON;
use AnyEvent::HTTP;
use Crawler;

my $j           = Mojo::JSON->new;
my $dir         = shift;
my $watch_count = 5;

my $dbh;

my $config = File::Spec->catfile( split( '/', $ENV{PROJECT_PATH} ),
    'conf', 'crawler.yaml' );
my $site = 'xiami.com';
my $c    = Crawler->new(
    conf => $config,
    site => $site,
);
$c->login_xiami;

open( my $dh, $dir ) or die "can't open this $dir";

my $pm        = Parallel::ForkManager->new(2);
my $is_forked = 0;
while (1) {
    print "sleep 5 seconds......";
    sleep(2);
    my @watch_list = ();
    my $count      = 0;
    my $cv         = AnyEvent->condvar;
    while ( readdir($dh) ) {
        if( /(.*ready$)/ ){
            $count =
            my $cv         = AnyEvent->condvar;
            my $count      = 0;
            my $time1      = time;
            my @watch_list = watch_ready($dir);
            for ( shuffle @watch_list ) {
                my $location = $c->track_hq_location( $_->{tag}{id} );
                my ($key)      = grep { /m3.file/ } keys %{ $_->{download} };
                my ($mp3_size) = $_->{download}->{$key}->{size};
                my $file       = $_->{download}->{$key}->{file};
                $_->{download}->{$location}->{file} = $file;
                $_->{download}->{$location}->{size} = $mp3_size;
                delete $_->{download}{$key};
                my $download_info = $_->{download};

                for my $url ( keys %$download_info ) {
                    my $size = $download_info->{$url}{size} || 0;
                    my $file = $download_info->{$url}{file};
                    $cv->begin;
                    if ( $size and -s $file == $size ) {
                        $c->log->debug(
                            "This file is fully downloaded,next!!!!!");
                        $cv->end;
                    }
                    else {
                        unlink $file;
                        my $md = AnyEvent::MultiDownload->new(
                            url           => $url,
                            content_file  => $file,
                            seg_size      => 1 * 1024 * 1024,    # 1M
                            on_seg_finish => sub {
                                my ( $hdr, $seg, $size, $chunk, $cb ) = @_;
                                $cb->(1);
                            },
                            on_finish => sub {
                                my $len = shift;
                                $count++;
                                if ( $size and $size != $len ) {
                                    $c->log->debug(
                                "download file len: $len => size :$size not ok!"
                                    );
                                }
                                else {
                                    $c->log->debug(
                                        "download file size => $file OK!");
                                }
                                $cv->end;
                            },
                            on_error => sub {
                                my $error = shift;
                                $c->log->debug(
                                    "Download file => $file error : $error");
                                $cv->end;
                            }
                        )->multi_get_file;
                    }

                    #system("curl","-C","-l",$url,"-o",$file);
                    #download( $link, $file, $cb, $size );
                }
            }

            #$pm->wait_all_children;
            $cv->recv;

            my $time2 = time;
            $c->log->debug( "download $count files ,total cost "
                  . ( $time2 - $time1 )
                  . " secs!" );
        }
    }

    sub watch_ready {
        my ($dir)         = @_;
        my @download_list = ();
        my $count         = 0;
        my $cb            = sub {
            my $name = ${File::Find::name};
            if ( -r $name and $name =~ m/ready$/ ) {
                $count++;
                my $hashref = $j->decode( slurp($name) );
                push @download_list, $hashref;

                #unlink $name;
                die if $count == 15;
            }
        };
        eval { find( $cb, $dir ); };
        return @download_list if $@;
    }

}

