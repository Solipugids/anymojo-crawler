use utf8;
package Crawler::DB::Schema::Result::Task;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Crawler::DB::Schema::Result::Task

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<task>

=cut

__PACKAGE__->table("task");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 start_time

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 end_time

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 11

=head2 retry_times

  data_type: 'integer'
  is_nullable: 1

=head2 invoke_cmd

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 status

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 11

=head2 site_id

  data_type: 'integer'
  is_nullable: 1

=head2 size

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "start_time",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "end_time",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 11 },
  "retry_times",
  { data_type => "integer", is_nullable => 1 },
  "invoke_cmd",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "status",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 11 },
  "site_id",
  { data_type => "integer", is_nullable => 1 },
  "size",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-10-03 15:09:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vcFoxBAfvO3Oaq/reyuRHg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
