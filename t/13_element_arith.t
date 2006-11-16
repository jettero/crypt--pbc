# vi:fdm=marker fdl=0 syntax=perl:

use strict;
use Test;

use Crypt::PBC;

open IN, "params.txt" or die "couldn't open params: $!";
my $curve = &Crypt::PBC::pairing_init_stream(\*IN); close IN;

my @urinary = ( $curve->new_G1, $curve->new_G2, $curve->new_GT, $curve->new_Zr );

my $epochs = 5;

plan tests => ( ((int @urinary) * 5 * $epochs) );

for my $i ( 1 .. $epochs ) {
    for my $e ( @urinary ) {
        $e->random->square; ok(1); # 1
        $e->random->double; ok(1); # 2
        $e->random->halve;  ok(1); # 3
        $e->random->neg;    ok(1); # 4
        $e->random->invert; ok(1); # 5
    }
}
