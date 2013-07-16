package RSS;

use Moo;
use Crawler::Base -strict;
use Mojo::Collection;
use Digest::MD5 qw(md5_hex);
use Encode qw(decode_utf8 encode_utf8);
use YAML qw(Dump);
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
        if ( $item->title =~ m/(￥[\d\.]+)/ ) {
            $data->{price} = $1;
        }
        else {
            $data->{price} = '未知';
        }
        $data->{post_date} =
          Crawler::Util::format_rss_time( $item->{pubdate} );
        $data->{post_content} = decode_utf8($item->content);
        push @{ $parsed_result->{ $attr->{target} } }, $data;
    }
    $parser->log->debug( "parsed result below:" . Dump($parsed_result) );
}

sub web_parser {
    my ( $parser, $dom, $single_parsed_result, $attr ) = @_;

    eval {
        if ( my $p = $dom->at('a.a-btn') ) {
            $single_parsed_result->{buylink} = $p->{href};
            require Mojo::URL;
            $single_parsed_result->{source} =
              'http://' . Mojo::URL->new( $p->{href} )->host;
        }
        else {
            $parser->log->error("Can't find this site's buylink ,next");
            return;
        }

        if( my $node = $dom->find('img') ){
            $single_parsed_result->{preview_img} = $node->first->{'src'};
            $single_parsed_result->{img} = $single_parsed_result->{preview_img};
        }
        if ( $single_parsed_result->{price} eq '未知') {
            ( $single_parsed_result->{price} ) =
              $dom->at('a.x-buynow\ button\ green')->text;
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
