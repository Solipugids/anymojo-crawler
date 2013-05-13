package Crawler::DB::Schema::ResultSet::TaskDetail;

use base qw(Crawler::DB::Schema::ResultSet);

sub by_id {
    return shift->find( { id => pop } );
}

sub by_url {
    return shift->find( { url => pop } );
}

sub by_md5 {
    return shift->find( { url_md5 => pop } );
}

1;

__END__


