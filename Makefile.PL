
use ExtUtils::MakeMaker;

my $CFLAGS = "-I/usr/include/pbc";
my $LFLAGS = "-lpbc";
my $debug  = 0; # set to true for debug mode (you can't turn it off without a rebuild)

system(qw(gcc -o .pbctest pbctest.c), $CFLAGS, $LFLAGS) == 0
    or die "You need libpbc installed in order to build this.  If you
    have it, but it's not where this build script expects it, let me
    know and together we can improve this build processess.\n\n-Paul\n";

WriteMakefile(
    NAME              => 'Crypt::PBC',
    VERSION_FROM      => 'PBC.pm',
    PREREQ_PM         => { 
        'MIME::Base64' => 0, 'Math::BigInt::GMP' => 0, 'Math::BigInt' => 0,
    },

    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/Crypt/PBC.pod',
       AUTHOR         => 'Paul Miller <jettero@cpan.org>') : ()),

    LIBS              => [$LFLAGS],
    DEFINE            => ($debug ? '-DPBC_DEBUG' : ""),
    INC               => $CFLAGS,
    clean => { FILES => ".pbctest slamtest.log " . join(" ", grep {s/\.c$//} <*.c>) },
    depend => {
        "PBC.c" => " earith.xs ecomp.xs einit.xs pairing.xs ",
    },

);
