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
my $site     = 'music.baidu';
my $base_url = 'http://music.baidu';

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

        eval {
            if ( not @$parsed_result->{feeder} ) {
                $parsed_result->{feeder} = [];
            }
            my $base_url = $attr->{base_url};
            for my $e( $dom->find('ul.container > a')->each ){
                my $feeder_url = $base_url.$e->{href};
                push @{ $parsed_result->{feeder} },{
                    url => $feeder_url,
                    url_md5 => md5_hex($feeder_url),
                    website_id => $attr->{website_id},
                    status => 'undo',
                };
            }
        };
        return 0 if $@;
        return 1;
    },
    feeder => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;

        eval {
            my $base_url = $attr->{base_url};
            my $last_node = $dom->find('page-inner > a ')->[-2];
            my $sample_url = $last_node->{href};

        };
        return 0 if $@;
        return 1;

    },
    page => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;

        return 0 if @{ $parsed_result->{archive} } == 0;
        return 1;
    },
    archive => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;

        return 1;
    }
);

$c->run($task_id);
