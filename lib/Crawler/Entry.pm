package Crawler::Entry;

use Crawler::Base -strict;
use Moo;

extends 'Crawler::Event';
with 'Crawler::Logging';

has schema => ( is => 'ro', required => 1 );
has mongo  => ( is => 'ro', required => 1 );

sub create_data {
    my ( $self, $entry, $data ) = @_;
    my $rs;
    eval {
        $self->schema->resultset( ucfirst($entry) )->find_or_create( $data );
    };
    if( $@ ){
        $self->log->error("not exists this table $entry in db");
        return 0;
    }
    return 1;
}

1;
