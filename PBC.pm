# $Id: PBC.pm,v 1.9 2006/11/12 14:03:26 jettero Exp $

package Crypt::PBC::Pairing;

use strict;

1;

sub new_G1  { &Crypt::PBC::element_init_G1( shift ) }
sub new_G2  { &Crypt::PBC::element_init_G2( shift ) }
sub new_GT  { &Crypt::PBC::element_init_GT( shift ) }
sub new_Zr  { &Crypt::PBC::element_init_Zr( shift ) }
sub DESTROY { &Crypt::PBC::pairing_clear(   shift ) }

package Crypt::PBC::Element;

use strict;

1;

sub DESTROY { my $this = shift; &Crypt::PBC::element_clear(  $this ); } # this doesn't return
sub as_str  { my $this = shift; &Crypt::PBC::stringify_gmp(  $this ); } # this returns the string
sub random  { my $this = shift; &Crypt::PBC::element_random( $this ); $this } # this is itself

sub pow_zn {
    my $this = shift;
    my $base = shift;
    my $expo = shift;

    &Crypt::PBC::element_pow_zn( $this, $base, $expo );

    $this;
}

sub pairing_apply {
    my $this    = shift;
    my $pairing = shift;
    my $rhs1    = shift;
    my $rhs2    = shift;

    &Crypt::PBC::pairing_apply( $this => ($rhs1, $rhs2) => $pairing );

    $this;
}

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
our $VERSION = '0.07';

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

__END__

=head1 NAME

Crypt::PBC - OO interface for the Lynn's PBC library

=head1 SYNOPSIS

    use Crypt::PBC;

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
