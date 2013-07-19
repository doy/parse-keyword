#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

{
    package Foo;

    use Parse::Keyword { bar => \&bar_parser };

    sub bar { @_ }
    sub bar_parser {
        return sub { return (1, 2, 3) }
    }

    ::is_deeply([bar], [1, 2, 3]);
}

done_testing;
