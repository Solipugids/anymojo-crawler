package Crawler::Logging::Logger;

use base 'Mojo::Log';
use Data::Dumper;

sub dumper {
    my ( $self, $dump_var ) = @_;
    $self->debug( Dumper($dump_var) );
}

1;

