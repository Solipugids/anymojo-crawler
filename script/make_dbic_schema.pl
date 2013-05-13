use FindBin qw/$Bin/;
use DBIx::Class::Schema::Loader qw/ make_schema_at /;

my $dbname = "$Bin/db.sqlite";
make_schema_at(
    'Crawler::DB::Schema',
    { debug => 1 ,use_moo => 1,dump_directory => '../lib' },
    ['dbi:mysql:crawler:127.0.0.1', 'root', '',],
);
