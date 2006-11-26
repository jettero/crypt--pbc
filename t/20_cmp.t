# vi:fdm=marker fdl=0 syntax=perl:

use strict;
use Test;

$ENV{SKIP_ALL_BUT} = "";
if( defined $ENV{SKIP_ALL_BUT} ) { unless( $0 =~ m/\Q$ENV{SKIP_ALL_BUT}\E/ ) { plan tests => 1; ok(1); exit 0; } }

use Crypt::PBC;

plan tests => 4;

my $c = new Crypt::PBC("params.txt");

my $e0  = $c->init_G1->set_to_int( 0 );
my $e1  = $c->init_G1->set_to_int( 1 );
my $eq  = $c->init_G1->set_to_int( 25 );
my $el1 = $c->init_G1->set_to_hash( "lol!" );
my $el2 = $c->init_G1->set_to_hash( "lol!" );

ok( $el1->is_eq( $el2 ) );
ok( $e0->is_0 );
ok( $e1->is_1 );

warn " why does this sagfault? ";
ok( $eq->is_sqr );
warn " (you don't see this do you?) ";
