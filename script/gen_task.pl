use Crawler::Base -strict;
use Crawler::Task;
use Getopt::Long;
use Crawler::DB::Schema;
use AnyEvent;

my $dsn    = 'DBI:mysql:dbname=crawler;host=127.0.0.1';
my $schema = Crawler::DB::Schema->connect(
    $dsn, 'root', '',
    {
        mysql_enable_utf8 => 1
    }
);

my $t = Crawler::Task->new(db_helper => $schema);
my $interval = 30;
my $type = 'finder';
my $website_id = shift;
my $w = $t->polling_task_by_site($interval,$type,$website_id);
$t->poll_condvar->recv;



