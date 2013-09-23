package Crawler::Plugin::WordPressUploader;

use Moo;
use Crawler::Base -strict;
use Digest::MD5 qw(md5_hex);
use Encode qw(encode decode);
use EV;
use AnyEvent;
use Crawler::UserAgent;
use File::Spec;
use WordPress::XMLRPC;
use File::Path qw(make_path);

with 'Crawler::Logging';

has ua => (
    is      => 'rw',
    default => sub { Crawler::UserAgent->new( max_redirects => 5 ); }
);
has cv => ( is => 'rw', default => sub { AnyEvent->condvar } );
has wp => ( is => 'rw', required => 1 );

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
        $self->log->debug("get uploaded url: ".$r->{url});
        return $r->{url};
    }
    undef;
}

1;

