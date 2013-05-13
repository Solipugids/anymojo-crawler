package Crawler::DB::Schema::ResultSet::Task;

use base 'DBIx::Class::ResultSet';

sub by_id {
    return shift->find( { id => pop } );
}

sub by_status {
    return shift->find( { status => pop } );
}

sub by_url {
    return shift->find( { url => pop } );
}

sub by_md5 {
    return shift->find( { url_md5 => pop } );
}

sub by_start_time {
    return shift->find( { start_time => pop } );
}

sub gen_task_by_type {
    my ( $self, $webstie_id, $type ) = @_;
    return $self->find_or_create(
        {
            status  => 'undo',
            site_id => $webstie_id,
            type    => $type,
        }
    );
}

sub latest {
    return
      shift->search( {}, { order_by => { -desc => 'start_time' }, rows => 1 } )
      ->single;
}

1;

__END__



