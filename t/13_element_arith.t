# vi:fdm=marker fdl=0 syntax=perl:

use strict;
use Test;

use Crypt::PBC;

open IN, "params.txt" or die "couldn't open params: $!";
my $curve = &Crypt::PBC::pairing_init_stream(\*IN); close IN;

my @elements = ( $curve->new_G1, $curve->new_G2, $curve->new_GT, $curve->new_Zr );

my $epochs = 10;

plan tests => (int @elements) * $epochs * 1;

for my $i ( 1 .. $epochs ) {
    for my $e ( @elements ) {
        $e->random->square; ok(1);
    }
}
