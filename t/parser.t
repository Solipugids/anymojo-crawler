use strict;
use warnings;
use Test::More qw/no_plan/;
use Data::Dumper;
use YAML;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";

use_ok("Crawler::Parser");
my $html = <<HTML;
<!doctype html>
  <body>
    <div id="main">
       <div class="item">
           <a href="Item 1 link">Item 1</a>
       </div>
       <div class="item">
           <a href="Item 2 link">Item 2</a>
       </div>
       <div class="pages">
           <a href="#">current page</a>
           <a href="#1">1</a>
           <a href="#2">2</a>
           <a href="#next" class="next">next</a>
       </div>
    </div>
  </body>
</html>

HTML

my $yaml = <<'YAML';
"items[]":
  - "#main .item a"
  - name: text
  - link: "@href"
"pages[]": "#main  .pages a /@href"
"next_page": "#main .pages .next /@href"
"first_page": "#main .pages a:first-child /&get_first_page"

YAML

my $parser = Crawler::Parser->new($html);
my $rules = YAML::Load($yaml);
$parser->callbacks( { get_first_page => sub { shift->text} });
my $ret = $parser->process($rules);
is($ret->{next_page},"#next");
is($ret->{pages}->[0],"#");
is($ret->{pages}->[-1],"#next");
is($ret->{items}->[0]->{name},"Item 1");
is($ret->{items}->[0]->{link},"Item 1 link");
is($ret->{first_page},"current page");
