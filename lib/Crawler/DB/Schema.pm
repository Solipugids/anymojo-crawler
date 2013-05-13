use utf8;

package Crawler::DB::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces( default_resultset_class => 'ResultSet', );

# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-12 13:57:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:97a0ZZnZMTNSVTVJ/h05+A

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
1;
