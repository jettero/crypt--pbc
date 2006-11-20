
package Crypt::PBC::Element;

use strict;
use Carp;
use MIME::Base64;
use Math::BigInt lib => 'GMP';

our %tm;

1;

# DESTROY {{{
sub DESTROY {
    my $this = shift;
    
    delete $tm{$$this};

    &Crypt::PBC::element_clear( $this );
}
# }}}
# clone {{{
sub clone {
    my $this  = shift;
    my $pair = shift; croak "failed to pass pairing to clone()" unless ref $pair and $pair->isa("Crypt::PBC::Pairing");
    my $type  = $tm{$$this};

    my $that = eval "\$pair->init_$type";
    if( $@ ) {
        # Can't call method "init_G1" on an undefined value at (eval 2) line 1.
        # at t/13_pow_arith.t line 28
        chomp $@; $@ =~ s/at \(eval \d+\) line \d+/during Crypt::PBC::Element::clone()/;
        croak $@;
    }

    return $that->set( $this );
}
# }}}

#### exporters
# as_bytes {{{
sub as_bytes {
    my $this = shift;
    
    return &Crypt::PBC::export_element( $this );
}
# }}}
# as_str {{{
sub as_str {
    my $this = shift;
    
    return unpack("H*", $this->as_bytes);
}
# }}}
# as_base64 {{{
sub as_base64 {
    my $this = shift;
    
    my $that = encode_base64($this->as_bytes);
    $that =~ s/\n$//sg;

    return $that;
}
# }}}
# as_bigint {{{
sub as_bigint {
    my $this = shift;
    my $that = &Crypt::PBC::element_to_mpz($this);

    my $int = new Math::BigInt;
       $int->{value} = $that;
       $int->{sign}  = '+';

     # I wanted to do something like thits, but I think
     # the mpz_t's returned from element_to_mpz are always going to be positive...
     # $int->{sign}  = $this->is_neg ? "-" : "+"; 

    return $int;
}
# }}}
# stddump {{{
sub stddump {
    my $this = shift;
    
    &Crypt::PBC::element_fprintf(*STDOUT, '%B', $this );
}
# }}}
# errdump {{{
sub errdump {
    my $this = shift;
    
    return &Crypt::PBC::element_fprintf(*STDERR, '%B', $this );
}
# }}}

#### initializers and set routines
# random {{{
sub random {
    my $this = shift;
    
    &Crypt::PBC::element_random( $this );

    return $this;
}
# }}}
# set_to_hash {{{
sub set_to_hash {
    my $this = shift;
    my $hash = shift;

    &Crypt::PBC::element_from_hash($this, $hash);

    $this;
}
# }}}
# set_to_int {{{
sub set_to_int {
    my $this = shift;
    my $int  = shift;

    croak "int provided ($int) is not acceptable" unless $int =~ m/^\-?[0-9]+$/s;

    &Crypt::PBC::element_set_si($this, $int);

    $this;
}
# }}}
# set_to_bigint {{{
sub set_to_bigint {
    my $this = shift;
    my $int  = shift;

    croak "int provided is not a bigint" unless ref $int and $int->isa("Math::BigInt");

    &Crypt::PBC::element_set_mpz($this, $int->{value});

    $this;
}
# }}}
# set {{{
sub set {
    my $this = shift;
    my $that = shift;

    croak "LHS and RHS should be the same" unless $tm{$$this} eq $tm{$$that};

    &Crypt::PBC::element_set($this, $that);

    $this;
}
# }}}

#### comparisons
# is_eq {{{
sub is_eq {
    my $this = shift;
    my $that = shift;

    croak "LHS and RHS should both have types" unless $tm{$$this} and $tm{$$that};

    return not &Crypt::PBC::element_cmp( $this, $that ); # returns 0 if they're the same
}
# }}}
# is_sqr {{{
sub is_sqr {
    my $this = shift;

    return not &Crypt::PBC::element_is_sqr( $this ); # Returns 0 if a is a perfect square (quadratic residue), nonzero otherwise.
}
# }}}

