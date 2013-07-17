package Parse::Keyword;
use strict;
use warnings;
use 5.014;
# ABSTRACT: write syntax extensions in perl

use Devel::CallParser;
use XSLoader;

XSLoader::load(
    __PACKAGE__,
    exists $Parse::Keyword::{VERSION} ? ${ $Parse::Keyword::{VERSION} } : (),
);

sub import {
    my $package = shift;
    my ($keywords) = @_;

    my $caller = caller;

    for my $keyword (keys %$keywords) {
        my $sub = do {
            no strict 'refs';
            \&{ $caller . '::' . $keyword };
        };
        install_keyword_handler($sub, $keywords->{$keyword});
    }
}

1;
