package RSS;

use Moo;
use Crawler::Base -strict;
use Mojo::Collection;
use Digest::MD5 qw(md5_hex);
use Encode qw(decode_utf8 encode_utf8);
use utf8;

sub rss_parser {
    my ( $parser, $dom, $parsed_result, $attr ) = @_;

    my $html = $attr->{html};
    for my $item ( $parser->rss->parse($html)->each ) {
        my $data = {};
        $data->{url}         = $item->link;
        $data->{source_name} = $parser->conf->{name};
        $data->{title}       = decode_utf8( $item->title );
        $data->{source}      = $attr->{base_url};
        if ( exists $parser->conf->{category_mapping}{ $item->category } ) {
            $data->{category} = $item->category;
        }
        # regex too long ,so split
        if ( $item->{title} =~ m{((?:￥|\$)\s*\d+)}six ) {
            $data->{price} = $1;
        }
        if ( $item->{title} =~ m{(\d+元)}six ) {
            $data->{price} = $1;
        }
        # THERMOS 膳魔师 2L 超大容量 帝王保温杯 32.5美元
        if ( $item->{title} =~ m{([\d\.]+美?元)}six ) {
            $data->{price} = $1;
        }
        else {
            $data->{price} = '未知';
        }
        $data->{title} = decode_utf8( $item->title );
        $data->{post_date} =
          Crawler::Util::format_rss_time( $item->{pubdate} );
        $data->{post_content} = $item->content;

        # <a href="http://www.mgpyh.com/25545-2/82360" target="_blank">
        push @{ $parsed_result->{WpPost} }, $data;
    }
    $parser->log->debug("parsed result below");
    $parser->dump($parsed_result);

    1; 
}

sub web_parser {
    my ( $parser, $dom, $single_parsed_result, $attr ) = @_;

    eval {
        if ( my $p = $dom->at('#main')->find('p')->[1] ){
            $single_parsed_result->{buylink} = $p->at('a')->{href};
            require Mojo::URL;
            $single_parsed_result->{sj} =
              Mojo::URL->new( $single_parsed_result->{buylink} )->host;
        }
        # handle wordpress img parse
        if ( my $e = $dom->at('img') ){
            $single_parsed_result->{img}         = $e->{'src'};
            $single_parsed_result->{preview_img} = $e->{'src'};
        }
        $single_parsed_result->{md5} =
          md5_hex( $single_parsed_result->{buylink} );
        $parser->log->debug(
            "result singe ************************************");
        $parser->dump($single_parsed_result);
    };
    if ($@) {
        $parser->log->error( "parser error:" . $@ );
        return 0;
    }
    return 1;
}

1;
__END__
parser_mapping:
    sj: $dom->at('sj')->text=~ m{商家：(\S+)}
    buy: $dom->at('buylink')->{href}

