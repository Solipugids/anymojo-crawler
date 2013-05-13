use strict;
use warnings;
use Test::More qw(no_plan);
use lib "../lib";

BEGIN{
    use_ok("Crawler");
}

my $c = Crawler->new(
    conf => { 
        log => {
            path => '/tmp/crawler.log',
            level => 'debug',
        },
        meta_db => {
            dsn => '127.0.0.1:27107',
            user => 'root',
            passwd => 'root',
        },
    },
    site => 'www.mgpyh.com',
    scan_start_time => undef,
    scan_stop_time => undef,
    debug => 1,
    source_type => 'archive',
);

is($c->site,'mooser.me','test crawler passed task arg');
is($c->scan_start_time,undef,'test scan_start_time arg');
is($c->scan_stop_time,undef,'test scan_stop_time arg');
is($c->debug,1,'test debug args');
is($c->log->path,'/tmp/crawler.log','test log path args');
is($c->log->level,'debug','test debug level args');
$c->register_parser(
    feeder => sub {
    },
    pages => sub {
    },
    post => sub {
    },
);
# task_id =>1 
$c->run(1);
