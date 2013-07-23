#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

my $got_code;
BEGIN {
    package My::Parser;
    use Exporter 'import';
    our @EXPORT = ('foo', 'bar');
    use Parse::Keyword {
        foo => \&parse_foo,
        bar => \&parse_bar,
    };

    sub foo { 1 }
    sub parse_foo {
        lex_read_space;
        my $code = parse_block;
        $got_code = $code ? 1 : 0;
        return sub {};
    }

    sub bar { 1 }
    sub parse_bar {
        lex_read_space;
        my $code = eval { parse_block };
        $got_code = $code ? 1 : 0;
        return sub {};
    }

    $INC{'My/Parser.pm'} = __FILE__;
}

use My::Parser;

ok(!eval "foo");
ok($@);
ok(!$got_code);
ok(eval "foo { }");
ok(!$@);
ok($got_code);
ok(!eval 'foo { $baz }');
like($@, qr/^Global symbol "\$baz" requires explicit package name/);

# even in an eval, unrecoverable errors still throw, because the parser state
# is now too confused to continue - the error will be thrown after normal
# parsing continues
ok(!eval "bar");
ok($@);
ok(!$got_code);
ok(eval "bar { }");
ok(!$@);
ok($got_code);
# but recoverable errors no longer throw
ok(eval 'bar { $baz }');
is($@, '');

done_testing;
