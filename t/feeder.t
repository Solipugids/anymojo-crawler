use Test::More;
use Test::Deep;
use Data::Dumper;
use 5.010;

BEGIN {
    use_ok("Crawler::Feeder");
}
my $cv = AnyEvent->condvar;

my $feeder = Crawler::Feeder->new( url => "http://mooser.me:4000" );
is( $feeder->isa("Crawler::Entry::Feeder"), 1, 'feeder isa Crawler::Feeder' );
$feeder->cookie_jar(1);
$feeder->reg_parser(
);
is( $feeder->user_agent->cookie_jar->isa("Mojo::UserAgent::CookieJar"),
    1, 'test cookie_jar options' );

$feeder->start;
is( $feeder->get_feeders > 0, 1, 'test get_feeders return scalar ' );
my @list = $feeder->get_feeders;
my @expect = qw(perl moose life mojo AnyEvent vim);
is_deeply(@list,@expect,'compare parsed feeder result');

done_testing();

