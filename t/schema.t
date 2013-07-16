use utf8;
use strict;
use warnings;
use Test::More qw(no_plan);
use lib "../lib";

BEGIN {
    use_ok("Crawler::DB::Schema");
}

my $dsn    = 'DBI:mysql:dbname=crawler;host=127.0.0.1';
my $schema = Crawler::DB::Schema->connect( $dsn, 'root', '',{ 
        mysql_enable_utf8 => 1}
);
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
# init website table
for my $website_info( @website_data ){
    ok($schema->resultset('Website')->find_or_create($website_info));
}
my $rs = $schema->resultset('Website')->by_name('什么值得买');
is( $rs->name,'什么值得买','test find by name sql query');
is( $rs->url,'http://smzdm.com','test find by name url ret sql query');
is( $rs->region,'china','test find by name region ret sql query');
$rs = $schema->resultset('Website')->by_url('http://smzdm.com');
is( $rs->name,'什么值得买','test find by url sql query');
is( $rs->url,'http://smzdm.com','test find by url url ret sql query');
is( $rs->region,'china','test find by url region ret sql query');













