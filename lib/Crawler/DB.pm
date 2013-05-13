package Crawler::DB;

use Moo;
use Crawler::DB::Mongo;

sub connect_db{
    my ($self,$data_source,$dsn,$user,$passwd) = @_;
    if( $data_source eq 'mongo'){
        return Crawler::DB::Mongo->new( $dsn );
    }
}


1;
