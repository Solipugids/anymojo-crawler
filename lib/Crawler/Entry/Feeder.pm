package Crawler::Entry::Feeder;

use ENV;
use Crawler::Base -strict;
use Crawler::UserAgent;
use Mojo::UserAgent::CookieJar;
use Moo;
use AnyEvent;

extends 'Crawler::Event'; 
with 'Crawler::Logging';

has ua => ( is => 'rw', default => sub { Crawler::UserAgent->new } );

#to do validate url
has url => ( is => 'ro', isa => sub { my ($url) = @_; } );
has feeders => ( is => 'rw', default => sub { [] }, lazy => 1 );
has cookie_jar => ( is => 'rw', default => 0, lazy => 1 );

sub reg_parser {
    my ( $self, $cb ) = @_;

    if ( ref($cb) ne 'CODE' ) {
        my $err = "you passed callback must be a coderef";
        $self->log->error($err);
    }
    $self->reg_cb(
        start => sub {
            my $url = $self->url;
            my $c = AnyEvent->condvar;
            $self->ua->get(
                $url => sub {
                    my ( $ua, $tx ) = @_;
                    print "hello world\n";
                    if ( $tx->success ) {
                        $cb->($tx->res->dom );
                    }
                    else {
                        $self->log->error("http download $url failed");
                    }
                    $c->send;
                }
            );
            $c->recv;
        }
    );
}

sub BUILD {
    my ( $self, @args ) = @_;

    if ( $self->cookie_jar ) {
        $self->user_agent->cookie_jar( $self->cookie_jar );
    }
}

1;

