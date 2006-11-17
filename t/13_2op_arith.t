# vi:fdm=marker fdl=0 syntax=perl:

use strict;
use Test;

if( defined $ENV{SKIP_ALL_BUT} ) { unless( $0 =~ m/\Q$ENV{SKIP_ALL_BUT}\E/ ) { plan tests => 1; ok(1); exit 0; } }

use Crypt::PBC;

open IN, "params.txt" or die "couldn't open params: $!";
my $curve = &Crypt::PBC::pairing_init_stream(\*IN); close IN;

my @lhs = ( $curve->new_G1, $curve->new_G2, $curve->new_Zr, $curve->new_GT, );
my @rhs = ( $curve->new_G1, $curve->new_G2, $curve->new_Zr, $curve->new_GT, );

my $epochs = 5;

plan tests => ( ((int @lhs) * 8 * $epochs) );

for my $i ( 1 .. $epochs ) {
    for my $i ( 0 .. $#lhs ) {
        $lhs[$i]->add( $lhs[$i]->random, $rhs[$i]->random ); ok(1);
        $lhs[$i]->Sub( $lhs[$i]->random, $rhs[$i]->random ); ok(1);
        $lhs[$i]->mul( $lhs[$i]->random, $rhs[$i]->random ); ok(1);
        $lhs[$i]->div( $lhs[$i]->random, $rhs[$i]->random ); ok(1);

        $lhs[$i]->random->add( $rhs[$i]->random ); ok(1);
        $lhs[$i]->random->Sub( $rhs[$i]->random ); ok(1);
        $lhs[$i]->random->mul( $rhs[$i]->random ); ok(1);
        $lhs[$i]->random->div( $rhs[$i]->random ); ok(1);
    }
}
