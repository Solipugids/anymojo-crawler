package Crawler::DB::Mongo;

use Moo;

extends "MongoDB::MongoClient", "Moo::Object";

# explicit constructor
sub new {
    my $class = shift;

    # call Mojo::UserAgent's constructor
    my $obj = $class->SUPER::new(@_);
    return $class->meta->new_object(

        # pass in the constructed object
        # using the special key __INSTANCE__
        __INSTANCE__ => $obj,
        @_,    # pass in the normal args
    );
}

sub sava_archive{
    my ($self,$data) = @_;
}


1;

__END__

=pod

=head1 NAME

=head1 SYNOPASIS

=head1 METHOD

=cut


# vim: tabstop=4 shiftwidth=4 softtabstop=4

