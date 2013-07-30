package inc::MakeMaker;
use Moose;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

around _build_MakeFile_PL_template => sub {
    my $orig = shift;
    my $self = shift;
    my $tmpl = $self->$orig;
    my $extra = <<'EXTRA';
use Devel::CallParser 'callparser1_h', 'callparser_linkable';
open my $fh, '>', 'callparser1.h' or die "Couldn't write to callparser1.h";
$fh->print(callparser1_h);
$WriteMakefileArgs{OBJECT} = join(' ', callparser_linkable);
EXTRA
    $tmpl =~ s/^(WriteMakefile\()/$extra\n$1/m
        or die "Couldn't fix template";
    return $tmpl;
};

__PACKAGE__->meta->make_immutable;
no Moose;

1;
