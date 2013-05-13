package Crawler::DB::Schema::ResultSet::Website;

use base 'DBIx::Class::ResultSet';

sub by_id {
    return shift->find( { id => pop } );
}

sub by_name {
    return shift->find( { name => pop } );
}

sub by_type {
    return shift->find( { type => pop } );
}

1;

__END__

