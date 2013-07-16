use strict;
use warnings;
use Test::More qw(no_plan);
use lib "../lib";

BEGIN {
    use_ok("Crawler::Parser");
}

my $parser = Crawler::Parser->new(
    conf => {
        url_pattern => {
            '.*?/pages/\d+' => 'pages'
        }
    },
);

my @url_list = qw(
  http://mooser.me/pages/1
  http://mooser.me/pages/2
  http://mooser.me/pages/3
  http://mooser.me/pages/4
  http://mooser.me/pages/5
);

$parser->reg_cb(
    pages => sub {
        print "I am page parser\n";
    },
);

for my $url (@url_list) {
    my $entry = $parser->get_parser_by_urlpattern($url);
    print "get entry is ", $entry, "\n";
    $parser->parse($entry);
}

