use Crawler::Entry::Feeder;

my $f = Crawler::Entry::Feeder->new( url => 'http://mooser.me');
$f->reg_parser(sub {
        print "hello parser\n";
    }
);
$f->start;
$f->event( "on_start");
