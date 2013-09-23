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
$0 -debug 1 -site_list  sitename  -type type -region region name -index xxx
example:
    $0 -site_list smzdm,t66y -type 购物 -region china -index http://mgpyh.com
EOF

my ( $type, $site_list, $debug, $project_path, $region, $desc );
my $index;

GetOptions(
    "site_list=s" => \$site_list,
    "debug=i"     => \$debug,
    "p=s"         => \$project_path,
    "region=s"    => \$region,
    "type=s"      => \$type,
    "index=s"     => \$index,
) or die $usage;

unless ($site_list) {
    die $usage;
}

if ( not $project_path ) {
    $project_path = $ENV{PROJECT_PATH};
}
$region = "china" if not $region;
$desc   = ''      if not $desc;

# load yaml config
my $config =
  File::Spec->catfile( split( '/', $project_path ), 'conf', 'crawler.yaml' );
say "config file is $config";
my $conf_hashref = Crawler::Util::load_configure($config);
say "conf hashref " . Dump($conf_hashref);
my $mt       = Mojo::Template->new;
my $template = do { local $/; <DATA> };
my $schema   = Crawler::Util::get_db_schema( $conf_hashref->{task_db} );

# set log
my $log = Mojo::Log->new;
do { $log->level('debug'); $schema->storage->debug(1); } if $debug;

# gen code template
for my $site ( split( ',', $site_list ) ) {
    if( $site=~ m{^http} ){
        Carp::croak("site name can't start with http");
    }

    $log->debug("Begin generate a new crawler code");
    my $data = {
        name   => $site,
        type   => $type || '',
        region => $region,
        url    => 'http://' . $site,
    };
    my $website = $schema->resultset('Website')
      ->update_or_create( $data, { name => $site }, );
    $log->debug( "Add data to website table:" . Dump($data) );
    my $code = $mt->render( $template, $site, 'http://' . $site );
    $log->debug( "Generate crawler parse code:" . $code );

    my $crawler_path = File::Spec->catfile( $project_path, 'bin', $site );
    my $crawler = File::Spec->catfile( $crawler_path, 'crawler.pl' );
    make_path($crawler_path);
    my $fh = FileHandle->new(">$crawler") or die $@;
    $fh->print($code);
    $fh->close;

    my $parser_option = {
        parser => {
            base_url         => 'http://' . $site,
            category_mapping => {},
            url_pattern      => {
                xxx => 'feeder',
                yyy => 'archive',
                zzz => 'home',
                ttt => 'page',
            },
        },
    };
    $conf_hashref->{$site} = $parser_option if not exists $conf_hashref->{$site};
    $log->debug( "Add parser option to crawler.yaml:" . Dump($parser_option) );
    DumpFile( $config, $conf_hashref );
    $schema->resultset('Home')->find_or_create(
        {
            url        => $index,
            url_md5    => md5_hex($index),
            status     => 'undo',
            website_id => $website->id,
        }
    );
}

__DATA__
% my ($site,$base_url) = @_;
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
my $site = '<%= $site %>';
my $base_url = '<%= $base_url %>';

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

        return 0 if @{ $parsed_result->{feeder} } == 0;
        return 1;
    },
    feeder => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;

        return 0 if @{ $parsed_result->{page} } == 0;
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
