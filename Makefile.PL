use strict;
use lib qw(inc);
use Devel::CheckLib;
use ExtUtils::MakeMaker;

check_lib_or_exit( lib => [qw(pbc)], header => "pbc/pbc.h" );

WriteMakefile(
    NAME              => 'Crypt::PBC',
    VERSION_FROM      => 'PBC.pm',
    PREREQ_PM         => { 
        'MIME::Base64' => 0, 'Math::BigInt::GMP' => 0, 'Math::BigInt' => 0,
        version=>0.75,
    },

    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/Crypt/PBC.pod',
       AUTHOR         => 'Paul Miller <jettero@cpan.org>') : ()),

    LIBS => ['-lpbc'],
    clean => { FILES => ".pbctest slamtest.log " . join(" ", grep {s/\.c$//} <*.c>) },
    depend => {
        "PBC.c" => " earith.xs ecomp.xs einit.xs pairing.xs ",
    },

);
