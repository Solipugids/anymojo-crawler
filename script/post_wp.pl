use Crawler::Base -strict;
use Crawler::Util;
use Mojo::Template;
use Mojo::DOM;
use Crawler::Publisher::WordPress;
use AnyEvent;
use Encode qw(encode_utf8 decode_utf8);
use File::Spec;
use YAML qw(LoadFile DumpFile Dump);
use utf8;

my $wp = Crawler::Publisher::WordPress->new(
    {
        proxy    => 'http://htzdy.com/xmlrpc.php',
        username => 'admin',
        password => 'Jin19841002',
    }
);
my $dom = Mojo::DOM->new;

#  WordPress->new( 'http://127.0.0.1/wordpress/xmlrpc.php', 'admin', 'Jin19841002', );
my $site_list = shift;
my $conf = File::Spec->catfile( $ENV{PROJECT_PATH}, 'conf', 'crawler.yaml' );
my $configure = LoadFile($conf);
my $schema    = Crawler::Util::get_db_schema( $configure->{task_db} );
my $ht        = Mojo::Template->new;
my $template = File::Spec->catfile( $ENV{PROJECT_PATH}, 'conf', 'wp.template' );
$schema->storage->debug(1);

my $cv = AnyEvent->condvar;
my $w  = AnyEvent->timer(
    after    => 2,
    interval => 10,
    cb       => sub {
        my $rs = $schema->resultset('WpPost')->search(
            {
                status => { 'is' => undef },
            },
            { order_by => { -asc => 'comment_times' } },
        );

        while ( my $row = $rs->next ) {
            next if not $row->md5;
            my $p = $row->post_content;
            $p =~ s{\<\!\[CDATA\[}{}g;
            $p =~ s{\]\]\>}{}g;
            $p =~ s{<img.*?>}{}g;
            if ( index( $p, 'img' ) == -1 ) {
                my $img_src = $row->preview_img;
                $p .= <<EOF;
<p><img class="alignnone" title=" " src="$img_src" alt="" width="483" height="483"></p>
EOF
            }

            my $content =
              $ht->render_file( $template, $row->img, $row->source, $row->price,
                $row->buylink, $p, $row->url );
            my $new_post = {};
            $new_post->{categories} = [];
            push @{ $new_post->{categories} }, encode_utf8( $row->category );
            $new_post->{description} = encode_utf8($content);
            $new_post->{title}       = encode_utf8( $row->title );
            $new_post->{mt_excerpt}  = encode_utf8(
                unpack( 'A180', $dom->parse($p)->find('p')->pluck('text') ) );

            #$new_post->{mt_excerpt} ='category';
            $new_post->{custom_fields} = [
                {
                    'value' => encode_utf8( $row->price ),
                    'key'   => 'price'
                },
                {
                    value => $row->buylink,
                    key   => 'saleurl',
                },
                {
                    value => encode_utf8( $row->sj ),
                    key   => 'sj',
                },
            ];

            #            $ht->render_file($template,{ img => 'xxx'});
            say "new_post", Dump($new_post);
            $wp->new_post( $new_post, 1 ) or die $@;
            $row->update( { status => 'sent' } );
        }
    }
);

$cv->recv;

