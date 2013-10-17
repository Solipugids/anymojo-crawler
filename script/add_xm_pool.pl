use Mojo::UserAgent;
use Crawler::Base -strict;
use Mojo::UserAgent::CookieJar;
use Storable;
use YAML 'Dump';

my $domain = 'mailinator.com';
my $project_path = $ENV{PROJECT_PATH};
my @xm_vips = qw(
xm001
xm002
xm003
xm004
xm005
xm006
xm007
xm008
xm009
xm010
xm011
xm012
xm013
xm014
xm015
xm016
xm017
xm018
xm019
xm020
xm021
xm022
xm023
xm024
xm025
xm026
xm027
xm028
xm029
xm030
xm031
xm032
xm033
xm034
xm035
xm036
xm037
xm038
xm039
xm040
xm041
xm042
xm043
xm044
xm045
xm046
xm047
xm048
xm049
xm050
);

for( 1..50){
    my $acc = sprintf ("xm%0.03d",$_);
    print $acc,"\n";
}

for( @xm_vips ){
    my $username = $_."@".$domain;
    &login_xiami($username);
}

sub login_xiami {
    my ($username,$password) = @_;
    $password ||= '123456';
    my ($cookie)  = $username =~ m/(.+?)\@/six;
    my $cookie_path =
      File::Spec->catfile( $ENV{PROJECT_PATH}, 'bin', 'xiami.com', $cookie );

    my $ua = Mojo::UserAgent->new;
    $ua->max_redirects(3);
    $ua->cookie_jar( Mojo::UserAgent::CookieJar->new );
    my $headers =
      { 'User-Agent' =>
'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.76 Safari/537.36',
      };
    my $form = {
        done     => 'http://www.xiami.com',
        email    => $username,
        password => $password,
        submit   => '登录'
    };
    #default => 'http://www.xiami.com/member/login',
    my $tx = $ua->post( 'http://www.xiami.com/member/login' => $headers => form => $form );
    if ( $tx->res->code == 200 ) {
        store $ua->cookie_jar, $cookie_path if not -e $cookie_path;
        print Dump $ua->cookie_jar;
        print( "login xiami.com success,save cookie => $cookie_path\n");
    }
    else {
        print(
            "login Xiami failed,check you login args and network\n");
    }
    
    return 1;
}





