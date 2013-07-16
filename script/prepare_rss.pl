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
use utf8;

my $usage = <<EOF;
example:
    $0 -site  xxx -feed http://xxx.com/feed -desc xxx -t target_table
EOF

my ( $type, $site_list, $debug, $project_path, $region, $desc,$feed ,$target);
my $index;
$target = join ("",map { ucfirst $_ } split("_",$target) );

GetOptions(
    "site|s=s" => \$site_list,
    "target|t=s" => \$target,
    "debug=i"     => \$debug,
    "p=s"         => \$project_path,
    "region=s"    => \$region,
    "type=s"      => \$type,
    "index|i=s"     => \$index,
    "feed|f=s" => \$feed,
    "desc=s" => \$desc,
) or die $usage;

unless ($site_list) {
    die $usage;
}
die $usage if not $feed;

if ( not $project_path ) {
    $project_path = $ENV{PROJECT_PATH};
}
$region = "china" if not $region;
$desc   = ''      if not $desc;

# load yaml config
my $config =
  File::Spec->catfile( split( '/', $project_path ), 'conf', 'crawler.yaml' );
my $conf_hashref = Crawler::Util::load_configure($config);
my $mt       = Mojo::Template->new;
my $template = File::Spec->catfile($ENV{PROJECT_PATH},'conf','rss.template');
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
        url    => 'http://' . $site.".com",
    };
    my $website = $schema->resultset('Website')
      ->update_or_create( $data, { name => $site }, );
    $log->debug( "Add data to website table:" . Dump($data) );
    my $code = $mt->render_file( $template );
    $log->debug( "Generate crawler parse code:" . $code );

    my $crawler_path = File::Spec->catfile( $project_path, 'bin', $site );
    my $rss= File::Spec->catfile( $crawler_path, 'RSS.pm' );
    make_path($crawler_path);
    my $fh = FileHandle->new(">$rss") or die $@;
    $fh->print($code);
    $fh->close;

    my $parser_option = {
        parser => {
            base_url         => $index,
            category_mapping => {},
            url_pattern      => {
                xxx => 'feeder',
                yyy => 'archive',
                zzz => 'home',
                ttt => 'page',
            },
        },
    };
    $conf_hashref->{$site} = $parser_option;
    $conf_hashref->{$site}{feed} = $feed;
    $conf_hashref->{$site}{desc} = $desc;
    $conf_hashref->{$site}{target} = $target;
    $log->debug( "Add parser option to crawler.yaml:" . Dump($conf_hashref->{$site}) );
    system("cp $config ${config}.bak".time());
    DumpFile( $config, $conf_hashref );
}

