# This module uses Dist::Zilla for development. This Makefile.PL will let you
# run the tests, but you are encouraged to install Dist::Zilla and the needed
# plugins if you intend on doing any serious hacking.

use strict;
use warnings;

use Config;
use ExtUtils::MakeMaker::Dist::Zilla::Develop;

use inc::MMHelper;

my %WriteMakefileArgs = (
    NAME => 'Parse::Keyword',
    test => { TESTS => 't/*.t t/*/*.t' },
    %{ inc::MMHelper::mm_args() },
);

eval inc::MMHelper::makefile_pl_extra . ';1;'
    or die $@;

WriteMakefile(%WriteMakefileArgs);
