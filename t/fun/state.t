#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use lib 't/fun/lib';

use Test::Requires 'Sub::Name';

use 5.10.0;
use Fun;

fun bar ($y) {
    state $x = 10;
    $x * $y;
}

is(bar(3), 30);

done_testing;
