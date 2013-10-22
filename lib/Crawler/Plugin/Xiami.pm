package Crawler::Plugin::Xiami;

use Moo::Role;
use Storable;
use Mojo::UserAgent::CookieJar;
use Crawler::Base -strict;
use Digest::MD5 qw(md5_hex);
use Encode qw(encode decode);
use YAML qw(Dump);
use Mojo::IOLoop;
use Crawler::UserAgent;
use File::Spec;
use Mojo::UserAgent;
use File::Path qw(make_path);
use Mojo::Util qw(slurp spurt url_unescape);
use POSIX qw(floor);
use Mojo::JSON;
use utf8;

has username => ( is => 'ro', default => 'thomaslyang@qq.com', lazy => 1 );
has _ua => ( is => 'rw', default => sub { Mojo::UserAgent->new }, lazy => 1 );
has vip_validate => ( is => 'ro', default => '夢之畫君', lazy => 1 );
has gethqsong => (
    is => 'ro',
    default =>
#'http://duoluohua.com/myapp/api/xiami/getsong/?action=getsong&songid=#sid',
'http://www.xiami.com/song/gethqsong?sid=#sid',
    lazy => 1
);
has json => ( is => 'rw', default => sub { Mojo::JSON->new }, lazy => 1 );
has password => ( is => 'ro', default => '123456', lazy => 1 );
has submit   => ( is => 'ro', default => '登录',      lazy => 1 );
has referer  => (
    is => 'rw',
    default =>
'http://www.xiami.com/song/play?ids=/song/playlist/id/#sid/object_name/default/object_id/0',
    lazy => 1
);
has login_url => (
    is      => 'ro',
    default => 'http://www.xiami.com/member/login',
    lazy    => 1
);

around process_download => sub {
    my ( $origin, $self, $url, $entry, $task_rs, $entry_rs, $cv ) = @_;

    if ( $url =~ m{xiami.com/artist/album/id/(\d+)$}six ) {
        my $id = $1;
        $url = 'http://www.xiami.com/app/iphone/artist?id=' . $id;
        $self->$origin( $url, $entry, $task_rs, $entry_rs, $cv );
    }

    # http://www.xiami.com/app/iphone/album?id=486126
    # http://xiami.com/album/171456
    if ( $url =~ m{xiami.com/album/(\d+)}six ) {
        my $id = $1;
        $url = 'http://www.xiami.com/app/iphone/album?id=' . $id;

        #$self->$origin( $url, $entry, $task_rs, $entry_rs, $cv );
        $self->$origin( $url, $entry, $task_rs, $entry_rs, $cv );
    }

    #$self->$origin( $url, $entry, $task_rs, $entry_rs, $cv );

    #http://xiami.com/song/1769908304
    if ( $url =~ m{/song/(\d+)$} ) {
        eval {
            my $song_id = $1;
            $url = 'http://www.xiami.com/app/iphone/song?id=' . $song_id;
            my $cb = sub {
                my $ua          = shift;
                my $hq_location = $self->track_hq_location($song_id);
                if ( not $hq_location ) {
                    $cv->begin;
                    $cv->end;
                    return;
                }
                my $download_info = {
                    album     => $entry_rs->album,
                    song_id   => $song_id,
                    song_name => $entry_rs->name,
                    category  => $entry_rs->type,
                    size      => $entry_rs->size,
                    artist    => $entry_rs->author,
                    resource  => {
                        lrc => {
                            name     => $song_id . ".lrc",
                            location => $entry_rs->lyric,
                        },
                        mp3 => {
                            location => $hq_location,
                            size     => $entry_rs->size,
                            name     => $song_id.".mp3",
                        },
                        logo => {
                            location => $entry_rs->album_logo,
                            name     => $song_id.".jpg",
                        },
                    }
                };
                $self->log->debug("gen resource_info => ".Dump $download_info);
                my $file_hash = $self->spec_mp3_download_path($download_info);
                my $dl_path   = File::Spec->catdir(
                    $self->option->{ $self->site }->{music_path},$song_id
                );
                ( my $rel_path = $dl_path ) =~ s{(.*?)xiami}{xiami}g;
                $entry_rs->rel_path($rel_path);
                my $stat_hashref;
                my $album_logo = File::Spec->catfile( $dl_path,$song_id.".jpg");
                my $mp3_file = File::Spec->catfile( $dl_path,$song_id.".mp3");
                my $lrc_file = File::Spec->catfile( $dl_path,$song_id.".lrc");

                my $cb = sub {
                    if ( -e $mp3_file ) {
                        if (    not $entry_rs->album_logo
                            and not $entry_rs->lyric )
                        {
                            my $rc =
                              $self->modify_id3_info( $mp3_file, $entry_rs );
                            $self->log->debug(
                                "make a ID3 tag for " . $mp3_file );
                            $entry_rs->status('success') if $rc;
                            $entry_rs->update;
                        }
                        if ( not $entry_rs->album_logo and $entry_rs->lyric ) {
                            if ( -e $lrc_file ) {
                                my $rc =
                                  $self->modify_id3_info( $mp3_file, $entry_rs,
                                    undef, $lrc_file );
                                $self->log->debug(
                                    "make a ID3 tag for " . $mp3_file);
                                $entry_rs->status('success') if $rc;
                                $entry_rs->update;
                            }
                        }
                        if ( $entry_rs->album_logo and not $entry_rs->lyric ) {
                            if ( -e $album_logo ) {
                                my $rc =
                                  $self->modify_id3_info( $mp3_file, $entry_rs,
                                    $album_logo, );
                                $self->log->debug(
                                    "make a ID3 tag for " . $mp3_file);
                                $entry_rs->status('success');
                                $entry_rs->update;
                            }
                        }
                        if ( $entry_rs->album_logo and $entry_rs->lyric ) {
                            if ( -e $album_logo and -e $lrc_file ) {
                                my $rc = $self->modify_id3_info(
                                    $mp3_file,   $entry_rs,
                                    $album_logo, $lrc_file
                                );
                                $self->log->debug(
                                    "make a ID3 tag for " . $mp3_file );
                                $entry_rs->status('success');
                                $entry_rs->update;
                            }
                        }
                    }
                };
                $self->multi_download( $file_hash, $cb, $cv );
            };

            #my $tx = $self->user_agent->get($url);
            $cb->( $self->user_agent );
        };
    }
    if ($@) { $self->log->error($@); }
};

