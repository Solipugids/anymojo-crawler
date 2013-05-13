package Crawler::DB::Schema::ResultSet::Category;

use base 'DBIx::Class::ResultSet';

sub by_id{
    return shift->find({ id => pop});
}
sub by_name{
    return shift->find({ name => pop});
}

1;

__END__





