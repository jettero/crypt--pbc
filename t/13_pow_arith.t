# vi:fdm=marker fdl=0 syntax=perl:

use strict;
use Test;

if( defined $ENV{SKIP_ALL_BUT} ) { unless( $0 =~ m/\Q$ENV{SKIP_ALL_BUT}\E/ ) { plan tests => 1; ok(1); exit 0; } }

use Crypt::PBC;

my $curve = new Crypt::PBC('params.txt');

my $G1_a = $curve->new_G1; my $G1_b = $curve->new_G1; my $G1_c = $curve->new_G1; my $G1_d = $curve->new_G1;
my $Zr_a = $curve->new_Zr; my $Zr_b = $curve->new_Zr; my $Zr_c = $curve->new_Zr;

my $epochs = 5;

plan tests => $epochs * 1;

for ( 1 .. $epochs ) {
    # just looking for segfaults
    
    $G1_a->random; $G1_b->random; $G1_c->random; $G1_d->random; $Zr_a->random; $Zr_b->random; $Zr_c->random;

    my $mpz_a = $Zr_a->as_bigint;
    my $mpz_b = $Zr_a->as_bigint;
    my $mpz_c = $Zr_a->as_bigint;

    $G1_a->random->pow_zn(  $G1_b, $Zr_a );                             my $c_1 = $G1_a->clone( $curve );
    $G1_a->random->pow2_zn( $G1_b, $Zr_a, $G1_c, $Zr_b, $G1_d, $Zr_c ); my $c_2 = $G1_a->clone( $curve );
    $G1_a->random->pow3_zn( $G1_b, $Zr_a, $G1_c, $Zr_b, $G1_d, $Zr_c ); my $c_3 = $G1_a->clone( $curve );

    $G1_a->random->pow_bigint(  $G1_b, $Zr_a );                                ok( $G1_a->is_eq( $c_1 ) );
    $G1_a->random->pow2_bigint( $G1_b, $mpz_a, $G1_c, $mpz_b, $G1_d, $mpz_c ); ok( $G1_a->is_eq( $c_2 ) );
    $G1_a->random->pow3_bigint( $G1_b, $mpz_a, $G1_c, $mpz_b, $G1_d, $mpz_c ); ok( $G1_a->is_eq( $c_3 ) );
}
