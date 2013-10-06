use utf8;
package Crawler::DB::Schema::Result::Feeder;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Crawler::DB::Schema::Result::Feeder

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<feeder>

=cut

__PACKAGE__->table("feeder");

=head1 ACCESSORS

=head2 url_md5

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 website_id

  data_type: 'integer'
  is_nullable: 0

=head2 page_num

  data_type: 'integer'
  is_nullable: 1

=head2 status

  data_type: 'varchar'
  is_nullable: 1
  size: 11

=head2 category

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "url_md5",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "website_id",
  { data_type => "integer", is_nullable => 0 },
  "page_num",
  { data_type => "integer", is_nullable => 1 },
  "status",
  { data_type => "varchar", is_nullable => 1, size => 11 },
  "category",
  { data_type => "varchar", is_nullable => 1, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</url_md5>

=back

=cut

__PACKAGE__->set_primary_key("url_md5");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-09-30 17:39:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WjacGa4RJqYKrZKOCkyi0w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
