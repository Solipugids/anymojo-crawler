use utf8;
package Crawler::DB::Schema::Result::TaskDetail;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Crawler::DB::Schema::Result::TaskDetail

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<task_detail>

=cut

__PACKAGE__->table("task_detail");

=head1 ACCESSORS

=head2 url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 url_md5

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=cut

__PACKAGE__->add_columns(
  "url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "id",
  { data_type => "integer", is_nullable => 0 },
  "url_md5",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-09-26 15:40:34
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pM/i9Mj6dF9t4XCAnkAxRw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
