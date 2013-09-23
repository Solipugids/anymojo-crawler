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
    for my $item ( $dom->find('entry')->each ) {
        my $data = {};
        $data->{url}         = $item->at('link')->{href} . "/";
        $data->{source_name} = $parser->conf->{name};
        $data->{title}       = $item->at('title')->text;
        $data->{source}      = $parser->conf->{base_url};
        $data->{author} = $parser->conf->{author};
        my $category;
        $category = $item->at('category')->text;
        my $tag_string = $category . $item->at('tags');
        $parser->log->debug("skip test $tag_string");
        $parser->log->debug("skip not perlblog") and next
          if index( $tag_string, 'perl' ) == -1;

        if ( $category and exists $parser->conf->{category_mapping}{$category} )
        {
            $data->{category} = $item->category;
        }
        else {
            $data->{category} = 'perl';
        }
        $data->{post_date} =
          Crawler::Util::format_rss_time( $item->at('updated')->text );
        $data->{md5} = md5_hex( $data->{url} );
        $data->{content} = html_unescape( $item->at('content')->text );
        push @{ $parsed_result->{$target} }, $data;
    }
}

sub web_parser {
    my ( $parser, $dom, $parsed_result, $attr ) = @_;
    my $rss_dom = Mojo::DOM->new();
    $rss_dom->parse( html_unescape( decode_utf8($parsed_result->{content} )) );
    my $tree           = HTML::TreeBuilder->new();
    my $dom_collection = $dom->find('div.highlight');
    my $rss_collection = $rss_dom->find('div.highlight');

    return if not scalar(@$dom_collection);

    for ( my $i = 0 ; $i < @$rss_collection ; $i++ ) {
        $tree->parse(  decode_utf8($dom_collection->[$i]  ));
        my $raw_code = $tree->as_text;
        my $lang = $rss_collection->[$i]->at('code')->{"class"};
        if ( $lang =~ m{perl}six || $raw_code =~ m/\bsub\b/six ) {
            eval { $raw_code = Crawler::Util::tidy_code( $raw_code, $lang ) };
        }
        $lang='perl';
        $rss_collection->[$i]->replace_content( '<pre class="brush:'
              . $lang . '">'
              . xml_escape($raw_code)
              . '</pre>' );

        #$parser->log->debug("after replace code div:".$rss_collection->[$i]);
    }
    $parsed_result->{content} = $rss_dom;
    $parser->log->dumper($parsed_result);
    return 1;
}

1;
