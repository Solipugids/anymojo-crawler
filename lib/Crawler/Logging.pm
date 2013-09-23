package Crawler::Logging;

use Crawler::Base -strict;
use Moo::Role;
use Crawler::Logging::Logger;
use ENV;
use YAML qw(Dump);

has log => (
    is      => 'rw',
    default => sub {
        my $log = Crawler::Logging::Logger->new();
        $log->path( $ENV{CRAWLER_LOG_PATH});
        $log->level( $ENV{CRAWLER_LOG_LEVEL} || 'debug' );
        return $log;
    },
    lazy => 1
);

sub dump{
    my $self = shift;
    if( ref $_[0] ){
        $self->log->info(Dump($_[0]));
    }
}
1;

