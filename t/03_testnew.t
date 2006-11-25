# vi:fdm=marker fdl=0 syntax=perl:

use strict;
use Test;

plan tests => 5;

use Crypt::PBC;

my $global_c;
my $global_e;

FILE: {
    my $c = new Crypt::PBC("params.txt");
    my $e = $c->init_G1->set_to_hash( "lol!" );

    $global_e = $e;
    $global_c = $c; # this shouldn't be necessary -- trying to concoct a smaller example

    ok( 1 );
}

GLOB: {
    open IN, "params.txt" or die "lol: $!";
    my $c = new Crypt::PBC(\*IN); close IN;
    my $e = $c->init_G1->set_to_hash( "lol!" );

    ok( 1 );
    ok( $e->is_eq( $global_e ) )
}

STRING: {
    my $settings = q(type d
q 90144054120102937439179516551801119443207521965651508326977
n 90144054120102937439179516552101359437412329625948146453801
h 3523
r 25587298927080027658012919827448583433838299638361665187
a 53241464724463691897001131065853762954208272388634868483573
b 5446291776274815451607581859968802155069674270539409546723
k 6
nk 536565217356706344663314419655601558604376922027564701618757289270614360593294739461568130362279778081437146273088457636627768012396592169059882662689261645948113285006858612654825829457395553891546397990662355454563776046265747800873542312230073566643975827908869710713161941935371830987701273239900997531501272405727670675418703842862606824000125008640
hk 819546557806423450339849940898193664969813698879192227897917671302330185914203886301113045602626676261586588840857293388779160133822229389038218318388504449595493650939257095992443062327856033482709266319687677297858891026083277228064475554560
coeff0 43907136006531280293838495445857758305366399383908394927288
coeff1 21720089592072695009765372832780685887129370300993349347738
coeff2 11773373318911376280677890769414834592007872486079550520860
nqr 4468071665857441743453009416233415235254714637554162977327);
    my $c = new Crypt::PBC($settings);
    my $e = $c->init_G1->set_to_hash( "lol!" );

    ok( 1 );
    ok( $e->is_eq( $global_e ) )
}
