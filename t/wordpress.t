use Crawler::Base -strict;

use Test::More qw(no_plan);
use YAML qw(Dump);

BEGIN {
    use_ok('Crawler::Publisher::WordPress');
}

my $wp = Crawler::Publisher::WordPress->new(
    {
        username => 'admin',
        password => 'Jin19841002',
        proxy    => 'http://htzdy.com/xmlrpc.php'
    }
);

my $new_post = {};
$new_post->{description} = <<EOF;
description post testing
EOF

$new_post->{title} =
'lg 22 title';
$new_post->{custom_fields} = [
    {
        'value' => '2000',
        'key'   => 'price'
    },
    {
        'value' => 'http://www.mgpyh.com/25545-2/84596',
        'key'   => 'saleurl'
    },
    {
        'value' => 'somesj',
        'key'   => 'sj'
    },
];
$new_post->{mt_excerpt} =<<EOT;
a met excerpt xxxxx
EOT
my $t = $wp->new_post($new_post,1);
is( $t,1,'test post archive');

