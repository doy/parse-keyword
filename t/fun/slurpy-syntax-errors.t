#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use lib 't/fun/lib';

use Fun;

{
    eval 'fun ( $foo, @bar, $baz ) { return [] }';
    ok $@, '... got an error';
}

{
    eval 'fun ( $foo, %bar, $baz ) { return {} }';
    ok $@, '... got an error';
}

{
    eval 'fun ( $foo, @bar, %baz ) { return [] }';
    ok $@, '... got an error';
}

{
    eval 'fun ( $foo, %bar, @baz ) { return {} }';
    ok $@, '... got an error';
}

done_testing;
