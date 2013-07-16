use strict;
use warnings;
use Digest::MD5 qw(md5_hex);
use Test::More qw(no_plan);
use YAML qw(Dump);
use lib "../lib";
use 5.010;

BEGIN {
    use_ok("Crawler");
}

my $c = Crawler->new(
    conf => {
        log => {
            level => 'debug',
        },
        meta_db => {
            dsn    => '127.0.0.1:27107',
            user   => 'root',
            passwd => 'root',
        },
        task_db => {

            #my $dsn    = 'DBI:mysql:dbname=crawler;host=127.0.0.1';
            dsn    => 'DBI:mysql:dbname=crawler;host=127.0.0.1',
            user   => 'root',
            passwd => '',
            option => {
                mysql_enable_utf8 => 1,
            },
        },
        mongo => {
            host => '127.0.0.1',
        },
        'www.mgpyh.com' => {
            parser => {
                category_mapping => {},
                url_pattern      => {
                    'mgpyh.com.*?page' => 'page',
                    'mgpyh.*?category' => 'feeder',
                    'mgpyh.*?html$'    => 'archive',
                    'mgpyh.com/?$'     => 'home',
                },
                base_url => 'http://www.mgpyh.com/'
            },
        }
    },
    site            => 'www.mgpyh.com',
    scan_start_time => undef,
    scan_stop_time  => undef,
    debug           => 1,
    source_type     => 'archive',
);

is( $c->site,            'www.mgpyh.com', 'test crawler passed task arg' );
is( $c->scan_start_time, undef,           'test scan_start_time arg' );
is( $c->scan_stop_time,  undef,           'test scan_stop_time arg' );
is( $c->debug,           1,               'test debug args' );
is( $c->log->path,       undef,           'test log path args' );
is( $c->log->level,      'debug',         'test debug level args' );

=pod
                          $self->parser->parse( $entry, $html, $parsed_result,
                            $self->schema, $self->mongo );
=cut
$c->schema->storage->debug(1);
$c->register_parser(
    home => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        
        for my $e ( $dom->at('#widget_categories')->find('a')->each ) {
            say "category is : ", $e->text;
            push @{ $parsed_result->{feeder} },
              {
                url_md5    => md5_hex( $e->{href} ),
                website_id => $attr->{website_id},
                url        => $e->{href},
                status     => 'undo',
              };
        }
        say Dump($parsed_result);
        return 1;
    },
    feeder => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        # <a href="http://www.mgpyh.com/category/amazon-deals/page/2" class="page" title="2">2</a>
        my $page_prefix = 'http://www.mgpyh.com/category/amazon-deals/page/';
        my ($total) = $dom->find('span.pages')->first->text =~ m/(\d+)/;
        $parser->log->debug("get feeder pages total is : $total");
        for my $page_num(1.. $total){
            my $page_info = {
                url => $page_prefix.$page_num,
                url_md5 => md5_hex($page_prefix.$page_num),
                category_id => 1,
                website_id => $attr->{website_id},
            };
            push @{ $parsed_result->{page} },$page_info;
        }
        return 0 if @{$parsed_result->{page}} == 0;
        return 1;
    },
    page => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;

        for my $e( $dom->find('div.list_title')->each ){
            my $archive_info = {
                url => $e->at('a')->{href},
                url_md5 => md5_hex($e->at('a')->{href}),
                website_id => $attr->{website_id},
                category_id => 1,
                status => 'undo'
            };
            push @{ $parsed_result->{archive} },$archive_info;
        }
        return 0 if @{ $parsed_result->{archive} } ==0;
        return 1;
    },
    archive => sub {
        my ( $parser, $dom, $parsed_result, $attr ) = @_;
        
        if( not exists $parsed_result->{wp_post} ){
            $parsed_result->{wp_post} = [];
        }

        my $data = {};
        $data->{url} = $attr->{url};
        $data->{url_md5} = md5_hex( $attr->{url} );
        $data->{source} = $attr->{website_url};
        $data->{post_content} = $dom->find( 'div.post_content')->first->text;
        $data->{category} = $dom->find('span.cates > a')->first->text;
        $data->{post_date} = $dom->find('span.date')->first->text;

        return 1;
    }
);

=pod
CREATE TABLE `task` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `type` varchar(11) NOT NULL DEFAULT '',
  `retry_times` int(11) DEFAULT NULL,
  `invoke_cmd` varchar(11) DEFAULT NULL,
  `status` varchar(11) NOT NULL DEFAULT '',
  `site_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
=cut

my @test_url = qw(
  http://www.mgpyh.com
  http://www.mgpyh.com/category/amazon-deals
  http://www.mgpyh.com/category/amazon-deals/page/3
  http://www.mgpyh.com/arcteryx-alpha-sv-glove-2.html
);

$c->run(7);
exit;

$c->schema->resultset('Home')->find_or_create(
    {
        url => 'http://www.mgpyh.com',
        url_md5 => md5_hex('http://www.mgpyh.com'),
        status => 'undo'
    }
);

for my $test (@test_url) {
    my $rs = $c->schema->resultset('Task')->create(
        {
            start_time => '2013-05-21 10:00:00',
            status     => 'undo',
            site_id    => 2,
        },
    );
    $c->schema->resultset('TaskDetail')->create(
        {
            url     => $test,
            url_md5 => md5_hex($test),
            id      => $rs->id,
        }
    );
    my $stat = $c->run( $rs->id );
    is( $stat->{status}, 'success', 'test crawler status' );
}
