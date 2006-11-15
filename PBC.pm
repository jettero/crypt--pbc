# $Id: PBC.pm,v 1.21 2006/11/14 12:15:56 jettero Exp $

package Crypt::PBC::Pairing;

use strict;

our %tm = ();

1;

sub new_G1  { my $this = shift; my $that = &Crypt::PBC::element_init_G1( $this ); $tm{$$that} = "G1"; $that }
sub new_G2  { my $this = shift; my $that = &Crypt::PBC::element_init_G2( $this ); $tm{$$that} = "G2"; $that }
sub new_GT  { my $this = shift; my $that = &Crypt::PBC::element_init_GT( $this ); $tm{$$that} = "GT"; $that }
sub new_Zr  { my $this = shift; my $that = &Crypt::PBC::element_init_Zr( $this ); $tm{$$that} = "Zr"; $that }
sub DESTROY { my $this = shift; my $that = &Crypt::PBC::pairing_clear(   $this ); 1; }

package Crypt::PBC::Element;

use strict;
use Carp;
use MIME::Base64;

1;

sub DESTROY  { my $this = shift; delete $tm{$$this}; &Crypt::PBC::element_clear( $this ); }

sub as_bytes  { my $this = shift; &Crypt::PBC::export_element( $this ); } # this returns bytes
sub as_str    { my $this = shift; unpack("H*", $this->as_bytes); }        # this returns hex
sub random    { my $this = shift; &Crypt::PBC::element_random( $this ); $this } # this is itself
sub as_base64 { my $this = shift; my $that = encode_base64($this->as_bytes); $that =~ s/\n$//sg; $that } # this returns base64

sub stddump { my $this = shift; &Crypt::PBC::element_fprintf(*STDOUT, '%B', $this ); }
sub errdump { my $this = shift; &Crypt::PBC::element_fprintf(*STDERR, '%B', $this ); }

sub from_hash {
    my $this = shift;
    my $hash = shift;

    &Crypt::PBC::element_from_hash($this, $hash);

    $this;
}

sub is_eq {
    my $this = shift;
    my $that = shift;

    croak "LHS and RHS should both have types" unless $tm{$$this} and $tm{$$that};

    return not &Crypt::PBC::element_cmp( $this, $that ); # returns 0 if they're the same
}

sub pow_zn {
    my $this = shift;
    my $base = shift;
    my $expo = shift;

    croak "LHS and BASE should be of the same group" unless $tm{$$this} and $tm{$$this} eq $tm{$$base};

    &Crypt::PBC::element_pow_zn( $this, $base, $expo );

    $this;
}

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
our $VERSION = '0.3.16';

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
