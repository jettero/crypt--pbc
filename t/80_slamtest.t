
use strict;
use Test;
use Carp;
use Crypt::PBC;

if( defined $ENV{SKIP_ALL_BUT} ) { unless( $0 =~ m/\Q$ENV{SKIP_ALL_BUT}\E/ ) { plan tests => 1; skip(1); exit 0; } }

my $curve = new Crypt::PBC("params.txt");
my @e = ( $curve->init_G1, $curve->init_G2, $curve->init_GT, $curve->init_Zr, undef, 7, new Math::BigInt(19) );
my @i = ( 0 .. $#e ); # the indicies for permute()

if( -f "slamtest.log" ) {
    unlink "slamtest.log" or die "couldn't remove old logfile: $!";
}

my %slam_these = (
    pairing_apply => 2,

    random => 1, # technically this should be 0, but this test is not set up for no-args
    square => 1, # technically this should be 0, but this test is not set up for no-args
    double => 1, # technically this should be 0, but this test is not set up for no-args
    halve  => 1, # technically this should be 0, but this test is not set up for no-args
    neg    => 1, # technically this should be 0, but this test is not set up for no-args
    invert => 1, # technically this should be 0, but this test is not set up for no-args

    add => 2,
    Sub => 2,
    mul => 2,
    div => 2,

    mul_zn     => 2,
    mul_int    => 2,
    mul_bigint => 2,

    pow_zn  => 3,
    pow2_zn => 4,
    pow3_zn => 6,

    pow_bigint  => 3,
    pow2_bigint => 4,
    pow3_bigint => 6,
);

my $skip = 0;
if( not defined $ENV{REALLY_DO_THIS} ) {
    $skip = &count_tests;
    %slam_these = ( random => 1, pairing_apply => 2 );
}

#### This test may need some explaining... We wish to pass all
#### possible all the wrong things and make sure we catch all the
#### potential sagfaults with perl croak() errors.

my $count = &count_tests;
if( $skip ) {
    $skip = $skip - $count;
    warn " WARNING: skipping $skip of the tests.\n\tTo test them all: SKIP_ALL_BUT=$0 REALLY_DO_THIS=1 make test\n";
    sleep 1;
}

plan tests => $count;

my %huge_cache = ();

for my $function (sort slam_sort keys %slam_these) {
    my @a = &permute( $slam_these{$function} => @i );

    for my $a (@a) {
        my $key = "@$a";
        my $args = $huge_cache{$key};
           $args = [map { ( ref $e[$_] and $e[$_]->isa("Crypt::PBC::Element") ? $e[$_]->clone->random : $e[$_]) } @$a]
               if not defined $args;
        $huge_cache{$key} = $args;

        for my $e (@e) {
            next unless ref $e and $e->isa("Crypt::PBC::Element");
            eval '$e->random->' . $function . '(@$args)';

            # We are just looking for segmentation faults for now
            # so we ignore most $@ entirely.

            if( $@ and not $@ =~ m/(?:SCALAR ref|same group|int.provided.*accept|is not a bigint|must be.*(?:G1|G2|GT|Zr))/ ) {
                open OUTPUT, ">>slamtest.log" or die $!;
                warn " [logged] \$@=$@";
                print OUTPUT " function=$function; \$@=$@";
                close OUTPUT;
            }
        }
    }

    ok( 1 );
}

# _permute {{{
sub _permute {
    my $num = shift;
    my $arr = shift;
    my $src = shift;

    unshift @$_, $src->[0] for @$arr;

    my $e = $#{ $arr };
    for my $i (1 .. $#$src) {
        for my $j (0 .. $e) {
            my $t = [@{ $arr->[$j] }];
            
            $t->[0] = $i;

            push @$arr, $t;
        }
    }

    &_permute( $num-1, $arr, $src ) if $num > 1;
}
# }}}
# permute {{{
sub permute {
    my $anum = shift; croak "dumb number" unless $anum > 0;
    my @ret = ();

    for my $num ( 1 .. $anum ) {
        my @a = map {[$_]} @_;

        &_permute( $num-1, \@a, \@_ ) if $num > 1;

        push @ret, @a;
    }

    return @ret;
}
# }}}
# slam_sort {{{
sub slam_sort {
    my ($c, $d) = ($slam_these{$a}, $slam_these{$b});

    return $c <=> $d if $c != $d;
    return $a cmp $b;
}
# }}}
# count_tests {{{
sub count_tests {
    my $count = 0;
    my $bases = ( int (grep {ref $_ and $_->isa("Crypt::PBC::Element")} @e) );
    for my $v (values %slam_these) {
        for ( 1 .. $v ) {
            $count += (int @e) ** $_;
        }
    }

    return $count * 1 * $bases;
}
# }}}
