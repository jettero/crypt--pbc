
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Crypt::PBC',
    VERSION_FROM      => 'PBC.pm',
    PREREQ_PM         => { 
        'MIME::Base64' => 0, 'Math::BigInt::GMP' => 0, 'Math::BigInt' => 0,
    },

    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/Crypt/PBC.pod',
       AUTHOR         => 'Paul Miller <jettero@cpan.org>') : ()),

    LIBS              => ['-lpbc '],
    DEFINE            => '',
    INC               => '-I/usr/include/pbc/',
    clean => { FILES => " slamtest.log " . join(" ", grep {s/\.c$//} <*.c>) },
    depend => {
        "PBC.c" => " earith.xs ecomp.xs einit.xs pairing.xs ",
    },

);
