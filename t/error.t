#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

my $got_code;
BEGIN {
    package My::Parser;
    use Exporter 'import';
    our @EXPORT = 'foo';
    use Parse::Keyword { foo => \&parse_foo };

    sub foo {}
    sub parse_foo {
        lex_read_space;
        my $code = parse_block;
        $got_code = $code ? 1 : 0;
        return sub {};
    }

    $INC{'My/Parser.pm'} = __FILE__;
}

use My::Parser;

eval "foo";
ok($@);
ok(!$got_code);
eval "foo { }";
ok(!$@);
ok($got_code);

done_testing;
