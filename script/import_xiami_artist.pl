use Digest::MD5 qw(md5_hex);
use DBI;
use 5.010;
use Parallel::ForkManager;

my $time1 = time;

my $thread_max = 1;
my $batch      = 200;
my $table      = 'album_index';
my $database   = 'crawler';
my $hostname   = 'localhost';
my $port       = 3306;
my $dsn        = "DBI:mysql:dbname=crawler;host=127.0.0.1";
my $user       = 'root';
my $passwd     = '';

my $cb = sub {
    my $dbh = shift;
    my $id         = shift;
    my $status     = 'undo';
    my $website_id = 10;
    my $category   = 'all';

    # http://www.xiami.com/artist/album/id/4?
    my $url     = "http://www.xiami.com/artist/album/id/${id}";
    my $url_md5 = md5_hex($url);

    my ($ok) = $dbh->selectrow_array( "select 1 from $table where url_md5 = ?",
        undef, $url_md5 );
    if( $ok ){
        say "this id : $url_md5 is exists in $table ,next";
        return;
    }

    my $rc = $dbh->do(
"insert into $table ( url_md5,url,website_id,category,status ) values ( ?,?,?,?,?)",
        undef, $url_md5, $url, $website_id, $category, $status
    );
    say "insert into $table( $url_md5, $url, $website_id, $category, $status )";
    if ( not $rc ) {
        system(" echo '$id' >> /tmp/insert.id");
    }
};

my $pm = Parallel::ForkManager->new($thread_max);
my $end = 130000;
my $start = 60000;

my $dbh = DBI->connect( $dsn, $user, $passwd );
for ( $start .. $end) {
    #  my $pid = $pm->start and next;
    $cb->($dbh,$_);
#    $pm->finish;
}
#$pm->wait_all_children;

my $time2 = time;

say "make replace "
  .  ($end-$start+1)
  . " rows,cost "
  . ($time2 - $time1)
  . " secs!!";
