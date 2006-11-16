# vi:fdm=marker fdl=0 syntax=perl:
# $Id: 07_BF2.t,v 1.5 2006/11/14 12:12:54 jettero Exp $

use strict;
use Test;

plan tests => 1; ok(1); exit 0;

plan tests => 50;

use Crypt::PBC;

open IN, "params.txt" or die "couldn't open params: $!";
my $curve = &Crypt::PBC::pairing_init_stream(\*IN); close IN;

for ( 1 .. 50 ) {
    my $GT_a  = $curve->new_GT->random;
    my $GT_b  = $curve->new_GT->square( $GT_a );

    ok( $GT_a->is_sqr );
}
