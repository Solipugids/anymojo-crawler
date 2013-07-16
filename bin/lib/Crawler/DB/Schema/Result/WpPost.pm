use utf8;
package Crawler::DB::Schema::Result::WpPost;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Crawler::DB::Schema::Result::WpPost

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<wp_post>

=cut

__PACKAGE__->table("wp_post");

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

=head2 price

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 preview_img

  data_type: 'text'
  is_nullable: 0

=head2 img

  data_type: 'text'
  is_nullable: 1

=head2 comment_times

  data_type: 'integer'
  is_nullable: 1

=head2 rating_times

  data_type: 'integer'
  is_nullable: 1

=head2 like

  data_type: 'integer'
  is_nullable: 1

=head2 dislike

  data_type: 'integer'
  is_nullable: 1

=head2 collect

  data_type: 'integer'
  is_nullable: 1

=head2 buylink

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

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

=head2 post_content

  data_type: 'text'
  is_nullable: 1

=head2 title

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
  "price",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "preview_img",
  { data_type => "text", is_nullable => 0 },
  "img",
  { data_type => "text", is_nullable => 1 },
  "comment_times",
  { data_type => "integer", is_nullable => 1 },
  "rating_times",
  { data_type => "integer", is_nullable => 1 },
  "like",
  { data_type => "integer", is_nullable => 1 },
  "dislike",
  { data_type => "integer", is_nullable => 1 },
  "collect",
  { data_type => "integer", is_nullable => 1 },
  "buylink",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
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
  "post_content",
  { data_type => "text", is_nullable => 1 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</md5>

=back

=cut

__PACKAGE__->set_primary_key("md5");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-06-15 01:14:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MGjYiWoo0AM7zQaTftBuVw
# These lines were loaded from '/Users/mooser/anymojo-crawler/lib/Crawler/DB/Schema/Result/WpPost.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package Crawler::DB::Schema::Result::WpPost;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Crawler::DB::Schema::Result::WpPost

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<wp_post>

=cut

__PACKAGE__->table("wp_post");

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

=head2 price

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 preview_img

  data_type: 'text'
  is_nullable: 0

=head2 img

  data_type: 'text'
  is_nullable: 1

=head2 comment_times

  data_type: 'integer'
  is_nullable: 1

=head2 rating_times

  data_type: 'integer'
  is_nullable: 1

=head2 like

  data_type: 'integer'
  is_nullable: 1

=head2 dislike

  data_type: 'integer'
  is_nullable: 1

=head2 collect

  data_type: 'integer'
  is_nullable: 1

=head2 buylink

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

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

=head2 post_content

  data_type: 'text'
  is_nullable: 1

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "url_md5",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "source",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "category",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 20 },
  "price",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "preview_img",
  { data_type => "text", is_nullable => 0 },
  "img",
  { data_type => "text", is_nullable => 1 },
  "comment_times",
  { data_type => "integer", is_nullable => 1 },
  "rating_times",
  { data_type => "integer", is_nullable => 1 },
  "like",
  { data_type => "integer", is_nullable => 1 },
  "dislike",
  { data_type => "integer", is_nullable => 1 },
  "collect",
  { data_type => "integer", is_nullable => 1 },
  "buylink",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
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
  "post_content",
  { data_type => "text", is_nullable => 1 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</url_md5>

=back

=cut

__PACKAGE__->set_primary_key("url_md5");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-06-01 22:55:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jRZVKb10f+VxzQNznxvEOA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
# End of lines loaded from '/Users/mooser/anymojo-crawler/lib/Crawler/DB/Schema/Result/WpPost.pm' 


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
