package Dist::Zilla::Plugin::MakeMaker;
BEGIN {
  $Dist::Zilla::Plugin::MakeMaker::VERSION = '2.101290';
}

# ABSTRACT: build a Makefile.PL that uses ExtUtils::MakeMaker
use Moose;
use Moose::Autobox;
with 'Dist::Zilla::Role::BuildRunner';
with 'Dist::Zilla::Role::PrereqSource';
with 'Dist::Zilla::Role::InstallTool';
with 'Dist::Zilla::Role::TestRunner';
with 'Dist::Zilla::Role::TextTemplate';


use Data::Dumper ();
use List::MoreUtils qw(any uniq);

use namespace::autoclean;

use Dist::Zilla::File::InMemory;

my $template = q|
use strict;
use warnings;

{{ $perl_prereq ? qq{ BEGIN { require $perl_prereq; } } : ''; }}

use ExtUtils::MakeMaker {{ $eumm_version }};

{{ $share_dir_block[0] }}

my {{ $WriteMakefileArgs }}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM}; 
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod}; 
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);

{{ $share_dir_block[1] }}

|;

sub register_prereqs {
  my ($self) = @_;

  $self->zilla->register_prereqs(
    { phase => 'configure' },
    'ExtUtils::MakeMaker' => $self->eumm_version,
  );

  return unless $self->zilla->_share_dir;

  $self->zilla->register_prereqs(
    { phase => 'configure' },
    'File::ShareDir::Install' => 0.03,
  );
}

sub setup_installer {
  my ($self, $arg) = @_;

  (my $name = $self->zilla->name) =~ s/-/::/g;

  my @exe_files =
    $self->zilla->find_files(':ExecFiles')->map(sub { $_->name })->flatten;

  $self->log_fatal("can't install files with whitespace in their names")
    if grep { /\s/ } @exe_files;

  my %test_dirs;
  for my $file ($self->zilla->files->flatten) {
    next unless $file->name =~ m{\At/.+\.t\z};
    (my $dir = $file->name) =~ s{/[^/]+\.t\z}{/*.t}g;

    $test_dirs{ $dir } = 1;
  }

  my @share_dir_block = (q{}, q{});

  if (my $share_dir = $self->zilla->_share_dir) {
    my $share_dir = quotemeta $share_dir;
    @share_dir_block = (
      qq{use File::ShareDir::Install;\ninstall_share "$share_dir";\n},
      qq{package\nMY;\nuse File::ShareDir::Install qw(postamble);\n},
    );
  }

  my $meta_prereq = $self->zilla->prereq->as_distmeta;
  my $perl_prereq = delete $meta_prereq->{requires}{perl};

  my %write_makefile_args = (
    DISTNAME  => $self->zilla->name,
    NAME      => $name,
    AUTHOR    => $self->zilla->authors->join(q{, }),
    ABSTRACT  => $self->zilla->abstract,
    VERSION   => $self->zilla->version,
    LICENSE   => $self->zilla->license->meta_yml_name,
    EXE_FILES => [ @exe_files ],

    CONFIGURE_REQUIRES => delete $meta_prereq->{configure_requires},
    BUILD_REQUIRES     => delete $meta_prereq->{build_requires},
    PREREQ_PM          => delete $meta_prereq->{requires},

    test => { TESTS => join q{ }, sort keys %test_dirs },
  );

  $self->__write_makefile_args(\%write_makefile_args);

  my $makefile_args_dumper = Data::Dumper->new(
    [ \%write_makefile_args ],
    [ '*WriteMakefileArgs' ],
  );
  $makefile_args_dumper->Sortkeys( 1 );
  $makefile_args_dumper->Indent( 1 );

  my $content = $self->fill_in_string(
    $template,
    {
      eumm_version      => \($self->eumm_version),
      perl_prereq       => \$perl_prereq,
      share_dir_block   => \@share_dir_block,
      WriteMakefileArgs => \($makefile_args_dumper->Dump),
    },
  );

  my $file = Dist::Zilla::File::InMemory->new({
    name    => 'Makefile.PL',
    content => $content,
  });

  $self->add_file($file);
  return;
}

# XXX:  Just here to facilitate testing. -- rjbs, 2010-03-20
has __write_makefile_args => (
  is   => 'rw',
  isa  => 'HashRef',
);

sub build {
  my $self = shift;

  system($^X => 'Makefile.PL') and die "error with Makefile.PL\n";
  system('make')               and die "error running make\n";

  return;
}

sub test {
  my ( $self, $target ) = @_;

  $self->build;
  system('make test') and die "error running make test\n";

  return;
}

has 'eumm_version' => (
  isa => 'Str',
  is  => 'rw',
  default => '6.31',
);

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__
=pod

=head1 NAME

Dist::Zilla::Plugin::MakeMaker - build a Makefile.PL that uses ExtUtils::MakeMaker

=head1 VERSION

version 2.101290

=head1 DESCRIPTION

This plugin will produce an L<ExtUtils::MakeMaker>-powered F<Makefile.PL> for
the distribution.  If loaded, the L<Manifest|Dist::Zilla::Plugin::Manifest>
plugin should also be loaded.

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

