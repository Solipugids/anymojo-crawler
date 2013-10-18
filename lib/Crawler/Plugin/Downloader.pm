package Crawler::Plugin::Downloader;

# defined a role  for download
use Moo::Role;

use File::Temp qw/ :POSIX /;
use FileHandle;
use AnyEvent::MultiDownload;
use List::Util qw(shuffle);
use Digest::MD5 qw(md5_hex);
use Encode qw(decode_utf8 encode_utf8);
use YAML 'Dump';
use File::Spec;
use Encode qw(encode_utf8);
use File::Path qw(make_path);
use File::Basename qw(dirname basename);
use Mojo::UserAgent;
use Mojo::Util qw(spurt);
use AnyEvent;
use EV;
use AnyEvent::HTTP;

${AnyEvent::HTTP::MAX_RECURSE} = 5;
${AnyEvent::HTTP::MAX_PER_HOST} =8;

sub multi_download {
    my ( $self, $file_hash, $cb, $cv ) = @_;

    my $file_num = scalar( keys %$file_hash );
    my $stat     = {};

    # begin download file non-blocking mode
    for my $link ( shuffle keys %$file_hash ) {
        my $file_name = $file_hash->{$link}->{file};
        my $file_size = $file_hash->{$link}->{size};
        $self->log->debug("begin download file => $link #####");
        my $dir  = dirname($file_name);
        my $name = basename($file_name);
        if( not $link=~ m/m3.file/ ){
            $cv->begin;
            http_get $link=> sub {
                my ( $body, $hdr ) = @_;
                eval {
                    my $tmp_file = File::Spec->catfile( dirname($file_name),
                        basename($file_name) . time );
                    my $fh = FileHandle->new(">$tmp_file") or die $@;
                    binmode($fh);
                    print $fh $body;
                    close($fh);
                    rename $tmp_file => $file_name;
                    $cb->(1);
                };
                if ($@) {
                    $self->log->error("download file error !!!!!!!");
                }
                else {
                    $self->log->debug(
                        "downloa file by single http=> $file_name OK!");
                }
                $cv->end;
            };
        }else{
            local $SIG{ALRM} = sub { die "timeout"};
            my $exists_size = -s $file_name;
            if ( -e $file_name and $file_size and $exists_size >= $file_size) {
                $self->log->debug("download file is downloaded full,next next!!!!");
                $cb->(1);
                $cv->begin;
                $cv->end;
            }
            eval{
                alarm 300;
                my $tmp_file = File::Spec->catfile( dirname($file_name),
                        basename($file_name) . time );
                my $rc = system("curl","-l",$link,"-o",$tmp_file);
                if( $rc == 0 ){
                    rename $tmp_file,$file_name;
                    $cb->(1);
                }
                alarm 0;
            };
            if( $@ ){
                $self->log->debug("download file error : $@");
            }
            $cv->begin;
            $cv->end;
        }
=pod
        else {
            $self->anyevent_download( $link, $file_name, $file_size, $cb, $cv );
        }

        #$self->download( $link, $file_name, $file_size, $cb, $cv );
=cut
        }            
}

sub anyevent_download {
    my ( $c, $url, $file, $size, $callback, $cv ) = @_;

    my $exists_size = -s $file;
    if ( -e $file and $size and $exists_size >= $size ) {
        $cv->begin;

        #  9242532 => 9278464
        $c->log->debug("file => $file is full downloaded ,next .......");
        $callback->(1);
        $cv->end;
    }
    else {
        $cv->begin;

        unlink $file;
        my $content_lenth;
        my $md = AnyEvent::MultiDownload->new(
            url           => $url,
            max_retries   => 3,
            max_per_host  => 8,
            seg_size      => 3 * 1024 * 1024,
            content_file  => $file,
            on_seg_finish => sub {
                my ( $hdr, $seg, $size, $chunk, $cb ) = @_;
                $cb->(1);
            },
            on_finish => sub {
                my $len = shift;
                $c->log->debug("download $file => $len OK!!!");
                $callback->($file);
                $cv->end;
            },
            on_error => sub {
                my $error = shift;

                $c->log->debug(
                    "Download file => $file error : " . decode_utf8($error) );
                $cv->end;
            }
        )->multi_get_file;
    }
}

sub download {
    my ( $self, $url, $file, $size, $cb ) = @_;

    if ( -e $file and $size and -s _ == $size ) {
        $self->log->debug("file => $file is fully downloaded,next!!!!");
        $cb->($file);
    }
    else {
        unlink $file;
        my $tmp_file = tmpnam();
        my $retry    = 0;
        while ( $retry < 3 ) {
            $retry++;
            eval {
                local $SIG{ALRM} = sub { die 'timeout download' };
                alarm 1200;
                $self->log->debug(
                    "the $retry times download file => $file .....");

                my $cmd = "wget -c $url -O $tmp_file";
                my $r   = system($cmd);
                if ( $r and $retry == 3 ) {
                    die "download $file retry 3 times failed";
                }
                alarm 0;
            };
            if ($@) {
                $self->log->error("Download file error: $@");
            }
            else {
                my $real_size = -s $tmp_file;
                if ( $size and $real_size != $size ) {
                    $self->log->error(
                        "partial download error: $real_size ne $size");
                }
                else {
                    rename $tmp_file => $file;
                    $cb->($file);
                    $self->log->debug("Downloaded file => $file!!!!");
                }
                last;
            }
        }
    }

    return 1;
}

sub spec_mp3_download_path {
    my ( $self, $download_info ) = @_;

    my $site      = $self->site;
    my $album     = delete $download_info->{album};
    my $artist    = delete $download_info->{artist};
    my $song_id   = delete $download_info->{song_id};
    my $song_name = delete $download_info->{song_name};
    my $type      = delete $download_info->{category};

    if ( not $type ) {
        $type = 'other';
    }
    if ( not $album ) {
        $album = 'ep';
    }
    my $dl_path = File::Spec->catdir( $self->option->{$site}->{music_path},
        $type, $artist, $album, $song_name );
    make_path $dl_path
      or die "create file path $dl_path failed"
      if not -d $dl_path;

    my $file_hash;
    for my $item ( keys %{ $download_info->{resource} } ) {
        my $dl_link = $download_info->{resource}{$item}{location};
        my $name    = $download_info->{resource}{$item}{name};
        my $size    = $download_info->{resource}{$item}{size} || 0;
        if ($dl_link) {
            $file_hash->{$dl_link}{file} =
              File::Spec->catfile( $dl_path, $name );
            $file_hash->{$dl_link}{size} = $size;
        }
    }
    return $file_hash;
}

1;
