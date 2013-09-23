package RSS;

use Moo;
use Crawler::Base -strict;
use Mojo::Collection;
use Digest::MD5 qw(md5_hex);
use Encode qw(decode_utf8 encode_utf8);

sub rss_parser {
    my ( $parser, $dom, $parsed_result, $attr ) = @_;

    if ( not exists $parsed_result->{WpPost} ) {
        $parsed_result->{WpPost} = [];
    }
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
        # ￥500
        if($item->title =~ m/(￥\s*[\d\.]+)/ ){
            $data->{price} = $1;
        }
        if($item->title =~ m/(\$\s*[\d\.]+)/ ){
            $data->{price} = $1;
        }
        else {
            $data->{price} = '未知';
        }
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
        if ( my $p = $dom->at('div.buy > a') ) {
            $single_parsed_result->{buylink} = $p->{href};
            require Mojo::URL;
            $single_parsed_result->{source} =
              'http://' . Mojo::URL->new( $p->{href} )->host;
        }
        else {
            $parser->log->error("Can't find this site's buylink ,next");
            return;
        }
        # handle wordpress img parse
        #say $dom->find('div.post_content > p')->[-1]->content_xml;
        $single_parsed_result->{preview_img} =
          $dom->at('div.thumb > img')->{'src'};
        if ( my $e = $dom->find('div.post_content > p')->[-1]->at('img') ) {
            $single_parsed_result->{img} = $e->{'src'};
        }
        else {
            $single_parsed_result->{img} = $single_parsed_result->{preview_img};
        }
        if ( not $single_parsed_result->{price} ) {
            ( $single_parsed_result->{price} ) =
              $dom->at('div.post_content')->content_xml =~
              m{((?:￥|\$)\s*\d+)}s;
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