#### exponentiation
# pow_zn {{{
sub pow_zn {
    my $this = shift;
    my $base = shift;
    my $expo = shift;

    croak "LHS and BASE should be of the same group" unless $tm{$$this} and $tm{$$this} eq $tm{$$base};
    croak "EXPO must be of type Zr"                  unless $tm{$$expo} eq "Zr";

    &Crypt::PBC::element_pow_zn( $this, $base, $expo );

    $this;
}
# }}}
# pow2_zn {{{
sub pow2_zn {
    my $this = shift;
    my $a1 = shift;
    my $n1 = shift;
    my $a2 = shift;
    my $n2 = shift;

    croak "LHS and a1 should be of the same group" unless $tm{$$this} and $tm{$$this} eq $tm{$$a1};
    croak "LHS and a2 should be of the same group" unless $tm{$$this} eq $tm{$$a2};
    croak "n1 must be of type Zr"                  unless $tm{$$n1} eq "Zr";
    croak "n2 must be of type Zr"                  unless $tm{$$n2} eq "Zr";

    &Crypt::PBC::element_pow2_zn( $this, $a1, $n1, $a2, $n2 );

    $this;
}
# }}}
# pow3_zn {{{
sub pow3_zn {
    my $this = shift;
    my $a1 = shift;
    my $n1 = shift;
    my $a2 = shift;
    my $n2 = shift;
    my $a3 = shift;
    my $n3 = shift;

    croak "LHS and a1 should be of the same group" unless $tm{$$this} and $tm{$$this} eq $tm{$$a1};
    croak "LHS and a2 should be of the same group" unless $tm{$$this} eq $tm{$$a2};
    croak "LHS and a3 should be of the same group" unless $tm{$$this} eq $tm{$$a3};
    croak "n1 must be of type Zr"                  unless $tm{$$n1} eq "Zr";
    croak "n2 must be of type Zr"                  unless $tm{$$n2} eq "Zr";
    croak "n3 must be of type Zr"                  unless $tm{$$n3} eq "Zr";

    &Crypt::PBC::element_pow3_zn( $this, $a1, $n1, $a2, $n2, $a3, $n3 );

    $this;
}
# }}}

# pow_bigint {{{
sub pow_bigint {
    my $this = shift;
    my $base = shift;
    my $expo = shift;

    croak "EXPO provided is not a bigint" unless ref $expo and $expo->isa("Math::BigInt");
    croak "LHS and BASE should be of the same group" unless $tm{$$this} and $tm{$$this} eq $tm{$$base};

    &Crypt::PBC::element_pow_mpz( $this, $base, $expo->{value} );

    $this;
}
# }}}
# pow2_bigint {{{
sub pow2_bigint {
    my $this = shift;
    my $a1 = shift;
    my $n1 = shift;
    my $a2 = shift;
    my $n2 = shift;

    croak "n1 provided is not a bigint" unless ref $n1 and $n1->isa("Math::BigInt");
    croak "n2 provided is not a bigint" unless ref $n2 and $n2->isa("Math::BigInt");
    croak "LHS and a1 should be of the same group" unless $tm{$$this} and $tm{$$this} eq $tm{$$a1};
    croak "LHS and a2 should be of the same group" unless $tm{$$this} eq $tm{$$a2};

    &Crypt::PBC::element_pow2_mpz( $this, $a1, $n1->{value}, $a2, $n2->{value} );

    $this;
}
# }}}
# pow3_bigint {{{
sub pow3_bigint {
    my $this = shift;
    my $a1 = shift;
    my $n1 = shift;
    my $a2 = shift;
    my $n2 = shift;
    my $a3 = shift;
    my $n3 = shift;

    croak "n1 provided is not a bigint" unless ref $n1 and $n1->isa("Math::BigInt");
    croak "n2 provided is not a bigint" unless ref $n2 and $n2->isa("Math::BigInt");
    croak "n3 provided is not a bigint" unless ref $n3 and $n2->isa("Math::BigInt");

    croak "LHS and a1 should be of the same group" unless $tm{$$this} and $tm{$$this} eq $tm{$$a1};
    croak "LHS and a2 should be of the same group" unless $tm{$$this} eq $tm{$$a2};
    croak "LHS and a3 should be of the same group" unless $tm{$$this} eq $tm{$$a3};

    &Crypt::PBC::element_pow3_mpz( $this, $a1, $n1->{value}, $a2, $n2->{value}, $a3, $n3->{value} );

    $this;
}
# }}}

