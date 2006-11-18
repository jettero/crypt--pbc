# vi:fdm=marker fdl=0 syntax=perl:

use strict;
use Test;

if( defined $ENV{SKIP_ALL_BUT} ) { unless( $0 =~ m/\Q$ENV{SKIP_ALL_BUT}\E/ ) { plan tests => 1; ok(1); exit 0; } }

use Crypt::PBC;

open IN, "params.txt" or die "couldn't open params: $!";
my $curve = &Crypt::PBC::pairing_init_stream(\*IN); close IN;

my @lhs = ( $curve->new_G1, $curve->new_G2, $curve->new_Zr, $curve->new_GT, );
my @rhs = ( $curve->new_G1, $curve->new_G2, $curve->new_Zr, $curve->new_GT, );
my @shl = ( $curve->new_G1, $curve->new_G2, $curve->new_Zr, $curve->new_GT, );

my $epochs = 3;

plan tests => ( ((int @lhs) * 4 * $epochs) );

for my $i ( 1 .. $epochs ) {
    for my $i ( 0 .. $#lhs ) {

        $rhs[$i]->random;
        $shl[$i]->random;

        $lhs[$i]->set( $shl[$i] )->add( $lhs[$i], $rhs[$i] );           my $ac = $lhs[$i]->clone( $curve );
        $lhs[$i]->set( $shl[$i] )->Sub( $lhs[$i], $rhs[$i] );           my $sc = $lhs[$i]->clone( $curve );
        $lhs[$i]->set( $shl[$i] ); $lhs[$i]->mul( $lhs[$i], $rhs[$i] ); my $mc = $lhs[$i]->clone( $curve );
        $lhs[$i]->set( $shl[$i] ); $lhs[$i]->div( $lhs[$i], $rhs[$i] ); my $dc = $lhs[$i]->clone( $curve );

        $lhs[$i]->set( $shl[$i] )->add( $rhs[$i] ); ok( $lhs[$i]->is_eq( $ac ) );
        $lhs[$i]->set( $shl[$i] )->Sub( $rhs[$i] ); ok( $lhs[$i]->is_eq( $sc ) );
        $lhs[$i]->set( $shl[$i] )->mul( $rhs[$i] ); ok( $lhs[$i]->is_eq( $mc ) );
        $lhs[$i]->set( $shl[$i] )->div( $rhs[$i] ); ok( $lhs[$i]->is_eq( $dc ) );
    }
}
