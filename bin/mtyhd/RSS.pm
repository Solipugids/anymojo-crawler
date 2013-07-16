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

    for my $item ( $dom->find('item')->each ){
        my $data = {};
        $data->{url}         = $item->at('link')->text;
        $data->{source_name} = $parser->conf->{name};
        $data->{title}       = decode_utf8( $item->at('title')->text );
        $data->{source}      = $attr->{base_url};

        # regex too long ,so split
        if ( $data->{title} =~ m{((?:￥|\$)\s*\d+)|}six ) {
            $data->{price} = $1;
        }
        if ( $data->{title} =~ m{(\d+元)}six ) {
            $data->{price} = $1;
        }
        else {
            $data->{price} = '未知';
        }
        $data->{post_date} =
          Crawler::Util::format_rss_time( $item->at('pubDate')->text );
        $data->{post_content} = decode_utf8($item->at('description')->text);
        push @{ $parsed_result->{ $attr->{target} } }, $data;
    }
    $parser->log->debug("parsed result below:".Dump($parsed_result) );
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
        $single_parsed_result->{preview_img} = $dom->at('div.thumb > img')->{'src'};
        $single_parsed_result->{img} = $single_parsed_result->{preview_img};
        if( not $single_parsed_result->{category} ){
            my $c = $dom->find('div.breadcrumbs > a')->[-1]->text;
            if( not exists $parser->conf->{category_mapping}{$c} ){
                $single_parsed_result->{category} = $c;
            }else{
                $single_parsed_result = $parser->conf->{category_mapping}{$c};
            }
        }

        $single_parsed_result->{sj} = $dom->at('div.mall > a')->text;
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