#### arith
## 1op
# square {{{
sub square {
    my $lhs  = shift;
    my $rhs  = shift;

    if( $rhs ) {
        croak "LHS and RHS should be of the same group" unless $tm{$$lhs} and $tm{$$lhs} eq $tm{$$rhs};

    } else {
        $rhs = $lhs;
    }

    &Crypt::PBC::element_square( $lhs, $rhs );

    $lhs;
}
# }}}
# double {{{
sub double {
    my $lhs  = shift;
    my $rhs  = shift;

    if( $rhs ) {
        croak "LHS and RHS should be of the same group" unless $tm{$$lhs} and $tm{$$lhs} eq $tm{$$rhs};

    } else {
        $rhs = $lhs;
    }

    &Crypt::PBC::element_double( $lhs, $rhs );

    $lhs;
}
# }}}
# halve {{{
sub halve {
    my $lhs  = shift;
    my $rhs  = shift;

    if( $rhs ) {
        croak "LHS and RHS should be of the same group" unless $tm{$$lhs} and $tm{$$lhs} eq $tm{$$rhs};

    } else {
        $rhs = $lhs;
    }

    &Crypt::PBC::element_halve( $lhs, $rhs );

    $lhs;
}
# }}}
# neg {{{
sub neg {
    my $lhs  = shift;
    my $rhs  = shift;

    if( $rhs ) {
        croak "LHS and RHS should be of the same group" unless $tm{$$lhs} and $tm{$$lhs} eq $tm{$$rhs};

    } else {
        $rhs = $lhs;
    }

    &Crypt::PBC::element_neg( $lhs, $rhs );

    $lhs;
}
# }}}
# invert {{{
sub invert {
    my $lhs  = shift;
    my $rhs  = shift;

    if( $rhs ) {
        croak "LHS and RHS should be of the same group" unless $tm{$$lhs} and $tm{$$lhs} eq $tm{$$rhs};

    } else {
        $rhs = $lhs;
    }

    &Crypt::PBC::element_invert( $lhs, $rhs );

    $lhs;
}
# }}}

