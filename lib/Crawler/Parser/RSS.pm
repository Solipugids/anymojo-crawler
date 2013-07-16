package Crawler::Parser::RSS;

use Moo;
use Crawler::Base -strict;
use Mojo::DOM;
use Mojo::Collection;
use Crawler::Data::RSS;

with 'Crawler::Logging';

has 'dom' => ( is => 'rw', default => sub { Mojo::DOM->new } );

sub parse {
    my ( $self, $xml, $charset ) = @_;
    my @result;

    my $dom = Mojo::DOM->new();
    $dom->xml(1);
    $dom->parse($xml);

    for my $item ( $dom->find('item')->each ) {
        push @result,
          Crawler::Data::RSS->new(
            title    => $item->at('title')->text,
            link     => $item->at('link')->text,
            pubdate  => $item->at('pubDate')->text,
            category => $item->at('category')
            ? $item->at('category')->text
            : 'unknown',
            desc    => $item->at('description')->text,
            content => $item->at('content\:encoded')->content_xml,
          );
    }
    return Mojo::Collection->new(@result);
}

sub parser_jeklly_rss {
    my ( $self, $xml, $charset ) = @_;

    my $dom = $self->dom;
    $dom->charset if $charset;
    $dom->xml(1);
    $dom->parse($xml);

}

sub tidy_code {
    my ( $self, $source_string, $lang ) = @_;
    use Perl::Tidy;
    my $dest_string;
    my $stderr_string;
    my $errorfile_string;
    my $argv = "-npro";    # Ignore any .perltidyrc at this site
    $argv .= " -pbp";      # Format according to perl best practices
    $argv .= " -nst";      # Must turn off -st in case -pbp is specified
    $argv .= " -se";       # -se appends the errorfile to stderr

    return if not defined $source_string;
    $lang ||= 'perl';
    if ( $lang !~ m{perl} ) {
        ( $dest_string = $source_string ) =~ s/;/\r\n/;
    }
    else {
        $self->log->debug("<<RAW SOURCE>>\n$source_string\n");
        my $error = Perl::Tidy::perltidy(
            argv        => $argv,
            source      => \$source_string,
            destination => \$dest_string,
            stderr      => \$stderr_string,
            errorfile   => \$errorfile_string,    # ignored when -se flag is set
        );
        if ($error) {
            # serious error in input parameters, no tidied output
            $self->log->error("<<STDERR>>\n$stderr_string\n");
            die "Exiting because of serious errors\n";
        }
    }

    return $dest_string;
}

1;
