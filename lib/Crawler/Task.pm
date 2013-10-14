package Crawler::Task;

use Crawler::Base -strict;
use Crawler::Util;
use Moo;
use Try::Tiny;
use DateTime;
use Digest::MD5 qw(md5_hex);
use EV;
use AnyEvent;

with 'Crawler::Logging';

has db_helper => ( is => 'ro', required => 1 );
has limit => ( is => 'rw', default => 20, lazy => 1 );
has poll_condvar =>
  ( is => 'rw', default => sub { AnyEvent->condvar }, lazy => 1 );
has 'debug' => ( is => 'rw', default => 0 );

sub gen_task_with_entry {
    my ( $self, $entry, $website_id,$status ) = @_;

    my $cond = {};
    if ($website_id) {
        $cond->{website_id} = $website_id;
        #$cond->{url_md5} = '5c447198ceb8781108100e8c260c37ce';
    }
    $cond->{status} = 'undo';
    my $attr = {};

    #$attr->{rows} = $self->limit;
    my $rs =
      $self->db_helper->resultset(
        join( '', map { ucfirst $_ } split( '_', $entry ) ) )
      ->search( $cond, $attr );

    my $count = 0;
    my $task_id;

    # gen task in task and task_detail table
    while ( my $row = $rs->next ) {
        if ( $count == 0 )
        {    #$count < $self->limit || not $count % $self->limit){
            $self->log->debug(
                "Every " . $self->limit . " row,batch a task queue" );
            my $t = $self->db_helper->resultset('Task')->create(
                {
                    start_time  => Crawler::Util::now(),
                    type        => $entry,
                    retry_times => 0,
                    status      => 'undo',
                    site_id     => $website_id,
                }
            );
            $task_id = $t->id;
        }
        $count++;
        my $detail = $self->db_helper->resultset('TaskDetail')->find_or_create(
            {
                id      => $task_id,
                url     => $row->url,
                url_md5 => $row->url_md5,
            }
        );
        exit if $self->debug;
        $self->log->debug("Insert a new detail row ,id => $task_id");
    }
    exit;
}

sub gen_task_with_feeder {
    my ( $self, $type, $website_id, $feeder_url ) = @_;

    my $dt         = DateTime->now;
    my $start_time = sprintf( "%0.4d-%0.2d-%0.2d %0.2d:%0.2d:%0.2d",
        $dt->year, $dt->month, $dt->day, $dt->hour, $dt->min, $dt->sec );
    my $status = 'undo';
    my $website_url =
      $self->db_helper->resultset('Website')->by_id($website_id)->url;

    my $ret = 1;
    try {
        my $rs = $self->db_helper->resultset('Task')->create(
            {
                status     => $status,
                start_time => $start_time,
                type       => $type,
                site_id    => $website_id,
            }
        );
        $self->log->debug( "get last insert_id " . $rs->id );
        $self->db_helper->resultset('TaskDetail')->create(
            {
                id      => $rs->id,
                url     => $feeder_url,
                url_md5 => md5_hex($feeder_url),
            }
        );
        $self->log->debug(
"insert new record to task table with data: start_time = $start_time,
        status = $status, url = $feeder_url, website_id = $website_id,type = $type"
        );
    }
    catch {
        my $err = $_;
        $self->log->error("db error: $err");
        $ret = 0;
    };

    return $ret;
}

sub get_task_by_status {
    my ( $self, $website_id, $status, $limit ) = @_;

    # limit query
    my $addition = {};
    $addition->{order_by} = { -desc => 'start_time' };
    if ($limit) {
        $addition->{rows} = $limit;
    }
    my $cond = { site_id => $website_id, status => $status };

    if (wantarray) {
        my $rs = $self->db_helper->resultset('Task')
          ->search( { site_id => $website_id, status => $status }, $addition );
        my @result = ();
        while ( my $row = $rs->next ) {
            push @result, $row;
        }
        return @result;
    }
    else {
        $addition->{rows} = 1;
        return $self->db_helper->resultset('Task')->search( $cond, $addition )
          ->single;

    }
}

sub update_task_status {
    my ( $self, $task_id, $status ) = @_;
    return $self->db_helper->resultset('Task')->search( { id => $task_id } )
      ->update( { status => $status } );
}

sub polling_task_by_site {
    my ( $self, $interval, $type, $website_id ) = @_;

    $self->log->debug( "Begin generate new task for crawler,"
          . "website_id: $website_id,interval: $interval,"
          . "type: $type" );
    foreach my $entry ($type) {
        $self->gen_task_with_entry( $entry, $website_id );
    }

=pod
    my $w = AnyEvent->timer(
        after    => 2,
        interval => $interval,
        cb       => sub {
            #foreach my $entry (qw(home feeder page archive)) {
            #foreach my $entry (qw(home artist page dbox download song)) {
            foreach my $entry ($type ){
                $self->gen_task_with_entry( $entry, $website_id );
            }
        },
    );
    return $w;
=cut

}

sub find_task_with_sitelist {
    my ( $self, @site_list ) = @_;

    my $sub_rs =
      $self->db_helper->resultset('Website')->search( { name => \@site_list } );

    my $rs = $self->db_helper->resultset('Task')->search(
        {
            status  => [ 'undo', 'fail' ],
            site_id => {
                '-in' => $sub_rs->get_column('id')->as_query
            },
        }
    );
    return $rs;
}

1;
