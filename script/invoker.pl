use Crawler::Base -strict;
use Crawler::Invoker;
use Getopt::Long;
use File::Spec;
use AnyEvent;

my $usage = <<EOF;
$0 -conf crawler.conf -site_list  sitename -debug 1
example:
    $0 -conf ../conf/crawler.yaml -site_list www.mgpyh.com
EOF

my $conf;
my $site_list;
my $debug;

GetOptions(
    "conf=s"      => \$conf,
    "site_list=s" => \$site_list,
    "debug=i"     => \$debug,
) or die $usage;

if ( not $conf ) {
    $conf = File::Spec->catfile( $ENV{PROJECT_PATH}, 'conf', 'crawler.yaml' );
}

unless ( -e $conf and $site_list ) {
    die $usage;
}
my $c = Crawler::Invoker->new( conf => $conf );
$c->schema->storage->debug(1);

my $cv = AnyEvent->condvar;
my $w  = AnyEvent->timer(
    after    => 2,
    interval => 10,
    cb       => sub {
        $c->start( site_list => $site_list );
    },
);
$cv->recv;
