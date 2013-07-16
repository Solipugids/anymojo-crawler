use utf8;
package Crawler::DB::Schema::Result::Website;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Crawler::DB::Schema::Result::Website

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<website>

=cut

__PACKAGE__->table("website");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 11

=head2 type

  data_type: 'varchar'
  is_nullable: 1
  size: 11

=head2 region

  data_type: 'varchar'
  is_nullable: 1
  size: 11

=head2 url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 desc

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 11 },
  "type",
  { data_type => "varchar", is_nullable => 1, size => 11 },
  "region",
  { data_type => "varchar", is_nullable => 1, size => 11 },
  "url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "desc",
  { data_type => "varchar", is_nullable => 1, size => 32 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-06-15 01:14:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kHiZhQURQ12kmf/PZrRZHA
# These lines were loaded from '/Users/mooser/anymojo-crawler/lib/Crawler/DB/Schema/Result/Website.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package Crawler::DB::Schema::Result::Website;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Crawler::DB::Schema::Result::Website

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<website>

=cut

__PACKAGE__->table("website");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 11

=head2 type

  data_type: 'varchar'
  is_nullable: 1
  size: 11

=head2 region

  data_type: 'varchar'
  is_nullable: 1
  size: 11

=head2 url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 desc

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 11 },
  "type",
  { data_type => "varchar", is_nullable => 1, size => 11 },
  "region",
  { data_type => "varchar", is_nullable => 1, size => 11 },
  "url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "desc",
  { data_type => "varchar", is_nullable => 1, size => 32 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-06-01 17:41:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pnr4GKJwZ70xdnOu3dugQw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
# End of lines loaded from '/Users/mooser/anymojo-crawler/lib/Crawler/DB/Schema/Result/Website.pm' 


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
