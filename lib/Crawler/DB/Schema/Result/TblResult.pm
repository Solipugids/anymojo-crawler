use utf8;
package Crawler::DB::Schema::Result::TblResult;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Crawler::DB::Schema::Result::TblResult

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<tbl_result>

=cut

__PACKAGE__->table("tbl_result");

=head1 ACCESSORS

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 type

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 author

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 album

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 hot_num

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "type",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "author",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "album",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "hot_num",
  { data_type => "integer", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-10-04 00:13:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sBws6hnQapmlIj1ikv9YXQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
