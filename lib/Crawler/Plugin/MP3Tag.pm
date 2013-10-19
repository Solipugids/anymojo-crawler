package Crawler::Plugin::MP3Tag;

use Moo::Role;

use MP3::Tag;
use Mojo::Util 'slurp';
use Encode qw(decode_utf8 encode_utf8 decode encode);
use IO::File;
use utf8;

use constant COVERART_LOCATOR => "coverart";
use constant PICTURE_TYPE     => "Cover (front)";
use constant PICTURE_COMMENT  => "Cover Image";
use constant APIC             => "APIC";

=pod
my $id3_info = {
    album      => '无与伦比的美丽',
    artist     => '苏打绿',
    title      => '无与伦比的美丽',
    album_logo => $image,
};
=cut

sub modify_id3_info {
    my ( $self, $file, $info, $image, $lyric ) = @_;
    my $mp3 = MP3::Tag->new($file);
    eval {
        $mp3->get_tags();
        $mp3->{ID3v2}->remove_tag() if exists $mp3->{ID3v2};
        $mp3->{ID3v1}->remove_tag() if exists $mp3->{ID3v1};
        my $artist   = $info->author;
        my $title    = $info->title;
        my $album    = $info->album;
        my $name     = $info->name;
        my $composer = $info->composer;
        my $company  = $info->company;
        my $track    = $info->track;
        my $language = $info->language;
        my ( $year, $date );

        if ($info->publish_date  and $info->publish_date =~ m/(\d+)-(\d+-\d+)/six ) {
            $year = $1;
            $date = $2;
        }
        my $description = $info->description;
        my $style       = $info->style;
        my $songwriters = $info->songwriters;
        my $lyric_text;
        my $decoded_desc;
        my $decoded_lric;
        if ($lyric) {
            $lyric_text = slurp($lyric);
        }
        $style =~ s/专辑风格.*//g if $style;

        {
            local $SIG{__WARN__} = sub{ die "Encode error " };
            if ($lyric_text) {
                for (
                    'utf8',        'latin1', 'iso-8859-1',
                    'iso-8859-15', 'cp1252', 'cp1251'
                  )
                {
                    eval {
                        $decoded_lric = decode( $_, $lyric_text );
                        print $decoded_lric;
                        last;
                    };
                    if ($@) {
                        $decoded_lric = undef;
                    }
                }
            }
            if ($description) {
                for (
                    'utf8',        'latin1', 'iso-8859-1',
                    'iso-8859-15', 'cp1252', 'cp1251'
                  )
                {
                    eval {
                        $decoded_desc = decode( $_, $description );
                        print $decoded_desc;
                        last;
                    };
                    if ($@) {
                        $decoded_desc = undef;
                    }
                }
            }
        }
        $lyric_text  = $decoded_lric if $decoded_lric;
        $description = $decoded_desc if $decoded_desc;

        my $id3v2 = $mp3->new_tag('ID3v2');
        if ( my $bitrate = $mp3->bitrate_kbps ) {
            $info->bitrate(int($bitrate));
        }
        $id3v2->add_frame( 'USLT', 3, 'eng', '', $lyric_text )
          if $lyric_text;
        $id3v2->add_frame( 'TRCK', $track )    if defined $track;
        $id3v2->add_frame( 'TYER', $year )     if $year;
        $id3v2->add_frame( 'TDAT', $date )     if $date;
        $id3v2->add_frame( 'TALB', $album )    if $album;
        $id3v2->add_frame( 'TCON', $style )    if $style;
        $id3v2->add_frame( 'TPE1', $artist )   if $artist;
        $id3v2->add_frame( 'TPUB', $company )  if $company;
        $id3v2->add_frame( 'TCOM', $composer ) if $composer;
        $id3v2->add_frame( 'TDAT', $date )     if $date;
        $id3v2->add_frame( 'TLAN', ($language) ) if $language;
        $id3v2->add_frame( 'TEXT', $songwriters ) if $songwriters;
        $id3v2->add_frame( 'COMM', 3, 'eng', 'desc', $description )
          if $description;

        attach( $mp3, $image ) if $image and -e $image;
        $id3v2->write_tag();
        $mp3->close();
    };
    if ($@) {
        $self->log->error("make mp3 tag err: $@");
        return 0;
    }

    return 1;
}

sub attach {
    my ( $mp3, $image_file ) = @_;
    $mp3->get_tags();
    if ( !defined $mp3->{ID3v2} ) {
        $mp3->new_tag("ID3v2");
    }
    if ( !defined $mp3->{ID3v2} ) {
        return undef;
    }

    my ( $mime_type, $image_data ) = read_image($image_file);
    return undef if ( !defined $mime_type );

    my $encoding   = 0;
    my @apic_parts = (
        $encoding, $mime_type, picture_type_idx(PICTURE_TYPE),
        PICTURE_COMMENT, $image_data
    );
    if ( defined $mp3->{ID3v2}->get_frame(APIC) ) {
        $mp3->{ID3v2}->change_frame( APIC, @apic_parts );
    }
    else {
        $mp3->{ID3v2}->add_frame( APIC, @apic_parts );
    }
    $mp3->{ID3v2}->write_tag();

    return $image_file;
}

sub read_image {
    my ($file_name) = @_;
    my $image_type;
    my $image_data;

    if ( !-f $file_name ) {
        error("Cannot read file \"$file_name\"");
        return;
    }
    if ( $file_name =~ /\.jpg$/i ) {
        $image_type = "jpg";
        my $ifh = IO::File->new($file_name);
        if ( !defined $ifh ) {
            error("Failed to open \"$file_name\"");
            return;
        }
        binmode $ifh;
        $image_data = "";
        while ( !$ifh->eof() ) {
            my $c = $ifh->read( $image_data, 1024 * 16, length($image_data) );
        }
        $ifh = undef;
    }
    if ( !defined $image_type ) {
        error("Does not yet support file type for \"$file_name\"");
        return;
    }
    if ( !defined $image_data ) {
        error("Cannot extract $image_type data from \"$file_name\"");
        return;
    }

    return ( "image/$image_type", $image_data );
}

sub picture_type_idx {

    # Given a picture type string convert it into a number suitable
    # for MP3::Tag
    my ($picture_type) = @_;

    # The picture types that are currently understood (from MP3::Tag::ID3v2):
    my @picture_types = (
        "Other",
        "32x32 pixels 'file icon' (PNG only)",
        "Other file icon",
        "Cover (front)",
        "Cover (back)",
        "Leaflet page",
        "Media (e.g. lable side of CD)",
        "Lead artist/lead performer/soloist",
        "Artist/performer",
        "Conductor",
        "Band/Orchestra",
        "Composer",
        "Lyricist/text writer",
        "Recording Location",
        "During recording",
        "During performance",
        "Movie/video screen capture",
        "A bright coloured fish",
        "Illustration",
        "Band/artist logotype",
        "Publisher/Studio logotype"
    );

    # This approach is easy to understand
    for ( my $i = 0 ; $i <= $#picture_types ; $i++ ) {
        if ( lc($picture_type) eq lc( $picture_types[$i] ) ) {
            return chr($i);
        }
    }
    error("The picture type \"$picture_type\" is not valid");
    return chr(3);
}

1;

