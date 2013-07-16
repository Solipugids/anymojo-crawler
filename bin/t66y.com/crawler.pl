use Crawler::Base -strict;
use Getopt::Long;
use File::Spec;
use Crawler;
use YAML qw(Dump);
use Digest::MD5 qw(md5_hex);

my $usage = <<EOF;
$0 -task_id xx -conf xxx.yaml -debug 1 -site xxx
*******************************************************************************
Example:
    $0 -task_id 1 -conf ./crawler.yaml  -site mgpyh -debug 1
EOF

my $task_id;
my $config = File::Spec->catfile( split( '/', $ENV{PROJECT_PATH} ),
    'conf', 'crawler.yaml' );
my $site     = 't66y.com';
my $base_url = 'http://t66y.com';

GetOptions(
    'task_id=s' => \$task_id,    # numeric task_id
    'site=s'    => \$site,
    'conf=s'    => \$config,
) or die("Get command args Error!!!");

unless ($task_id) {
    die $usage;
}

my $c = Crawler->new(
    conf => $config,
    site => $site,
);

$c->register_parser(
    home => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;

        for my $e ( $dom->at('#cate_1')->find("h2")->each ) {
            my $category_url = $base_url . "/" . $e->find('a')->first->{'href'};
            push @{ $parsed_result->{feeder} },
              {
                url_md5    => md5_hex($category_url),
                website_id => $attr->{website_id},
                url        => $category_url,
                status     => 'undo',
              };
        }
        $parser->log->debug(
            "parsed home result:" . Dump( $parsed_result->{feeder} ) );
        return 0 if @{ $parsed_result->{feeder} } == 0;
        return 1;
    },
    feeder => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;

# <a href="http://www.mgpyh.com/category/amazon-deals/page/2" class="page" title="2">2</a>
        my $page_prefix = $attr->{url}."&"."search=&page=";
        # Pages: ( 1/175 total )
        my ($total) = $attr->{html}=~ m{Pages:.*?1/(\d+)\s*total}six;
        $parser->log->debug("get feeder pages total is : $total");
        for my $page_num ( 1 .. $total ) {
            my $page_info = {
                url         => $page_prefix . $page_num,
                url_md5     => md5_hex( $page_prefix . $page_num ),
                category_id => 1,
                website_id  => $attr->{website_id},
                status => 'undo',
            };
            push @{ $parsed_result->{page} }, $page_info;
        }
        $parser->log->debug("parse feeder page return :".Dump($parsed_result));
        return 0 if @{ $parsed_result->{page} } == 0;
        return 1;
    },
    page => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        my @list = [];
        my $hashref = {};

        for my $e( $dom->find('h3')->each){
            if( my $node = $e->find('a')->first ){
                $hashref->{caoliu_link} = $base_url.'/'.$node->{href},
                $hashref->{ac_title} = $base_url.'/'.$node->text;
                push @list,$hashref;
            }
        }
        say Dump(\@list);

        return 1;
    },
    archive => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;

        if ( not exists $parsed_result->{wp_post} ) {
            $parsed_result->{wp_post} = [];
        }

        my $data = {};
        $data->{url}          = $attr->{url};
        $data->{url_md5}      = md5_hex( $attr->{url} );
        $data->{source}       = $attr->{website_url};
        $data->{post_content} = $dom->find('div.post_content')->first->text;
        $data->{category}     = $dom->find('span.cates > a')->first->text;
        $data->{post_date}    = $dom->find('span.date')->first->text;

        return 1;
    }
);

$c->run($task_id);
