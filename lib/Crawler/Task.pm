package Crawler::Task;

use Crawler::Base -strict;
use Moo;

extends 'Crawler::Logging';

has db_helper => ( is => 'ro', required => 1 );

sub gen_task_with_feeder {
    my ( $self, $website_id ) = @_;

    for my $feeder_info ( $self->db_helper->find_undo_feeder($website_id) ) {
        $self->db_helper->gen_new_task('feeder');
    }
}

1;
