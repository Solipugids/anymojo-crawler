    #!/usr/bin/env perl
    use strict;
    use warnings;
    use Data::Dumper;

    my $cpanm_path = shift;

    $cpanm_path = qx{which cpanm};
    chomp($cpanm_path);
    my $usage =<<EOF;
    $0 /usr/sbin/cpanm
EOF

    if( not $cpanm_path ){
        die "please defined you cpanm_path\n please input as the example: $usage";
    }
    my @module_list = qw(
       AnyEvent
       AnyEvent::HTTP
       Coro
       DBD::SQLite
       DBD::mysql
       DBIx::Class
       DBIx::Class::Schema::Loader
       Data::Dump
       Date::Time
       DateTime
       DateTime::Format::Builder
       DateTime::Format::DateParse
       DateTime::Format::ISO8601
       DateTime::Format::Mail
       DateTime::Format::RSS
       DateTime::Format::Strptime
       DateTime::Format::W3CDTF
       DateTime::TimeZone
       DateTime::Tiny
       EV
       JSON
       JSON::XS
       LWP
       List::Util
       Mojolicious
       Moo
       MooseX::MarkAsMethods
       Moose
       Object::Event
       Parallel::ForkManager
       TryCatch
       URL::Encode
       WordPress
       WordPress::API
       WordPress::XMLRPC
       YAML
       namespace::clean
       File::Temp
       AnyEvent::MultiDownload;
       AnyEvent::Curl::Multi
       LWP
       List::Util
       Parallel::ForkManager
       MP3::Tag
    );

    my $pre = "$cpanm_path";
    system($pre,$_) for @module_list;


