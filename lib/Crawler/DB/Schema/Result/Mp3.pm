use utf8;
package Crawler::DB::Schema::Result::Mp3;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Crawler::DB::Schema::Result::Mp3

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<mp3>

=cut

__PACKAGE__->table("mp3");

=head1 ACCESSORS

=head2 url_md5

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 url

  data_type: 'text'
  is_nullable: 1

=head2 artist_name

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 artist_id

  data_type: 'integer'
  is_nullable: 1

=head2 location

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

=head2 hq_location

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

=head2 song_logo

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

=head2 album_id

  data_type: 'integer'
  is_nullable: 1

=head2 album

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 album_logo

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 website_id

  data_type: 'integer'
  is_nullable: 1

=head2 status

  data_type: 'varchar'
  default_value: 'undo'
  is_nullable: 1
  size: 20

=head2 company

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 hot_num

  data_type: 'integer'
  is_nullable: 1

=head2 type

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 lrc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 download_path

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 timestamp

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 size

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "url_md5",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "url",
  { data_type => "text", is_nullable => 1 },
  "artist_name",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "artist_id",
  { data_type => "integer", is_nullable => 1 },
  "location",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
  "hq_location",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
  "song_logo",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
  "album_id",
  { data_type => "integer", is_nullable => 1 },
  "album",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "album_logo",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "website_id",
  { data_type => "integer", is_nullable => 1 },
  "status",
  {
    data_type => "varchar",
    default_value => "undo",
    is_nullable => 1,
    size => 20,
  },
  "company",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "hot_num",
  { data_type => "integer", is_nullable => 1 },
  "type",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "lrc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "download_path",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "timestamp",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "size",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</url_md5>

=back

=cut

__PACKAGE__->set_primary_key("url_md5");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-10-04 00:34:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KjGzSrweHUQDblhH/owqTQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
