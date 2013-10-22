use Mojo::UserAgent;
use Crawler::Base -strict;
use Mojo::UserAgent::CookieJar;
use Storable;
use YAML 'Dump';

my $start = shift;
my $domain = 'mailinator.com';
my $project_path = $ENV{PROJECT_PATH};
my @xm_vips = qw(
yy001
yy002
yy003
yy004
yy005
yy006
yy007
yy008
yy009
yy010
yy011
yy012
yy013
yy014
yy015
yy016
yy017
yy018
yy019
yy020
yy021
yy022
yy023
yy024
yy025
yy026
yy027
yy028
yy029
yy030
yy031
yy032
yy033
yy034
yy035
yy036
yy037
yy038
yy039
yy040
yy041
yy042
yy043
yy044
yy045
yy046
yy047
yy048
yy049
yy050
);

for(1..50 ){
    my $acc = sprintf ("yy%0.03d",$_);
    print $acc,"\n";
}

for( @xm_vips ){
    my $username = $_."@".$domain;
    &login_xiami($username);
    $start++;
}

sub login_xiami {
    my ($username,$password) = @_;
    $password ||= '123456';
    #my ($cookie)  = $username =~ m/(.+?)\@/six;
    my $cookie = sprintf "xm%0.03d",$start;
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
        my $dumper = Dump $ua->cookie_jar;
        #print $dumper;
        if( not $dumper =~ m/member_auth/s ){
            print("$username => errorrrrrrrrr!!!!");
        }else{
            store $ua->cookie_jar, $cookie_path if not -e $cookie_path;
        }
    }
    else {
        print(
            "login Xiami => $username failed,check you login args and network\n");
    }
    
    return 1;
}





