package inc::MakeMaker;
use Moose;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

around _build_MakeFile_PL_template => sub {
    my $orig = shift;
    my $self = shift;
    my $tmpl = $self->$orig;
    my $extra = <<'EXTRA';
use Config;
use Devel::CallParser 'callparser1_h', 'callparser_linkable';
open my $fh, '>', 'callparser1.h' or die "Couldn't write to callparser1.h";
$fh->print(callparser1_h);
my @linkable = callparser_linkable;
unshift @linkable, "Keyword$Config{obj_ext}" if @linkable;
$WriteMakefileArgs{OBJECT} = join(' ', @linkable) if @linkable;
EXTRA
    $tmpl =~ s/^(WriteMakefile\()/$extra\n$1/m
        or die "Couldn't fix template";
    return $tmpl;
};

__PACKAGE__->meta->make_immutable;
no Moose;

1;
