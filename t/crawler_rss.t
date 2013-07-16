use strict;
use warnings;
use Digest::MD5 qw(md5_hex);
use Test::More qw(no_plan);
use YAML qw(Dump);
use lib "../lib";
use 5.010;

my $site = 'tz100';
my $project_path = $ENV{PROJECT_PATH};
my $config =
  File::Spec->catfile( split( '/', $project_path ), 'conf', 'crawler.yaml' );
my $c = Crawler->new(
    conf => $config,
    site => $site,
);

$c->register_parser(
    rss => sub {
        my ($parser,$dom,$parsed_result,$attr) = @_;
        my $items = $parser->rss->parse($attr->{html});
        for my $item( $items->each ){
    },
    web=> sub {
    },
);
