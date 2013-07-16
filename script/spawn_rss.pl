use Crawler::Base -strict;
use Crawler::Util;
use Getopt::Long;
use File::Spec;
use Mojo::Log;
use Carp;
use Digest::MD5 qw(md5_hex);
use YAML qw(LoadFile DumpFile Dump);
use File::Path qw(make_path);
use FileHandle;
use Mojo::Template;

my $usage = <<EOF;
$0 -debug 1 -feed http://xxx.com.feed -site xxxx.com -base_url xxx.com -type xx
example:
    $0 -feed http://smzdm.com/feed -site smzdm -base_url xx.com
EOF

my ( $feed, $site, $base_url, $desc, $region,$project_path,$debug );
my $type;

GetOptions(
    'feed=s'   => \$feed,
    'site=s'   => \$site,
    'base=s'   => \$base_url,
    'desc=s'   => \$desc,
    'region=s' => \$region,
    'type=s' => \$type,  
) or die $usage;

unless ($feed) {
    die $usage;
}

if ( not $project_path ) {
    $project_path = $ENV{PROJECT_PATH};
}

# load yaml config
my $config =
  File::Spec->catfile( split( '/', $project_path ), 'conf', 'crawler.yaml' );
my $log = Mojo::Log->new;
$log->debug("config file is $config");
my $conf_hashref = Crawler::Util::load_configure($config);
$log->debug( "conf hashref " . Dump($conf_hashref) );
my $mt       = Mojo::Template->new;
my $template = do { local $/; <DATA> };
my $schema   = Crawler::Util::get_db_schema( $conf_hashref->{task_db} );
do { $log->level('debug'); $schema->storage->debug(1); } if $debug;

# gen code template
if ( $site =~ m{^http} ) {
    Carp::croak("site name can't start with http");
}

$log->debug("Begin generate a new rss script");
my $data = {
    name   => $site,
    type   => $type || '',
    region => $region || 'china',
    url    => $base_url,
};
my $website =
  $schema->resultset('Website')->update_or_create( $data, { name => $site }, );
$log->debug( "Add data to website table:" . Dump($data) );
my $code = $mt->render( $template, $site, $base_url );
$log->debug( "Generate crawler parse code:" . $code );
my $crawler_path = File::Spec->catfile( $project_path, 'bin', $site );
my $rss = File::Spec->catfile( $crawler_path, 'rss.pl' );
make_path($crawler_path);
my $fh = FileHandle->new(">$rss") or die $@;
$fh->print($code);
$fh->close;

my $parser_option = {
    parser => {
        base_url         => $base_url,
        category_mapping => {},
    },
};
$conf_hashref->{$site} = $parser_option;
$log->debug( "Add parser option to crawler.yaml:" . Dump($parser_option) );
DumpFile( $config, $conf_hashref );

__DATA__
% my ($site,$base_url) = @_;
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


my $usage = <<EOF;
$0 -feed xxx.feed
*******************************************************************************
Example:
    $0  -feed xxx.com/feed
EOF

my $config = File::Spec->catfile( split( '/', $ENV{PROJECT_PATH} ),
    'conf', 'crawler.yaml' );
my $site = 'mgpyh';
my $base_url = '<%= $base_url %>';
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
            $data->{md5} = md5_hex($item->content);

            say "parsed data:".Dump($data);

            push @{ $parsed_result->{WpPost} },$data;
        }
    }
);


$c->start_feed($feed);

