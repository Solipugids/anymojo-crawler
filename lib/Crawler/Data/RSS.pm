package Crawler::Data::RSS;

use Moo;
use Crawler::UserAgent;

has 'title' => ( is => 'rw');
has 'link' => ( is => 'rw');
has 'desc' => ( is => 'rw');
has 'content' => ( is => 'rw');
has 'comments' => ( is => 'rw');
has 'pubdate' => ( is => 'rw');
has 'category' => ( is => 'rw');
has 'ua' => ( is =>'rw',default => sub { Crawler::UserAgent->new } );

sub save_rss_data{
    my ($self,$feed_url) = @_;
    my $parsed_result = [];

    eval{
    };
    if($@){
        warn $@;
    }
}

1;
