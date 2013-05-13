use utf8;
use strict;
use warnings;
use Test::More qw(no_plan);
use lib "../lib";

BEGIN {
    use_ok("Crawler::DB::Schema");
}

my $dsn    = 'DBI:mysql:dbname=crawler;host=127.0.0.1';
my $schema = Crawler::DB::Schema->connect( $dsn, 'root', '' );
my $dbh    = $schema->storage->dbh;
## Please see file perltidy.ERR
isa_ok( $schema, 'Crawler::DB::Schema' );
my @website_data = (
    {
        name   => '什么值得买',
        url    => 'http://smzdm.com',
        type   => '海淘',
        region => 'china',
    },
    {
        name   => '买个便宜货',
        url    => 'http://mgpyh.com',
        type   => '海淘',
        region => 'china',
    }
);

