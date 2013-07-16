use utf8;
package Crawler::DB::Schema::Result::Page;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Crawler::DB::Schema::Result::Page

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<page>

=cut

__PACKAGE__->table("page");

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

=head2 category_id

  data_type: 'integer'
  is_nullable: 0

=head2 website_id

  data_type: 'integer'
  is_nullable: 0

=head2 status

  data_type: 'varchar'
  is_nullable: 1
  size: 11

=cut

__PACKAGE__->add_columns(
  "url_md5",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "category_id",
  { data_type => "integer", is_nullable => 0 },
  "website_id",
  { data_type => "integer", is_nullable => 0 },
  "status",
  { data_type => "varchar", is_nullable => 1, size => 11 },
);

=head1 PRIMARY KEY

=over 4

=item * L</url_md5>

=back

=cut

__PACKAGE__->set_primary_key("url_md5");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-06-15 01:14:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nRnalOzgVN8zubhf9SRjRw
# These lines were loaded from '/Users/mooser/anymojo-crawler/lib/Crawler/DB/Schema/Result/Page.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package Crawler::DB::Schema::Result::Page;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Crawler::DB::Schema::Result::Page

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<page>

=cut

__PACKAGE__->table("page");

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

=head2 category_id

  data_type: 'integer'
  is_nullable: 0

=head2 website_id

  data_type: 'integer'
  is_nullable: 0

=head2 status

  data_type: 'varchar'
  is_nullable: 1
  size: 11

=cut

__PACKAGE__->add_columns(
  "url_md5",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "category_id",
  { data_type => "integer", is_nullable => 0 },
  "website_id",
  { data_type => "integer", is_nullable => 0 },
  "status",
  { data_type => "varchar", is_nullable => 1, size => 11 },
);

=head1 PRIMARY KEY

=over 4

=item * L</url_md5>

=back

=cut

__PACKAGE__->set_primary_key("url_md5");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-13 16:15:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7KrPl9BlzjjRnBU3480ArQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
# End of lines loaded from '/Users/mooser/anymojo-crawler/lib/Crawler/DB/Schema/Result/Page.pm' 


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
