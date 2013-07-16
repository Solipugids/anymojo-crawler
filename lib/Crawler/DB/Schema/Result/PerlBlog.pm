use utf8;
package Crawler::DB::Schema::Result::PerlBlog;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Crawler::DB::Schema::Result::PerlBlog

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<perl_blog>

=cut

__PACKAGE__->table("perl_blog");

=head1 ACCESSORS

=head2 md5

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 source

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 category

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 20

=head2 img

  data_type: 'text'
  is_nullable: 1

=head2 comment_times

  data_type: 'integer'
  is_nullable: 1

=head2 rating_times

  data_type: 'integer'
  is_nullable: 1

=head2 down

  data_type: 'integer'
  is_nullable: 1

=head2 up

  data_type: 'integer'
  is_nullable: 1

=head2 post_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 status

  data_type: 'varchar'
  is_nullable: 1
  size: 11

=head2 share_count

  data_type: 'integer'
  is_nullable: 1

=head2 content

  data_type: 'text'
  is_nullable: 1

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 mall_link

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 source_name

  accessor: undef
  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "md5",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "source",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "category",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 20 },
  "img",
  { data_type => "text", is_nullable => 1 },
  "comment_times",
  { data_type => "integer", is_nullable => 1 },
  "rating_times",
  { data_type => "integer", is_nullable => 1 },
  "down",
  { data_type => "integer", is_nullable => 1 },
  "up",
  { data_type => "integer", is_nullable => 1 },
  "post_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "status",
  { data_type => "varchar", is_nullable => 1, size => 11 },
  "share_count",
  { data_type => "integer", is_nullable => 1 },
  "content",
  { data_type => "text", is_nullable => 1 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "mall_link",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "source_name",
  { accessor => undef, data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</md5>

=back

=cut

__PACKAGE__->set_primary_key("md5");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-07-05 10:16:03
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JUwk9XXc/QM2C+FUfMAKWA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
