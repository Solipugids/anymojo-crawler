package Crawler::Logging;

use Crawler::Base -strict;
use Mojo::Log;
use Moo::Role;
use ENV;

has log => (
    is      => 'rw',
    default => sub {
        my $log = Mojo::Log->new();
        $log->path( $ENV{CRAWLER_LOG_PATH} );
        $log->level( $ENV{CRAWLER_LOG_LEVEL} );
        return $log;
    },
    lazy => 1
);

1;

