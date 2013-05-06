package Crawler::Parser;
use Moo;
use Mojo::DOM;
use Carp;
use Data::Dumper;

#with "Crawler::Logging";

has html => ( is => 'rw' );
has dom => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        Mojo::DOM->new( $self->html );
    }
);

has callbacks => (
    is  => 'rw',
    isa => sub { ref $_[0] eq "HASH" or croak "callbacks should be HashRef" }
);

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;
    if ( @_ == 1 and !ref $_[0] ) {
        return $class->$orig( html => $_[0] );
    }
    else {
        return $class->$orig(@_);
    }
};

sub process {
    my $self  = shift;
    my $rules = shift;
    my ( $ret, $actor );
    while ( my ( $k, $val ) = each %$rules ) {
        my @vals = ref $val ? @$val : ($val);
        my $selector = shift @vals;
        $actor = $1 if $selector =~ s/\/(\S+)//;
        my $node = $self->dom->find($selector);
        if ( $k =~ /(.*)\[\]$/ ) {
            my $item = $1;
            foreach my $child ( $node->each ) {
                my $record;
                if (@vals) {
                    foreach my $valnode (@vals) {
                        while ( my ( $grandchild, $grandval ) = each %$valnode )
                        {
                            $record->{$grandchild} =
                              $self->_get_value( $child, $grandval );
                        }
                    }
                    push @{ $ret->{$item} }, $record;
                }
                else {
                    push @{ $ret->{$item} },
                      $self->_get_value( $child, $actor );
                }
            }
        }
        else {
            $ret->{$k} = $self->_get_value( $self->dom->at($selector), $actor );
        }
    }
    $ret;
}

sub _get_value {
    my ( $self, $node, $actor ) = @_;
    return $node->{$1} if $actor =~ /^\@(.*)/;
    return $self->callbacks->{$1}->($node) if $actor =~ /^\&(.*)/;
    $node->$actor;
}

1;
