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

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

=func lex_peek

=func lex_read

=func lex_read_space

=func parse_block

=func compiling_package

=cut

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

    my @helpers = qw(
        lex_peek
        lex_read_space
        lex_read
        parse_block
        compiling_package
    );

    for my $helper (@helpers) {
        no strict 'refs';
        *{ $caller . '::' . $helper } = \&{ __PACKAGE__ . '::' . $helper };
    }
}

=head1 BUGS

No known bugs.

Please report any bugs to GitHub Issues at
L<https://github.com/doy/parse-keyword/issues>.

=head1 SEE ALSO

L<Devel::Declare>

L<Devel::CallParser>

=head1 SUPPORT

You can find this documentation for this module with the perldoc command.

    perldoc Parse::Keyword

You can also look for information at:

=over 4

=item * MetaCPAN

L<https://metacpan.org/release/Parse-Keyword>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Parse-Keyword>

=item * Github

L<https://github.com/doy/parse-keyword>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Parse-Keyword>

=back

=begin Pod::Coverage

  install_keyword_handler

=end Pod::Coverage

=cut

1;
