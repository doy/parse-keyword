# This module uses Dist::Zilla for development. This Makefile.PL will let you
# run the tests, but you are encouraged to install Dist::Zilla and the needed
# plugins if you intend on doing any serious hacking.

use strict;
use warnings;

use ExtUtils::MakeMaker::Dist::Zilla::Develop;

use Devel::CallParser 'callparser1_h';
open my $fh, '>', 'callparser1.h' or die "Couldn't write to callparser1.h";
$fh->print(callparser1_h);

WriteMakefile(
    NAME => 'Parse::Keyword',
);
