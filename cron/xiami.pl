use strict;
use warnings;
my $task_id = shift;
while(1){
    print "perl /Users/mooser/anymojo-crawler/bin/xiami.com/crawler.pl -site xiami.com -task_id $task_id\n";
    `perl /Users/mooser/anymojo-crawler/bin/xiami.com/crawler.pl -site xiami.com -task_id $task_id`;
    print "sleep 1200\n";
}
exit(0);
