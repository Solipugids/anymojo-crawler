package Crawler::Publisher::WordPress;

use Moo;

extends "WordPress::XMLRPC", "Moo::Object";
with 'Crawler::Logging';

sub new {
    my $class = shift;
    my $obj = $class->SUPER::new(@_);
    return $class->meta->new_object(

        # pass in the constructed object
        # using the special key __INSTANCE__
        __INSTANCE__ => $obj,
        @_,    # pass in the normal args
    );
}

sub new_post {
    my ( $self, $content_hashref, $is_publish ) = @_;

    require utf8;
    for my $item (qw(description categories title custom_fields)) {
        next if not $content_hashref->{$item};
        if ( ref $content_hashref->{$item} eq 'ARRAY' ) {
            for my $e ( @{$content_hashref->{$item}} ) {
                if( ref($e) eq 'ARRAY'){
#                    utf8::encode($_->value ) for @$e;
                }
                else{
#                    utf8::encode($e);
                }
            }
        }
        else {
#            utf8::encode( $content_hashref->{$item} );
        }
    }
    eval {
        local $SIG{ALRM} = sub { die "timeout" };
        alarm(300);
        $self->newPost( $content_hashref, 1 ) or die $self->errstr;
        alarm(0);
    };
    alarm(0);
    if ($@) {
        $self->log->error($@);
        return 0;
    }

    return 1;
}

1;
