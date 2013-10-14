use Crawler::Base -strict;
use Mojo::UserAgent;
use 5.010;
use Digest::MD5 qw(md5_hex);
use List::Util qw(shuffle);
use Crawler::DB::Schema;
use Mojo::IOLoop;
use Parallel::ForkManager;

my $dsn    = 'DBI:mysql:dbname=crawler;host=127.0.0.1';
my $schema = Crawler::DB::Schema->connect(
    $dsn, 'root', '',
    {
        mysql_enable_utf8 => 1
    }
);
#$schema->storage->debug(1);
my $dbh = $schema->storage->dbh;

my $task_count = $schema->resultset('Album')->search()->count;
my $page_count = int( $task_count / 30) + 1;
my $pm         = Parallel::ForkManager->new(2);

#my $delay      = Mojo::IOLoop->delay;
my $album =
  $schema->resultset('Album')
  ->search( {}, { page => $page_count, rows => 30}, );

my $ua    = Mojo::UserAgent->new;
my $_ua   = Mojo::UserAgent->new;
$ua->max_connections(10);
my $xiage = $schema->resultset('Xiage');
print "total pagecount => $page_count\n";
for my $page_index ( 1 .. $page_count ) {
    $pm->start and next;
    say "start $page_index page ....";
    my $page  = $album->page($page_index);
    my $delay = Mojo::IOLoop->delay;
    for my $row ( shuffle $page->all ) {
        my $url          = $row->url;
        my $category     = 'other';
        my $listen_count = 0;
        my ($id)         = $url =~ m/(\d+)/;
        my $genre        = 'no';
        my $rating       = 0;
        my $album_type = 'no';
        $url = "http://www.xiami.com/album/$id";

        #my $delay      = Mojo::IOLoop->delay;
        $delay->begin;
        $ua->get(
            $url => sub {
                my ( $ua, $tx ) = @_;
                if ( $tx->success ) {
                    eval {
                        my $dom = $tx->res->dom->charset('UTF-8');
                        if ( my $info = $dom->at('#album_info') ) {

                            if( $info->all_text =~ m/专辑风格：(.*)/six ){
                                $genre = $1;
                                $genre =~ s/^\s+//g;
                                $genre =~ s/\s+$//g;
                            }
                            if ($info->all_text =~ m/专辑类别：(.*)/six ){
                                $album_type = $1;
                            }
                            

                            if ( $info->all_text =~
                                m/\x{8BED}\x{79CD}\x{FF1A}\s*(.+?)\s+/six )
                            {
                                if ( $1 eq '国语' || $1 eq '粤语' ) {
                                    $category = '华语艺人';
                                }
                                if ( $1 eq '韩语' ) {
                                    $category = '韩国艺人';
                                }
                                if ( $1 eq '日语' ) {
                                    $category = '日本艺人';
                                }
                                if ( $1 eq '英语' ) {
                                    $category = '欧美艺人';
                                }
                                if ( $1 eq '俄语' ) {
                                    $category = '俄罗斯艺人';
                                }
                            }
                        }
                        if ( my $rank = $dom->at('#album_rank') ) {
                            $rating = $rank->at('em')->text;
                        }
                        if ( my $track = $dom->at('#track') ) {
                            for my $e ( $track->find('tr')->each ) {
                                my ($song_id) =
                                  $e->find('td.song_name > a')->[-1]->{href}
                                  =~ m/(\d+)/six;
                                my $song_hot = $e->at('td.song_hot')->text;
                                my $hashref  = {
                                    url_md5 => md5_hex(
                                        'http://www.xiami.com/song/' . $song_id
                                    ),
                                };
                                if( my $rs = $xiage->find({ url_md5 => $hashref->{url_md5} }) ){
                                    $rs->style( $genre ) if $genre;
                                    $rs->type( $category) if $category;
                                    $rs->rating( $rating) if defined $rating;
                                    $rs->hot_num( $song_hot) if $song_hot;
                                    $rs->album_type($album_type) if $album_type;
                                    $rs->update;
                                }else{
                                    $row->status('redo');
                                }
                            }
                        }
                    };
                    if( $@) { 
                        $row->status('fail');
                    }else{
                        $row->status('patch');
                    }
                    $row->update;
                }
            },
        );
        $delay->wait unless Mojo::IOLoop->is_running;
    }

    $pm->finish;
}
$pm->wait_all_children;

sub parse_album {
}

sub parse_song {
}

