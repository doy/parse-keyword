#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use lib 't/fun/lib';

use Fun;

is(foo(), "FOO");

fun foo { "FOO" }

done_testing;
