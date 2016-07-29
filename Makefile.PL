use strict;
use warnings;
use ExtUtils::MakeMaker;

# Normalize version strings like 6.30_02 to 6.3002,
# so that we can do numerical comparisons on it.
my $eumm_version = $ExtUtils::MakeMaker::VERSION;
$eumm_version =~ s/_//;

WriteMakefile(
    NAME                => 'SamRaymer::TwitterRoutes',
    AUTHOR              => q{Sam Raymer <sam@sam-raymer.com>},
    VERSION_FROM        => 'lib/SamRaymer/TwitterRoutes.pm',
    ABSTRACT            => 'Get recent tweets! Get common follows!',
    ($eumm_version >= 6.3001
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'YAML'       => 0,
        'Dancer2'     => 0.201000,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'SamRaymer-TwitterRoutes-*' },
);
