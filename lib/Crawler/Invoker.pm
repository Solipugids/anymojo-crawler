package Crawler::Invoker;

use Crawler::Base -strict;
use Crawler::Util;
use Crawler::Task;
use Crawler::DB::Schema;
use File::Spec;
use Parallel::ForkManager;
use Moo;
use ENV;
use YAML qw(Dump);
use Crawler;

with 'Crawler::Logging';

sub MAX_PROCESS() { 4 }
sub TIME_OUT()    { 60 }

has conf => (
    is => 'rw',
    default =>
      sub { File::Spec->catfile( $ENV{PROJECT_PATH}, 'conf', 'crawler.yaml' ) },
    lazy => 1
);
has schema  => ( is => 'rw' );
has site    => ( is => 'rw' );
has crawler => ( is => 'rw' );

sub BUILD {
    my ( $self, @args ) = @_;

    $self->log->debug( "Load configure file => " . $self->conf );
    my $configure = Crawler::Util::load_configure( $self->conf );
    $self->log->debug( "load configure info : " . Dump($configure) );
    $self->conf($configure);
    $self->schema(
        Crawler::DB::Schema->connect(
            $configure->{task_db}{dsn},    $configure->{task_db}{user},
            $configure->{task_db}{passwd}, $configure->{task_db}{option}
        )
    );
    $self->crawler( Crawler->new( conf => $self->conf, site => $self->site ) );
}

sub start {
    my ( $self, %option ) = @_;

    my $site_list = delete $option{site_list};
    my @websites  = split( ',', $site_list );
    my $configure = $self->conf;

    # get site_id list
    if ( not scalar(@websites) ) {
        my $rs = $self->schema->resultset('Website')
          ->search( {}, { -order_by => { -asc => 'id' } } );
        while ( my $row = $rs->next ) {
            push @websites, $row->name;
        }
    }

    my $t = Crawler::Task->new( db_helper => $self->schema );
    my $pm =
      Parallel::ForkManager->new( $configure->{max_process} || MAX_PROCESS );
    my $rs    = $t->find_task_with_sitelist(@websites);
    my $count = 0;

    while ( my $row = $rs->next ) {
        $count++;
        my $pid = $pm->start and next;
        do {
            $row->update( { status => 'doing' } );
            my $website =
              $self->schema->resultset('Website')->by_id( $row->site_id );
            my $site_name    = $website->name;
            my $task_id      = $row->id;
            my $crawler_path = File::Spec->catfile( $ENV{PROJECT_PATH},
                'bin', $site_name, 'crawler.pl' );
            my $cmd =
              "/usr/bin/perl $crawler_path -task_id $task_id -site $site_name";

            $row->invoke_cmd($cmd);
            $row->status('fail') unless $self->execute_task($cmd);
            $row->update;
        };
        $pm->finish($pid);
    }

    $pm->wait_all_children;
    $self->log->info("Excute $count tasks in this turn");
}

sub analyse_rss {
    my ( $self, $feed_url ) = @_;

    if ( not $feed_url ) {
        $feed_url = $self->conf->{ $self->site }->{feed};
    }
    if ( not $self->site ) {
        Carp::croak("When run parser rss,please defined your site");
    }

    my $crawler = $self->crawler;
    my $rss_path =
      File::Spec->catfile( $ENV{PROJECT_PATH}, 'bin', $self->site );
    push @INC, $rss_path;
    require File::Spec->catfile( $rss_path, 'RSS.pm' );

    for ( RSS->meta->get_all_methods ) {
        my $method = $_->name;
        if ( $method =~ m/^rss/ ) {
            $crawler->register_parser( rss => \&{"RSS::$method"} );
        }
        elsif ( $method =~ m/^web/ ) {
            $crawler->register_parser( web => \&{"RSS::$method"} );
        }
    }
    return $crawler->process_rss_download($feed_url);
}

sub execute_task {
    my ( $self, $cmd ) = @_;
    my $ret = 1;

    $self->log->info("Excute task cmd: $cmd");
    my $pid = fork;
    defined $pid or die "fork failed: $!";

    if ($pid) {    # parent
        waitpid( $pid, 0 );
    }
    else {
        eval {
            local $SIG{ALRM} = sub { die "timeout" };
            alarm( $self->conf->{timeout} || TIME_OUT );
            exec($cmd);
        };
        alarm(0);
        if ($@) {
            $ret = 0;
        }
        exit(0);
    }

    return $ret;
}

1;

