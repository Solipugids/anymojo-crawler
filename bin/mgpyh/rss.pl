use Crawler::Base -strict;
use Getopt::Long;
use File::Spec;
use Crawler;
use YAML qw(Dump);
use Digest::MD5 qw(md5_hex);
use Mojo::DOM;
use Crawler::Util;
use Crawler::Parser::RSS;
use Encode qw(decode_utf8 encode_utf8);

use utf8;
binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

my $usage = <<EOF;
$0 -task_id xx -conf xxx.yaml -debug 1 -site xxx
*******************************************************************************
Example:
    $0  -conf ./crawler.yaml  -site mgpyh -debug 1
EOF

my $task_id;
my $config = File::Spec->catfile( split( '/', $ENV{PROJECT_PATH} ),
    'conf', 'crawler.yaml' );
my $site = 'mgpyh';
my $base_url = 'http://mgpyh.com';
my $debug;
my $feed;

GetOptions(
    'debug=s' => \$debug,
    'feed=s'    => \$feed,
) or die("Get command args Error!!!");

die $usage unless($feed);
my $c = Crawler->new(
    conf => $config,
    site => $site,
);

$c->schema->storage->debug(1) if $debug;
=pod
  `url_md5` varchar(32) NOT NULL DEFAULT '',
  `url` varchar(255) NOT NULL DEFAULT '',
  `source` varchar(255) NOT NULL DEFAULT '',
  `category` varchar(20) NOT NULL DEFAULT '',
  `price` varchar(20) DEFAULT NULL,
  `preview_img` text NOT NULL,
  `img` text,
  `comment_times` int(20) DEFAULT NULL,
  `rating_times` int(20) DEFAULT NULL,
  `like` int(20) DEFAULT NULL,
  `dislike` int(20) DEFAULT NULL,
  `collect` int(11) DEFAULT NULL,
  `buylink` varchar(255) DEFAULT '',
  `post_date` datetime DEFAULT NULL,
  `status` varchar(11) DEFAULT NULL,
  `share_count` int(20) DEFAULT NULL,
  `post_content` text,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`url_md5`)
=cut

$c->register_parser(
    feed => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        if ( not exists $parsed_result->{WpPost} ) {
            $parsed_result->{WpPost} = [];
        }
        my $html = $attr->{html};
        for my $item ( $parser->rss->parse( $html )->each ) {
            my $data = {};
            $data->{url}     = $item->link;
            $data->{title}  = decode_utf8($item->title);
            $data->{source} = $base_url;

            if ( exists $parser->conf->{category_mapping}{ $item->category } ) {
                $data->{category} = $item->category;
            }
            if ( $data->{title} =~ m{((?:￥|\$)\s*\d+)}six ) {
                $data->{price} = $1;
            }else{
                $data->{price} = '未知';
            }
            if ( $item->content =~ m{img.*?src=\"(http:.+?sinaimg.+?)"}six ) {
                $data->{img} = $1;
            }
            $data->{post_date} =
              Crawler::Util::format_rss_time( $item->{pubdate} );

            # <a href="http://www.mgpyh.com/25545-2/82360" target="_blank">
            my $category;
            do{
                my $ua  = $attr->{ua};
                my $url = $item->link;
                my $dom = $ua->get($url)->res->dom;
                $data->{buylink} = $dom->at('div.buy > a')->{href};
                $data->{preview_img} =
                  $dom->at('div.list_thumb > div.thumb > img')->{src};
                if( not $data->{img} ){
                    $data->{img} = $data->{preview_img};
                }
                $data->{sj} = $dom->at('div.mall > a')->text;
                $data->{mall_link} = $dom->at('div.mall > a')->{href};
                ($data->{comment_times}) = $dom->at('span.cnumber')->text=~ m/(\d+)/six;
                $category = $dom->at('div.breadcrumbs')->find('a')->[1]->text;
            };
            if( exists $parser->conf->{category_mapping}{$category} ){
                $data->{category} = $category;
            }
            $data->{post_content} = decode_utf8($item->content);
            $data->{md5} = md5_hex($item->buylink);

            say "parsed data:".Dump($data);

            push @{ $parsed_result->{WpPost} },$data;
        }
    }
);


$c->single_run($feed,'feed');