## 2op
# add {{{
sub add {
    my $lhs  = shift;
    my $rhs1 = shift;
    my $rhs2 = shift;

    if( $rhs2 ) {
        croak "LHS, RHS1 and RHS2 should be of the same group" 
        unless $tm{$$lhs} and $tm{$$lhs} eq $tm{$$rhs1} and $tm{$$rhs1} eq $tm{$$rhs2};

        &Crypt::PBC::element_add( $lhs, $rhs1, $rhs2 );

    } else {
        croak "LHS and RHS hould be of the same group" 
        unless $tm{$$lhs} and $tm{$$lhs} eq $tm{$$rhs1};

        &Crypt::PBC::element_add( $lhs, $lhs, $rhs1 );
    }

    $lhs;
}
# }}}
# Sub {{{
sub Sub {
    my $lhs  = shift;
    my $rhs1 = shift;
    my $rhs2 = shift;

    if( $rhs2 ) {
        croak "LHS, RHS1 and RHS2 should be of the same group" 
        unless $tm{$$lhs} and $tm{$$lhs} eq $tm{$$rhs1} and $tm{$$rhs1} eq $tm{$$rhs2};

        &Crypt::PBC::element_sub( $lhs, $rhs1, $rhs2 );

    } else {
        croak "LHS and RHS hould be of the same group" 
        unless $tm{$$lhs} and $tm{$$lhs} eq $tm{$$rhs1};

        &Crypt::PBC::element_sub( $lhs, $lhs, $rhs1 );
    }

    $lhs;
}
# }}}
# mul {{{
sub mul {
    my $lhs  = shift;
    my $rhs1 = shift;
    my $rhs2 = shift;

    if( $rhs2 ) {
        croak "LHS, RHS1 and RHS2 should be of the same group" 
        unless $tm{$$lhs} and $tm{$$lhs} eq $tm{$$rhs1} and $tm{$$rhs1} eq $tm{$$rhs2};

        &Crypt::PBC::element_mul( $lhs, $rhs1, $rhs2 );

    } else {
        croak "LHS and RHS hould be of the same group" 
        unless $tm{$$lhs} and $tm{$$lhs} eq $tm{$$rhs1};

        &Crypt::PBC::element_mul( $lhs, $lhs, $rhs1 );
    }

    $lhs;
}
# }}}
# div {{{
sub div {
    my $lhs  = shift;
    my $rhs1 = shift;
    my $rhs2 = shift;

    if( $rhs2 ) {
        croak "LHS, RHS1 and RHS2 should be of the same group" 
        unless $tm{$$lhs} and $tm{$$lhs} eq $tm{$$rhs1} and $tm{$$rhs1} eq $tm{$$rhs2};

        &Crypt::PBC::element_div( $lhs, $rhs1, $rhs2 );

    } else {
        croak "LHS and RHS hould be of the same group" 
        unless $tm{$$lhs} and $tm{$$lhs} eq $tm{$$rhs1};

        &Crypt::PBC::element_div( $lhs, $lhs, $rhs1 );
    }

    $lhs;
}
# }}}

# pairing_apply {{{
sub pairing_apply {
    my $this    = shift;
    my $pairing = shift;
    my $rhs1    = shift;
    my $rhs2    = shift;

    croak "pairing isn't a pairing" unless (ref $pairing) =~ m/Pairing/;
    croak "group type for LHS must be GT"  unless $tm{$$this} eq "GT";
    croak "group type for RHS1 must be G1" unless $tm{$$rhs1} eq "G1";
    croak "group type for RHS2 must be G2" unless $tm{$$rhs2} eq "G2";

    &Crypt::PBC::pairing_apply( $this => ($rhs1, $rhs2) => $pairing );

    $this;
}
*ehat  = *pairing_apply;
*e_hat = *pairing_apply;
# }}}

#### package Crypt::PBC::Pairing {{{

package Crypt::PBC::Pairing;

use strict;
use Carp;

1;

sub init_G1 { my $this = shift; my $that = &Crypt::PBC::element_init_G1( $this ); $Crypt::PBC::Element::tm{$$that} = "G1"; $that }
sub init_G2 { my $this = shift; my $that = &Crypt::PBC::element_init_G2( $this ); $Crypt::PBC::Element::tm{$$that} = "G2"; $that }
sub init_GT { my $this = shift; my $that = &Crypt::PBC::element_init_GT( $this ); $Crypt::PBC::Element::tm{$$that} = "GT"; $that }
sub init_Zr { my $this = shift; my $that = &Crypt::PBC::element_init_Zr( $this ); $Crypt::PBC::Element::tm{$$that} = "Zr"; $that }
sub DESTROY { my $this = shift; my $that = &Crypt::PBC::pairing_clear(   $this ); 1; }

# }}}
#### package Crypt::PBC {{{

package Crypt::PBC;

use strict;
use warnings;
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw( ) ] ); 
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw( );
our $VERSION = '0.3.17-0.5.01';

