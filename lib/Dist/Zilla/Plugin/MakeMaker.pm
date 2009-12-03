package Dist::Zilla::Plugin::MakeMaker;
our $VERSION = '1.093371';

# ABSTRACT: build a Makefile.PL that uses ExtUtils::MakeMaker
use Moose;
use Moose::Autobox;
with 'Dist::Zilla::Role::InstallTool';
with 'Dist::Zilla::Role::TextTemplate';
with 'Dist::Zilla::Role::TestRunner';


use Dist::Zilla::File::InMemory;

my $template = q|
use strict;
use warnings;

{{
  my $prereq = $dist->prereq;
  exists $prereq->{perl}
    ? qq{ BEGIN { require $prereq->{perl}; } }
    : '';
}}

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => '{{ $dist->name     }}',
  NAME      => '{{ $module_name    }}',
  AUTHOR    => "{{ $author_str     }}",
  ABSTRACT  => "{{ quotemeta($dist->abstract) }}",
  VERSION   => '{{ $dist->version  }}',
  EXE_FILES => [ qw({{ $exe_files }}) ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => '{{ $dist->license->meta_yml_name }}') : ()),
  PREREQ_PM    => {
{{
      my $prereq = $dist->prereq;
      $OUT .= qq{    "$_" => '$prereq->{$_}',\n} for grep { $_ ne 'perl' } keys %$prereq;
      chomp $OUT;
      return '';
}}
  },
  test => {TESTS => '{{ $test_dirs }}'}
);

|;

sub setup_installer {
  my ($self, $arg) = @_;

  (my $name = $self->zilla->name) =~ s/-/::/g;

  my $exe_files = $self->zilla->files
    ->grep( sub { ( $_->install_type || '' ) eq 'bin' } )
    ->map(  sub { $_->name } )
    ->join(q{ });

  my %test_dirs;
  for my $file ($self->zilla->files->flatten) {
    next unless $file->name =~ m{\At/.+\.t\z};
    (my $dir = $file->name) =~ s{/[^/]+\.t\z}{/*.t}g;

    $test_dirs{ $dir } = 1;
  }

  my $content = $self->fill_in_string(
    $template,
    {
      module_name => $name,
      dist        => \$self->zilla,
      exe_files   => \$exe_files,
      author_str  => \quotemeta( $self->zilla->authors->join(q{, }) ),
      test_dirs   => join (q{ }, sort keys %test_dirs),
    },
  );

  my $file = Dist::Zilla::File::InMemory->new({
    name    => 'Makefile.PL',
    content => $content,
  });

  $self->add_file($file);
  return;
}

sub test {
  my ( $self, $target ) = @_;
  ## no critic Punctuation
  system($^X => 'Makefile.PL') and die "error with Makefile.PL\n";
  system('make') and die "error running make\n";
  system('make test') and die "error running make test\n";
  return;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__
=pod

=head1 NAME

Dist::Zilla::Plugin::MakeMaker - build a Makefile.PL that uses ExtUtils::MakeMaker

=head1 VERSION

version 1.093371

=head1 DESCRIPTION

This plugin will produce an L<ExtUtils::MakeMaker>-powered F<Makefile.PL> for
the distribution.  If loaded, the L<Manifest|Dist::Zilla::Plugin::Manifest>
plugin should also be loaded.

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

