# vi:fdm=marker fdl=0 syntax=perl:

use strict;
use Test;

use Crypt::PBC;

open IN, "params.txt" or die "couldn't open params: $!";
my $curve = &Crypt::PBC::pairing_init_stream(\*IN); close IN;

my @elemets = ( $curve->new_G1, $curve->new_G2, $curve->new_GT, $curve->new_Zr );

plan tests => 1;

for ( 1 .. $epochs ) {
    my $a = $curve->new_Zr->random->square; ok(1)
}