before run => sub { print "before run here "; shift->login_xiami };

sub login_xiami {
    my ( $self, $cookie ) = @_;

    $cookie ||= 'xiami.cookie';
    my $cookie_path =
      File::Spec->catfile( $ENV{PROJECT_PATH}, 'bin', $self->site, $cookie );
    my $login_ok = 0;

# http://www.xiami.com/song/play?ids=/song/playlist/id/${sid}/object_name/default/object_id/0
# if cookie is ready,set ua and return
    if (    -e $cookie_path
        and ( -M $cookie_path < 3 )
        and ( -s $cookie_path ) > 10 )
    {
        $self->user_agent->cookie_jar( retrieve($cookie_path) );
        $self->log->debug("load cookies form $cookie_path");
        $login_ok = 1;
    }

    return $login_ok if $login_ok;

    # save cookie file here
    my $ua = $self->user_agent;
    $ua->max_redirects(1);
    $ua->cookie_jar( Mojo::UserAgent::CookieJar->new );
    my $headers =
      { 'User-Agent' =>
'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.76 Safari/537.36',
      };
    my $form = {
        done     => 'http://www.xiami.com',
        email    => $self->username,
        password => $self->password,
        submit   => $self->submit,
    };
    my $tx = $ua->post( $self->login_url => $headers => form => $form );
    if ( $tx->res->code == 200 ) {
        store $ua->cookie_jar, $cookie_path;
        $self->log->debug( "login xiami.com success,save cookie :"
              . Dump( $ua->cookie_jar )
              . "to $cookie_path" );
        $login_ok = 1;
    }
    else {
        $self->log->error(
            "login Xiami failed,check you login args and network");
    }
    return $login_ok;
}

