package Dist::Zilla::Plugin::Readme;
# ABSTRACT: build a README file
$Dist::Zilla::Plugin::Readme::VERSION = '5.041';
use Moose;
with qw/Dist::Zilla::Role::FileGatherer
    Dist::Zilla::Role::TextTemplate
    Dist::Zilla::Role::FileMunger/;

use Moose::Util::TypeConstraints;
use namespace::autoclean;

#pod =head1 DESCRIPTION
#pod
#pod This plugin adds a very simple F<README> file to the distribution, citing the
#pod dist's name, version, abstract, and license.  It may be more useful or
#pod informative in the future.
#pod
#pod =cut

has _file_obj => (
  is => 'rw', isa => role_type('Dist::Zilla::Role::File'),
);

sub gather_files {
  my ($self, $arg) = @_;

  require Dist::Zilla::File::InMemory;

  my $template = q|

This archive contains the distribution {{ $dist->name }},
version {{ $dist->version }}:

  {{ $dist->abstract }}

{{ $dist->license->notice }}

This README file was generated by {{ $generated_by }}.

|;

  $self->add_file(
    $self->_file_obj(
      Dist::Zilla::File::InMemory->new(
        name => 'README',
        content => $template,
      )
    )
  );

  return;
}

sub munge_files {
  my $self = shift;

  my $file = $self->_file_obj;

  $file->content(
    $self->fill_in_string(
      $file->content,
      {
        dist => \($self->zilla),
        generated_by => \sprintf("%s v%s",
                          ref($self), $self->VERSION || '(dev)'),
      }
    )
  );

  return;
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::Plugin::Readme - build a README file

=head1 VERSION

version 5.041

=head1 DESCRIPTION

This plugin adds a very simple F<README> file to the distribution, citing the
dist's name, version, abstract, and license.  It may be more useful or
informative in the future.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
