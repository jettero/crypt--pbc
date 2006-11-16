# vi:fdm=marker fdl=0 syntax=perl:
# $Id: 07_BF2.t,v 1.5 2006/11/14 12:12:54 jettero Exp $

use strict;
use Test;

my $epochs = 50;

plan tests => $epochs * 2;

use Crypt::PBC;

open IN, "params.txt" or die "couldn't open params: $!";
my $curve = &Crypt::PBC::pairing_init_stream(\*IN); close IN;

for ( 1 .. $epochs ) {
    my $GT = $curve->new_GT->square;
    my $Zr = $curve->new_GT->square;

    ok( $GT->is_sqr );
    ok( $Zr->is_sqr );
}
