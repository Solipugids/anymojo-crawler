package RSS;

use Moo;
use Crawler::Base -strict;
use Mojo::Collection;
use Digest::MD5 qw(md5_hex);
use Encode qw(decode_utf8 encode_utf8);
use Data::Dumper;
use utf8;
use Mojo::Util qw(html_unescape xml_escape);
use HTML::TreeBuilder;
use Crawler::Util;
use HTML::Entities;
use Mojo::ByteStream qw(b);

sub rss_parser {
    my ( $parser, $dom, $parsed_result, $attr ) = @_;

    my $target = $parser->conf->{target};
    my $html   = $attr->{html};
    for my $item ( $dom->find('item')->each ) {
        next if not $item->at('link');
        my $data = {};
        $data->{url} = $item->at('link')->text;
        say "url is " . $data->{url};
        $data->{source_name} = $parser->conf->{name};
        $data->{title}       = $item->at('title')->text;
        $data->{source}      = $parser->conf->{base_url};
        $data->{author}      = $parser->conf->{author};
        my $category;
        $category = $item->at('category')->text;

        if ( $category =~ m{perl}six ) {
            $data->{category} = 'perl';
        }
        else {
            next;
        }
        $data->{post_date} =
          Crawler::Util::format_rss_time( $item->at('pubDate')->text );
        $data->{md5} = md5_hex( $data->{url} );
        push @{ $parsed_result->{$target} }, $data;
    }
}

sub web_parser {
    my ( $parser, $dom, $parsed_result, $attr ) = @_;

    my $pres = $dom->find('pre');
    if ( scalar(@$pres) ) {
        for my $pre ( $pres->each ) {
# <pre class="brush:perl;first-line:1;pad-line-numbers:true;highlight:null;collapse:false;">
            if ( $pre->{class} =~ m{(brush:\w+)} ) {
                $pre->{class} = $1;
                $pre =~ s{\r\n\r\n}{\r\n}sig;
                #$pre->replace_content($pre);
                say "pre code ".$pre;
            }
        }
    }
    $_->remove for $dom->find('script')->each;
    $parsed_result->{content} = decode_utf8( $dom->at('div.well') );
    $parser->log->debug("parsed html:\n".$parsed_result->{content});
    return 1;
}

1;

