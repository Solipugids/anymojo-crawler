package Crawler::Parser;

use Moo;
use Tie::Cache;
use Crawler::Parser::RSS;

extends 'Crawler::Event';
with 'Crawler::Logging';

has conf => ( is => 'rw', default => sub { {} }, lazy => 1 );
has rss =>
  ( is => 'ro', default => sub { Crawler::Parser::RSS->new }, lazy => 1 );
has cache => (
    is      => 'rw',
    default => sub {
        my %parser_cache;
        tie %parser_cache, 'Tie::Cache', 100;
    },
    lazy => 1
);

sub parse {
    my ( $self, $event_name, @args ) = @_;
    return $self->event( $event_name, @args );
}

sub get_parser_cached {
    my ( $self, $url ) = @_;

    if ( my $parser = $self->cache->{parser} ) {
        return $parser;
    }
    my $url_pattern = $self->conf->{url_pattern};
    my ($regex) = grep { $url =~ m{$_} } keys %$url_pattern;
    $self->cache->{parser} = $url_pattern->{$regex};
    return $url_pattern->{$regex};
}

sub get_parser_by_urlpattern {
    my ( $self, $url ) = @_;
    my $url_pattern = $self->conf->{url_pattern};
    my ($regex) = grep { $url =~ m{$_} and $_ } keys %$url_pattern;
    if ( not $regex ) {
        if( $self->log->is_debug){
            warn("check your url_pattern for $url or use default entry");
        }
        return
    }
    return $url_pattern->{$regex};
}

1;
