use utf8;
package Crawler::DB::Schema::Result::SpInfo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Crawler::DB::Schema::Result::SpInfo

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<sp_info>

=cut

__PACKAGE__->table("sp_info");

=head1 ACCESSORS

=head2 url_md5

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 buy_link

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 preview_img

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 modal_img

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sing_price

  data_type: 'float'
  is_nullable: 1

=head2 batch_price

  data_type: 'float'
  is_nullable: 1

=head2 seller_address

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 rating

  data_type: 'float'
  is_nullable: 1

=head2 buy_times_per_month

  data_type: 'integer'
  is_nullable: 1

=head2 recent_buy_times

  data_type: 'integer'
  is_nullable: 1

=head2 comment_times

  data_type: 'integer'
  is_nullable: 1

=head2 shop_name

  data_type: 'varchar'
  is_nullable: 1
  size: 11

=head2 style

  data_type: 'varchar'
  is_nullable: 1
  size: 11

=cut

__PACKAGE__->add_columns(
  "url_md5",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "buy_link",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "preview_img",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "modal_img",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sing_price",
  { data_type => "float", is_nullable => 1 },
  "batch_price",
  { data_type => "float", is_nullable => 1 },
  "seller_address",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "rating",
  { data_type => "float", is_nullable => 1 },
  "buy_times_per_month",
  { data_type => "integer", is_nullable => 1 },
  "recent_buy_times",
  { data_type => "integer", is_nullable => 1 },
  "comment_times",
  { data_type => "integer", is_nullable => 1 },
  "shop_name",
  { data_type => "varchar", is_nullable => 1, size => 11 },
  "style",
  { data_type => "varchar", is_nullable => 1, size => 11 },
);

=head1 PRIMARY KEY

=over 4

=item * L</url_md5>

=back

=cut

__PACKAGE__->set_primary_key("url_md5");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-06-15 01:14:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cD4lmphZx9LdShF24pQufA
# These lines were loaded from '/Users/mooser/anymojo-crawler/lib/Crawler/DB/Schema/Result/SpInfo.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package Crawler::DB::Schema::Result::SpInfo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Crawler::DB::Schema::Result::SpInfo

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<sp_info>

=cut

__PACKAGE__->table("sp_info");

=head1 ACCESSORS

=head2 url_md5

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 buy_link

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 preview_img

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 modal_img

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sing_price

  data_type: 'float'
  is_nullable: 1

=head2 batch_price

  data_type: 'float'
  is_nullable: 1

=head2 seller_address

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 rating

  data_type: 'float'
  is_nullable: 1

=head2 buy_times_per_month

  data_type: 'integer'
  is_nullable: 1

=head2 recent_buy_times

  data_type: 'integer'
  is_nullable: 1

=head2 comment_times

  data_type: 'integer'
  is_nullable: 1

=head2 shop_name

  data_type: 'varchar'
  is_nullable: 1
  size: 11

=head2 style

  data_type: 'varchar'
  is_nullable: 1
  size: 11

=cut

__PACKAGE__->add_columns(
  "url_md5",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "buy_link",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "preview_img",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "modal_img",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sing_price",
  { data_type => "float", is_nullable => 1 },
  "batch_price",
  { data_type => "float", is_nullable => 1 },
  "seller_address",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "rating",
  { data_type => "float", is_nullable => 1 },
  "buy_times_per_month",
  { data_type => "integer", is_nullable => 1 },
  "recent_buy_times",
  { data_type => "integer", is_nullable => 1 },
  "comment_times",
  { data_type => "integer", is_nullable => 1 },
  "shop_name",
  { data_type => "varchar", is_nullable => 1, size => 11 },
  "style",
  { data_type => "varchar", is_nullable => 1, size => 11 },
);

=head1 PRIMARY KEY

=over 4

=item * L</url_md5>

=back

=cut

__PACKAGE__->set_primary_key("url_md5");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-27 17:54:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZfizLlQApKxx1FN8sauytQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
# End of lines loaded from '/Users/mooser/anymojo-crawler/lib/Crawler/DB/Schema/Result/SpInfo.pm' 


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
