package Crawler::DB::Schema::ResultSet::Archive;

use base 'DBIx::Class::ResultSet';

sub by_url {
    return shift->find( { url => pop } );
}

sub by_md5 {
    return shift->find( { url_md5 => pop } );
}

sub by_category_id {
    return shift->find( { category_id => pop } );
}

sub by_website_id {
    return shift->find( { website_id => pop } );
}

sub by_status{
    return shift->find( { status => pop } );
}

1;

__END__





