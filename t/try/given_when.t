#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use lib 't/try/lib';
use 5.014;

use Try;

my ( $error, $topic );

given ("foo") {
    when (qr/./) {
        try {
            die "blah\n";
        } catch {
            $topic = $_;
            $error = $_[0];
        }
        pass("syntax ok");
    };
}

is( $error, "blah\n", "error caught" );

{
    local $TODO = "perhaps a workaround can be found";
    is( $topic, $error, 'error is also in $_' );
}

done_testing;
