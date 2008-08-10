use strict;
use lib qw(inc);
use Devel::CheckLib;
use ExtUtils::MakeMaker;

my $ver    = "0.4.18";
my @libs   = "-lpbc";
my $extlib = 0;

eval { assert_lib( lib => [qw(pbc)], header => "pbc/pbc.h" ); };
if( $@ ) {
    warn "Error locating libpbc: $@";
    local $| = 1;
    print "Would you like to download and build libpbc automatically? (y/N enter) ";
    my $res = <>;
    if( $res =~ m/y/i ) {
        exit 0 unless &grab_libpbc($ver);
        exit 0 unless &unpack_libpbc($ver);
        exit 0 unless &build_libpbc($ver);

    } else {
        exit 0;
    }
}

WriteMakefile(
    NAME              => 'Crypt::PBC',
    VERSION_FROM      => 'PBC.pm',
    PREREQ_PM         => { 
        'MIME::Base64'      => 0,
        'Math::BigInt::GMP' => 0,
        'Math::BigInt'      => 0,
    },

    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/Crypt/PBC.pod',
       AUTHOR         => 'Paul Miller <jettero@cpan.org>') : ()),

	($extlib ? (MYEXTLIB => 'libpbc/.libs/libpbc$(LIB_EXT)') :()),

    LIBS   => \@libs,
    clean  => { FILES => ".pbctest slamtest.log " . join(" ", grep {s/\.c$//} <*.c>) },
    depend => {
        "PBC.c" => " earith.xs ecomp.xs einit.xs pairing.xs ",
    },

);

sub build_libpbc {
    my $ver = shift;
    # @libs = ();
    $extlib = 1;

    # we don't literally build it, we add things to the makefile
    *MY::postamble = \&postamble;
}

sub postamble {
"
PBC\$(OBJ_EXT) : \$(MYEXTLIB)

\$(MYEXTLIB):
	cd pbc-$ver && ./configure && \$(MAKE) \$(PASTHRU)
";
}

sub unpack_libpbc {
    my $ver = shift;
    return 1 if -d "pbc-$ver";

    my $worked = 0;
    eval {
        eval "require Archive::Tar;"; die $@ if $@;
        my $tar = Archive::Tar->new;

        $tar->read("pbc-$ver.tar.gz", 1);
        $tar->extract;

        $worked = 1 if -x "pbc-$ver/configure";
    };
    warn "Archive::Tar unpack problem: $@\n" if $@;

    unless( $worked ) {
        if( system("gzip -dc pbc-$ver.tar.gz | tar -xvf -") == 0 ) {
            $worked = 1 if -x "pbc-$ver/configure";
        }
    }

    warn "failed to unpack pbc\n" unless $worked;
    $worked;
}

sub grab_libpbc {
    my $ver = shift;
    return 1 if -f "pbc-$ver.tar.gz";

    my $worked = 0;
    eval {
        eval "require LWP::UserAgent"; die $@ if $@;
        my $ua = LWP::UserAgent->new;
           $ua->agent("crypt-pbc-fetcher/1.0");

        my $req = HTTP::Request->new(GET => "http://voltar.org/pbcfiles/pbc-$ver.tar.gz");
        my $res = $ua->request($req, "pbc-$ver.tar.gz");

        $worked = 1 if $res->is_success;
    };
    warn "LWP fetch problem: $@\n" if $@;

    unless( $worked ) {
        if( 0 != system(wget => '-O', "pbc-$ver.tar.gz", "http://voltar.org/pbcfiles/pbc-$ver.tar.gz") ) {
            warn "couldn't fetch with wget...\n";
            if( 0 != system(curl => '-o', "pbc-$ver.tar.gz", "http://voltar.org/pbcfiles/pbc-$ver.tar.gz") ) {
                warn "couldn't fetch with curl ...\n";
            }
        }

        $worked = 1 if -f "pbc-$ver.tar.gz";
    }

    warn "failed to download pbc\n" unless $worked;
    $worked;
}
