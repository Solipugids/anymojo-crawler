use Crawler::Base -strict;
use Crawler::Util;
use Mojo::Template;
use Mojo::DOM;
use Crawler::Publisher::WordPress;
use AnyEvent;
use Encode qw(encode_utf8 decode_utf8);
use File::Spec;
use Mojo::Util qw(html_unescape);
use YAML qw(LoadFile DumpFile Dump);
use utf8;

my $wp = Crawler::Publisher::WordPress->new(
    {
        proxy    => 'http://localhost/wordpress/xmlrpc.php',
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
my $template = File::Spec->catfile( $ENV{PROJECT_PATH}, 'conf', 'perl.template' );
$schema->storage->debug(1);

my $cv = AnyEvent->condvar;
my $w  = AnyEvent->timer(
    after    => 2,
    interval => 20,
    cb       => sub {
        my $rs = $schema->resultset('PerlBlog')->search(
            {
                status => { 'is' => undef },
            },
        );

        while ( my $row = $rs->next ) {
            next if not $row->md5;
            my $p = $row->content;
            $p =~ s/\n/<br>/g;
            $p =~ s/\r/<br>/g;
            my $content =
              $ht->render_file( $template, $row->img, $row->source,$p,$row->url);
            my $new_post = {};
            $new_post->{categories} = [];
            push @{ $new_post->{categories} }, encode_utf8( $row->category );
            $content=~ s/<br>/\r\n/g;
            $new_post->{description} = encode_utf8($content);
            $new_post->{title}       = encode_utf8( $row->title );
            $new_post->{mt_excerpt}  = encode_utf8(
                unpack( 'A180', $dom->parse($p)->find('p')->pluck('text') ) );
            #            $ht->render_file($template,{ img => 'xxx'});
            say "new_post", Dump($new_post);
            $wp->new_post( $new_post, 1 ) or die $@;
            $row->update( { status => 'sent' } );
        }
    }
);

$cv->recv;


