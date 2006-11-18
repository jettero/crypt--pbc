# vi:fdm=marker fdl=0 syntax=perl:

use strict;
use Test;

if( defined $ENV{SKIP_ALL_BUT} ) { unless( $0 =~ m/\Q$ENV{SKIP_ALL_BUT}\E/ ) { plan tests => 1; ok(1); exit 0; } }

use Crypt::PBC;

plan tests => 3;

my $curve = new Crypt::PBC("params.txt");

TRIVIAL: {
    my $Zr1 = $curve->new_Zr->set_to_int( 53 );
    my $Zr2 = $curve->new_Zr->set_to_int( 59 );

    my $mpz1 = $Zr1->as_bigint;
    my $mpz2 = $Zr2->as_bigint;

    ok( "$mpz1", 53 );
    ok( "$mpz2", 59 );
}

NONTRIVIAL: {
    my $Zr1 = $curve->new_Zr->set_to_int( 53 );
    my $Zr2 = $curve->new_Zr->set_to_bigint( $Zr1->as_bigint );

    ok( $Zr1->is_eq( $Zr2 ) );
}
