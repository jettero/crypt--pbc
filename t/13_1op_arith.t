# vi:fdm=marker fdl=0 syntax=perl:

use strict;
use Test;

if( defined $ENV{SKIP_ALL_BUT} ) { unless( $0 =~ m/\Q$ENV{SKIP_ALL_BUT}\E/ ) { plan tests => 1; ok(1); exit 0; } }

use Crypt::PBC;

open IN, "params.txt" or die "couldn't open params: $!";
my $curve = &Crypt::PBC::pairing_init_stream(\*IN); close IN;

my @lhs = ( $curve->new_G1, $curve->new_G2, $curve->new_GT, $curve->new_Zr );
my @rhs = ( $curve->new_G1, $curve->new_G2, $curve->new_GT, $curve->new_Zr );

my $epochs = 1;

plan tests => ( ((int @lhs) * 10 * $epochs) );

for my $i ( 1 .. $epochs ) {
    for my $i ( 0 .. $#lhs ) {
        $lhs[$i]->random->square; ok(1);
        $lhs[$i]->random->double; ok(1);
        $lhs[$i]->random->halve;  ok(1);
        $lhs[$i]->random->neg;    ok(1);
        $lhs[$i]->random->invert; ok(1);

        $lhs[$i]->square( $rhs[$i]->random ); ok(1);
        $lhs[$i]->double( $rhs[$i]->random ); ok(1);
        $lhs[$i]->halve(  $rhs[$i]->random ); ok(1);
        $lhs[$i]->neg(    $rhs[$i]->random ); ok(1);
        $lhs[$i]->invert( $rhs[$i]->random ); ok(1);
    }
}
