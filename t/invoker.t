use strict;
use warnings;
use Digest::MD5 qw(md5_hex);
use Test::More qw(no_plan);
use YAML qw(Dump);
use lib "../lib";
use 5.010;

BEGIN{
    use_ok('Crawler::Invoker');
}

my $site = 'tz100';
my $project_path = $ENV{PROJECT_PATH};
my $config =
  File::Spec->catfile( split( '/', $project_path ), 'conf', 'crawler.yaml' );

my $invoker = Crawler::Invoker->new(
    conf => $config,