sub AUTOLOAD {
    my $constname;
    our $AUTOLOAD; ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&Crypt::PBC::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if( $error ) { croak $error }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('Crypt::PBC', $VERSION);

1;

sub new {
    my $class = shift;
    my $that;
    my $arg = shift; 

    if( ref($arg) eq "GLOB" ) {
        $that = &Crypt::PBC::pairing_init_stream($arg);

    } elsif( $arg !~ m/\n/ and -f $arg ) {

        open PARAM_IN, $arg or croak "couldn't open param file ($arg): $!";
        $that = &Crypt::PBC::pairing_init_stream(\*PARAM_IN); close PARAM_IN;
        close PARAM_IN;

    } elsif( $arg ) {
        $arg =~ s/^\s*//s;
        $arg =~ s/\s*$//s;

        if( $arg =~ m/^(?s:type\s+[a-z]+\s*|[a-z0-9]+\s+[0-9]+\s*)+$/s ) {
            $that = &Crypt::PBC::pairing_init_str($arg);

        } else {
            croak "either the filename doesn't exist or that param string is unparsable: $arg";
        }

    } else {
        croak "you must pass a file, glob (stream), or init params to new()";
    }

    croak "something went wrong ... you must pass a file, glob (stream), or init params to new()" unless $$that>0;
    return $that;
}

# }}}

__END__

=head1 NAME

Crypt::PBC - OO interface for Lynn's PBC library @ Standford

=head1 SYNOPSIS

    use Crypt::PBC;

    my $pairing = new Crypt::PBC("params.txt");
    my $G1      = $pairing->init_G1->random;
    my $G2      = $pairing->init_G2->random->double->square;
    my $GT      = $pairing->init_GT->apply_pairing( $pairing => $G1, $G2 );

=head1 Nomenclature

The documentation (and error messages) for these modules frequently refer
to the LHS, the RHS, EXPO, and BASE.  They are the left hand side, right
hand side, exponent and base.  In an algebraic equation: LHS=RHS and
LHS=BASE^EXPO.  In other words, the LHS is the element to which a value is
being assigned.  There may sometimes be more than one RHS, or it might be
called the a1 or n1; but, there will only be one LHS.

=head1 PM Methods

The PM methods implement an OO interface that the author highly recommends
using.

=head2 new()

Returns a new PBC pairing object.  new() takes, as arguments, either the
name of a file, a file stream (e.g., new Crypt::PBC(\*STDIN)), or the
params for a curve as a string.  Ben Lynn provides a zip file of d-type
curves:

    MNT curve parameters for embedding degree 6 (which I call type D
    curves), for all D less than a million, and for subgroup sizes at least
    80 bits and less than 300 bits long. Generated using test programs
    bundled with PBC library.

http://crypto.stanford.edu/pbc/download.html

=head1 XS Loaded Functions

This section is basically a listing of the PBC functions as they are
imported.  You can use them directly if you're already comfortable with the
layout of PBC.  If you're starting from scratch and aren't much of a C
coder, you'll have an easier time using the PM methods because they
implement a little type-safety to protect perl coders from segfaults.

Mixing and matching direct calls with the PM methods is a sure way to run
into trouble, since the PM methods tag the PBC elements with a type...

=head2 Initializer functions

=head2 Exponentiation Functions

=head2 Other Arithmetic Functions

=head2 Comparison Functions

=head2 Misc

=head1 XS AUTHOR

Paul Miller <japh@voltar-confed.org>

Paul is using this software in his own projects...  If you find bugs, please
please please let him know. :) Actually, let him know if you find it handy at
all.  Half the fun of releasing this stuff is knowing that people use it.

Additionally, he is aware that the documentation sucks.  Should you email him
for help, he will most likely try to give it.

=head1 COPYRIGHT

GPL! (and/or whatever license the gnu regex engine is under)

Though, additionally, I will say that I'll be tickled if you were to include
this package in any commercial endeavor.  Also, any thoughts to the effect that
using this module will somehow make your commercial package GPL should be washed
away.

I hereby release you from any such silly conditions -- if possible while still
matching the license from gnu regex.

This package and any modifications you make to it must remain GPL.  Any programs
you (or your company) write shall remain yours (and under whatever copyright you
choose) even if you use this package's intended and/or exported interfaces in
them.

(again, if possible)

Lastly, having said all the above, there may be certain restrictions from
the PBC library itself that I cannot amend or take away!

=head1 SEE ALSO

http://crypto.stanford.edu/pbc/

http://groups.google.com/group/pbc-devel

perl(1)

=cut
