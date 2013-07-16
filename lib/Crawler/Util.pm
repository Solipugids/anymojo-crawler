package Crawler::Util;

use YAML qw(LoadFile Dump);
use Crawler::Base -strict;
use Crawler::DB::Schema;
use DateTime;
use DateTime::Format::RSS;

sub now {
    my $dt  = DateTime->now;
    my $now = sprintf( "%0.4d-%0.2d-%0.2d %0.2d:%0.2d:%0.2d",
        $dt->year, $dt->month, $dt->day, $dt->hour, $dt->min, $dt->sec );
    return $now;
}

sub format_rss_time {
    my $time_str = shift;
    my $dt       = DateTime::Format::RSS->parse_datetime($time_str);
    my $now      = sprintf( "%0.4d-%0.2d-%0.2d %0.2d:%0.2d:%0.2d",
        $dt->year, $dt->month, $dt->day, $dt->hour, $dt->min, $dt->sec );
    return $now;
}

sub load_configure {
    my $conf = shift;

    return $conf if ref($conf);
    Carp::croak("please check you conf file -> $conf is exists")
      if not -e $conf;
    return LoadFile($conf);
}

sub get_db_schema {
    my $db_conf = shift;

    return Crawler::DB::Schema->connect(
        $db_conf->{dsn},    $db_conf->{user},
        $db_conf->{passwd}, $db_conf->{option}
    );
}

sub tidy_code {
    my (  $source_string, $lang ) = @_;
    use Perl::Tidy;
    my $dest_string;
    my $stderr_string;
    my $errorfile_string;
    my $argv = "-npro";    # Ignore any .perltidyrc at this site
    $argv .= " -pbp";      # Format according to perl best practices
    $argv .= " -nst";      # Must turn off -st in case -pbp is specified
    $argv .= " -se";       # -se appends the errorfile to stderr

    return if not defined $source_string;
    $lang ||= 'perl';
    if (  $lang !~ m{perl} ) {
        ( $dest_string = $source_string ) =~ s/;/\r\n/;
    }
    else {
        print("<<RAW SOURCE>>\n$source_string\n");
        my $error = Perl::Tidy::perltidy(
            argv        => $argv,
            source      => \$source_string,
            destination => \$dest_string,
            stderr      => \$stderr_string,
            errorfile   => \$errorfile_string,    # ignored when -se flag is set
        );
        if ($error) {
            # serious error in input parameters, no tidied output
            print ("<<STDERR>>\n$stderr_string\n");
            die "Exiting because of serious errors\n";
        }
        if( $stderr_string ){
            print "stderr_string ".$stderr_string."\n";
        }
    }
    print("dest string :".$dest_string);

    return $dest_string;
}


1;
