package Try;
use strict;
use warnings;

use Try::Tiny ();

use Parse::Keyword { try => \&try_parser };
use Exporter 'import';

our @EXPORT = ('try');

sub try {
    my ($try, $catch, $finally) = @_;

    &Try::Tiny::try(
        $try,
        ($catch   ? (&Try::Tiny::catch($catch))     : ()),
        ($finally ? (&Try::Tiny::finally($finally)) : ()),
    );
}

sub try_parser {
    my ($try, $catch, $finally);

    lex_read_space;

    die "syntax error" unless lex_peek_unichar eq '{';
    $try = parse_block;

    lex_read_space;

    ensure_linestr_len(5);
    if (linestr =~ /^catch/) {
        lex_read_to(5);
        lex_read_space;
        die "syntax error" unless lex_peek_unichar eq '{';
        $catch = parse_block;
    }

    lex_read_space;

    ensure_linestr_len(7);
    if (linestr =~ /^finally/) {
        lex_read_to(7);
        lex_read_space;
        die "syntax error" unless lex_peek_unichar eq '{';
        $finally = parse_block;
    }

    return (sub { ($try, $catch, $finally) }, 1);
}

1;
