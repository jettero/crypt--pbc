# vi:fdm=marker fdl=0 syntax=perl:

use strict;
use Test;

use Crypt::PBC;
my $c = new Crypt::PBC("params.txt");
my $e = $c->new_G1;

plan tests => 1;
ok( 1 );
