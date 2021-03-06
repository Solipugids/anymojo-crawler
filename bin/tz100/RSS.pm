package RSS;

use Moo;
use Crawler::Base -strict;
use Mojo::Collection;
use Digest::MD5 qw(md5_hex);
use Encode qw(decode_utf8 encode_utf8);
use utf8;

sub rss_parser {
    my ( $parser, $dom, $parsed_result, $attr ) = @_;
    my $collection = pop;
    
    if ( not exists $parsed_result->{WpPost} ) {
        $parsed_result->{WpPost} = [];
    }
    my $html = $attr->{html};
    for my $item ( $parser->rss->parse($html)->each ) {
        my $data = {};
        $data->{url}    = $item->link;
        $data->{source_name} = $parser->conf->{name};
        $data->{title}  = decode_utf8( $item->title );
        $data->{source} = $attr->{base_url};
        if ( exists $parser->conf->{category_mapping}{ $item->category } ) {
            $data->{category} = $item->category;
        }
        if ( $item->{title} =~ m{((?:￥|\$)\s*\d+)|}six ) {
            $data->{price} = $1;
        }
        if ( $item->{title} =~ m{(\d+元)}six ) {
            $data->{price} = $1;
        }
        else {
            $data->{price} = '未知';
        }
        $data->{title} = decode_utf8( $item->title );
        $data->{post_date} =
          Crawler::Util::format_rss_time( $item->{pubdate} );
        $data->{post_content} = $item->content;

        push @{$collection}, { url => $item->link };

        # <a href="http://www.mgpyh.com/25545-2/82360" target="_blank">
        push @{ $parsed_result->{WpPost} }, $data;
        push @{$collection}, { url => $item->link };
    }
    $parser->log->debug("parsed result below");
    $parser->dump($parsed_result);

    return Mojo::Collection->new( @{ $parsed_result->{WpPost} } );
}

sub web_parser {
    my ( $parser, $dom, $single_parsed_result, $attr ) = @_;

    eval {
        if ( $dom->at('span.fade\ smaller')->text =~ m{商城：\s*(\S+)}sxi ) {
            $single_parsed_result->{sj} = $1;
        }
        $single_parsed_result->{buylink} = $dom->at('a.btn_buy')->{"href"};
        $single_parsed_result->{preview_img} =
          $dom->at('a.post_thumb_pic > img')->{"src"};
        # handle wordpress img parse
        if( my $e = $dom->at('div.pic-box > img') ){
            $single_parsed_result->{img} = $e->{'data-original'};
            $single_parsed_result->{preview_img} = $e->{'data-original'};
        }else{
            $single_parsed_result->{img} = $single_parsed_result->{preview_img};
        }
        $single_parsed_result->{md5} =
          md5_hex( $single_parsed_result->{buylink} );
        ( $single_parsed_result->{up} ) =
          $dom->at('div.thumbup')->text =~ m{(\d+)}six;
        $parser->log->debug("result singe ");
        $parser->dump($single_parsed_result);
    };
    if ($@) {
        $parser->log->error( "parser error:" . $@ );
    }
    return 1;
}

1;
__END__
parser_mapping:
    sj: $dom->at('sj')->text=~ m{商家：(\S+)}
    buy: $dom->at('buylink')->{href}
