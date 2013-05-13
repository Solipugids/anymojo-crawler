use strict;
use warnings;
use Test::More qw(no_plan);
use lib "../lib";

BEGIN{
    use_ok("Crawler::Task");
}

my $task = Crawler::Task->new();
my $task_type = "finder";
my $website_id =1;
my $task_id = 1;
is( $task->gen_task_by_type("feeder")> 0 ,1,"test gen task by type");
is( scalar( $task->get_undo_task($website_id) ) >0,1,'test get_undo_task');
is( scalar( $task->get_fail_task($website_id) ) >0,1,'test get failed task');
is(  $task->udpate_task_status($task_id,'fail'),1,'test update task status');




