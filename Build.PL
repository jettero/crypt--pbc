use strict;
use lib qw(inc);
use Devel::CheckLib;

check_lib_or_exit( lib => [qw(pbc)], header => "pbc/pbc.h" );

use Module::Build;
my $build = Module::Build->new(
    module_name       => 'Crypt::PBC',
    dist_version_from => "PBC.pm",
    license           => 'lgpl',
     pm_files         => { 'PBC.pm'  => 'lib/Crypt/PBC.pm'  },
    pod_files         => { 'PBC.pod' => 'lib/Crypt/PBC.pod' },
     xs_files         => { 'PBC.xs'  => 'lib/Crypt/PBC.xs'  },
    build_requires    => {
        'ExtUtils::CBuilder' => 0, 
    },
    requires          => {
        'MIME::Base64' => 0, 'Math::BigInt::GMP' => 0, 'Math::BigInt' => 0, version=>0.75,
    },
    extra_linker_flags   => '-lpbc',
    add_to_cleanup => [qw(.pbctest slamtest.log), join(" ", grep {s/\.c$//} <*.c>)],
);
$build->create_build_script;

