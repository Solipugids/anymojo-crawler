use Crawler::Base -strict;
use Mojo::Log;
use Crawler::Util;
use Crawler::UserAgent;
use Data::Dumper;
use YAML qw(Dump DumpFile);
use utf8;

my $index = shift;

if(not $index){
    die "please input your site index to find category";
}
my $log = Mojo::Log->new;

my $file= File::Spec->catfile( split( '/', $ENV{PROJECT_PATH} ),
    'conf', 'crawler.yaml' );

my $config = Crawler::Util::load_configure($file);

my $ua = Crawler::UserAgent->new;
my @categorys;  
for($ua->get( $index )->res->dom->at('#widget_categories')->find('a')->each ){
    push @categorys,$_->text;
}
print Dumper(@categorys);
my %hash = map { $_ => '未分类' } @categorys;
print Dumper(\%hash);
$config->{mgpyh}->{category_mapping} = \%hash;
DumpFile($file,$config);
