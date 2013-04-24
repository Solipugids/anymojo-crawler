package Crawler::Base;

use strict;
use warnings;
use feature ();
use Carp ();
use TryCatch;

# Only Perl 5.14+ requires it on demand
use IO::Handle ();

sub import {
    my $class = shift;
    my $caller = caller;
    return unless my $flag = shift;

    # No limits!
    no strict 'refs';

    # Base
    if ( $flag eq '-mojo' ) { $flag = $class }

    # Strict
    elsif ( $flag eq '-strict' ) { $flag = undef }
    # Module
    else {
        my $file = $flag;
        $file =~ s/::|'/\//g;
        require "$file.pm" unless $flag->can('new');
    }

    strict->import;
    warnings->import;
    Carp->import('croak');
    utf8->import();
    feature->import(':5.12');
    English->import("-no_match_vars");
    TryCatch->import();
}

sub new {
    my $class = shift;
    bless @_ ? @_ > 1 ? {@_} : { %{ $_[0] } } : {}, ref $class || $class;
}

# Performance is very important for something as often used as accessors,
# so we optimize them by compiling our own code, don't be scared, we have
# tests for every single case
sub attr {
    my ( $class, $attrs, $default ) = @_;
    return unless ( $class = ref $class || $class ) && $attrs;

    # Check default
    Carp::croak('Default has to be a code reference or constant value')
      if ref $default && ref $default ne 'CODE';

    # Create attributes
    for my $attr ( @{ ref $attrs eq 'ARRAY' ? $attrs : [$attrs] } ) {
        Carp::croak(qq{Attribute "$attr" invalid})
          unless $attr =~ /^[a-zA-Z_]\w*$/;

        # Header (check arguments)
        my $code = "package $class;\nsub $attr {\n  if (\@_ == 1) {\n";

        # No default value (return value)
        unless ( defined $default ) { $code .= "    return \$_[0]{'$attr'};" }

        # Default value
        else {

            # Return value
            $code .= "    return \$_[0]{'$attr'} if exists \$_[0]{'$attr'};\n";

            # Return default value
            $code .= "    return \$_[0]{'$attr'} = ";
            $code .=
              ref $default eq 'CODE' ? '$default->($_[0]);' : '$default;';
        }

        # Store value
        $code .= "\n  }\n  \$_[0]{'$attr'} = \$_[1];\n";

        # Footer (return invocant)
        $code .= "  \$_[0];\n}";

        # We compile custom attribute code for speed
        no strict 'refs';
        warn "-- Attribute $attr in $class\n$code\n\n" if $ENV{MOJO_BASE_DEBUG};
        Carp::croak("Mojo::Base error: $@") unless eval "$code;1";
    }
}

sub tap {
    my ( $self, $cb ) = @_;
    $_->$cb for $self;
    return $self;
}

1;
__END__

=pod

=head1 NAME

Peader::Base - Minimal base class for Peader classes,use it import 5.12 features
and import some modules you needed.

=head1 SYNOPSIS

    use Peader::Base;

    say "hello world"; # don't feel suprise,it works!

=head1 DESCRIPTION

=cut