sub track_hq_location {
    my ( $self, $song_id ) = @_;
    my $location;

    return if not $song_id =~ m/^\d+$/;

    ( my $gethqsong = $self->gethqsong ) =~ s{#sid}{$song_id}g;
    ( my $referer   = $self->referer ) =~ s{#sid}{$song_id}g;
    my $header = { Referer => $referer };
    #$header->{"User-Agent"} = rand_useragent();
    # block request
    eval {
        ( my $referer = $self->referer ) =~ s{#sid}{$song_id}g;
        #my $header = { Referer => $referer };
        my $local_ua = Mojo::UserAgent->new;
        $self->rand_cookie($local_ua);
        $location = _decrypt_location(
            $local_ua->get($gethqsong)->res->json('/location') );
        if( not $location ){
            $self->rand_cookie($local_ua);
            $location = _decrypt_location(
                $local_ua->get($gethqsong)->res->json('/location') );
        }
        die "get location failed " if not $location;
        $self->log->debug("get hq_location here => $location");
    };
    if ($@) {
        $self->log->error("get hqsong address failed: $@");
        die;
    }

    return $location;
}

sub _decrypt_location {
    my $location = shift;
    return if not defined $location;
    my $loc_2    = int( substr( $location, 0, 1 ) );
    my $loc_3    = substr( $location, 1 );
    return if not $loc_2;

    my $loc_4  = floor( length($loc_3) / $loc_2 );
    my $loc_5  = length($loc_3) % $loc_2;
    my @loc_6  = ();
    my $loc_7  = 0;
    my $loc_8  = '';
    my $loc_9  = '';
    my $loc_10 = '';

    while ( $loc_7 < $loc_5 ) {
        $loc_6[$loc_7] = substr( $loc_3, ( $loc_4 + 1 ) * $loc_7, $loc_4 + 1 );
        $loc_7++;
    }
    $loc_7 = $loc_5;
    while ( $loc_7 < $loc_2 ) {
        $loc_6[$loc_7] = substr( $loc_3,
            $loc_4 * ( $loc_7 - $loc_5 ) + ( $loc_4 + 1 ) * $loc_5, $loc_4 );
        $loc_7++;
    }
    $loc_7 = 0;
    while ( $loc_7 < length( $loc_6[0] ) ) {
        $loc_10 = 0;
        while ( $loc_10 < scalar(@loc_6) ) {
            my @str_list = split( '', $loc_6[$loc_10] );
            $loc_8 .= defined $str_list[$loc_7] ? $str_list[$loc_7] : '';
            $loc_10++;
        }
        $loc_7++;
    }

    ( my $http_location = url_unescape($loc_8) ) =~ s{\^}{0}g;
    return $http_location;
}

# return upload url
sub upload_image {
    my ( $self, $md5, $src ) = @_;

    my $resource_path =
      File::Spec->catfile( $ENV{RESOURCE},
        File::Spec->catdir( "/", unpack( 'a3a3', $md5 ) ), $md5 );
    make_path($resource_path) if not -d $resource_path;
    my $file_name = ( split( '/', $src ) )[-1];
    my $abs_file_path = File::Spec->catfile( $resource_path, $file_name );

    if ( $ENV{HTTP_PROXY} ) {
        $self->ua->http_proxy( $ENV{HTTP_PROXY} );
    }
    my $tx = $self->ua->get($src);
    if ( not $tx->success ) {
        $self->log->error("get img src : $src broken");
        return;
    }

    $tx->res->content->asset->move_to($abs_file_path);
    if ( -e $abs_file_path ) {
        $self->log->debug("Begin upload file to wordpress");
        my $r = $self->wp->newMediaObject(
            WordPress::XMLRPC::abs_path_to_media_object_data($abs_file_path) );
        $self->log->debug( "get uploaded url: " . $r->{url} );
        return $r->{url};
    }
    undef;
}

sub rand_useragent{
    my @agent_list = (
   "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/22.0.1207.1 Safari/537.1",
        "Mozilla/5.0 (X11; CrOS i686 2268.111.0) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.57 Safari/536.11",\
        "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1092.0 Safari/536.6",\
        "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1090.0 Safari/536.6",\
        "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/19.77.34.5 Safari/537.1",\
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.9 Safari/536.5",\
        "Mozilla/5.0 (Windows NT 6.0) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.36 Safari/536.5",\
        "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1063.0 Safari/536.3",\
        "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1063.0 Safari/536.3",\
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_0) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1063.0 Safari/536.3",\
        "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1062.0 Safari/536.3",\
        "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1062.0 Safari/536.3",\
        "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.1 Safari/536.3",\
        "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.1 Safari/536.3",\
        "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.1 Safari/536.3",\
        "Mozilla/5.0 (Windows NT 6.2) AppleWebKit/536.3 (KHTML, like Gecko) Chrome/19.0.1061.0 Safari/536.3",\
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.24 (KHTML, like Gecko) Chrome/19.0.1055.1 Safari/535.24",\
        "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/535.24 (KHTML, like Gecko) Chrome/19.0.1055.1 Safari/535.24"
    );
    return $agent_list[int(rand(@agent_list))];
}

sub rand_cookie{
    my ($self,$ua) =@_;

    return unless ref $ua;
    my $domain = 'mailinator.com';
    my @list = (1..150);
    my $rand = sprintf ("%0.03d",$list[int(rand(@list))]);
    my $rand_cookie = "xm".$rand;
    my $cookie_path = File::Spec->catfile($ENV{PROJECT_PATH},'bin',$self->site,$rand_cookie);
    $ua->cookie_jar( retrieve($cookie_path) );
    $self->log->debug("load rand cookie from $cookie_path");
}

1;

