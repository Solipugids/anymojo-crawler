use strict;
use warnings;
use Test::More qw(no_plan);
use Crawler::DB::Schema;
use Digest::MD5 qw(md5_hex);
use lib "../lib";

BEGIN {
    use_ok("Crawler::Task");
}

my $dsn    = 'DBI:mysql:dbname=crawler;host=127.0.0.1';
my $schema = Crawler::DB::Schema->connect(
    $dsn, 'root', '',
    {
        mysql_enable_utf8 => 1
    }
);

$schema->storage->debug(1);
my $task       = Crawler::Task->new( db_helper => $schema );
$task->log->level('info');
my $task_type  = "finder";
my $website_id = 1;
my $task_id    = 1;

use Mojo::UserAgent;
my $ua  = Mojo::UserAgent->new;
my $dom = $ua->get('http://www.mgpyh.com')->res->dom;
use YAML qw(Dump);
use 5.010;
my @category = ();
for my $e( $dom->at('#widget_categories')->find('a')->each ){
    push @category,$e->{href};
    my $feeder = {
        url_md5 => md5_hex($e->{href}),
        url => $e->{href},
        website_id => 2,
        status => 'undo',
    };
    $schema->resultset('Feeder')->find_or_create($feeder);
}

# gen_task_by_type
# type,url,website_id,
$website_id  = 2;
for my $feeder ( @category ){
    is($task->gen_task_with_feeder("finder",$website_id,$feeder),1,'test insert new feeder task ');
}
is( scalar( $task->get_task_by_status($website_id,'undo') ) > 0, 1, 'test get_undo_task' );
my $single = $task->get_task_by_status($website_id,'undo');
is( $single->status,'undo','test get single status undo');
is( $task->update_task_status( $task_id,'fail'),
    1, 'test update task status' );
my $rs= $schema->resultset('Task')->find({ id=> $task_id,status => 'fail'} );
is( $rs->status,'fail','test update task status');
is( $task->update_task_status( $task_id, 'success' ),
    1, 'test update task success status' );
$rs = $schema->resultset('Task')->find({ id => $task_id } );
is( $rs->status,'success','test update task success status');
# poll_task;













