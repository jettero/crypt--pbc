
package Crypt::PBC::Element;

use strict;
use Carp;
use MIME::Base64;

our %tm;

1;

# DESTROY {{{
sub DESTROY {
    my $this = shift;
    
    delete $tm{$$this};

    &Crypt::PBC::element_clear( $this );
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

#### comparisons
## binary
# is_eq {{{
sub is_eq {
    my $this = shift;
    my $that = shift;

    croak "LHS and RHS should both have types" unless $tm{$$this} and $tm{$$that};

    return not &Crypt::PBC::element_cmp( $this, $that ); # returns 0 if they're the same
}
# }}}

## urinary
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

    &Crypt::PBC::element_pow_zn( $this, $base, $expo );

    $this;
}
# }}}

#### arith
## urinary
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

sub new_G1  { my $this = shift; my $that = &Crypt::PBC::element_init_G1( $this ); $Crypt::PBC::Element::tm{$$that} = "G1"; $that }
sub new_G2  { my $this = shift; my $that = &Crypt::PBC::element_init_G2( $this ); $Crypt::PBC::Element::tm{$$that} = "G2"; $that }
sub new_GT  { my $this = shift; my $that = &Crypt::PBC::element_init_GT( $this ); $Crypt::PBC::Element::tm{$$that} = "GT"; $that }
sub new_Zr  { my $this = shift; my $that = &Crypt::PBC::element_init_Zr( $this ); $Crypt::PBC::Element::tm{$$that} = "Zr"; $that }
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
our $VERSION = '0.3.17-0.5';

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

    # if( ref($arg) eq "GLOB" ) {
    #     $that = &Crypt::PBC::pairing_init_stream($arg);

    # } elsif( -f $arg ) {

        open PARAM_IN, $arg or croak "couldn't open param file ($arg): $!";
        $that = &Crypt::PBC::pairing_init_stream(\*PARAM_IN); close PARAM_IN;
        close PARAM_IN;

    # } elsif( $arg ) {
    #     $that = &Crypt::PBC::pairing_init_str($arg);

    # } else {
    #     croak "you must pass a file, glob (stream), or init params to new()";
    # }

    croak "something went wrong ... you must pass a file, glob (stream), or init params to new()" unless $$that>0;
    return $that;
}

# }}}

__END__

=head1 NAME

Crypt::PBC - OO interface for the Lynn's PBC library

=head1 SYNOPSIS

    use Crypt::PBC;

    my $pairing = new Crypt::PBC("params.txt");
    my $G1      = $pairing->init_G1->random;
    my $G2      = $pairing->init_G2->random->double->square;
    my $GT      = $pairing->init_GT->apply_pairing( $pairing => $G1, $G2 );

    # These methods return the LHS (left hand side of the assignment of an implicit equation).

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

=head1 SEE ALSO

http://crypto.stanford.edu/pbc/

http://groups.google.com/group/pbc-devel

perl(1)

=cut
