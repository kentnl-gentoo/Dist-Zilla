package Dist::Zilla::Plugin::ManifestSkip;
our $VERSION = '1.100651';
# ABSTRACT: decline to build files that appear in a MANIFEST.SKIP-like file
use Moose;
with 'Dist::Zilla::Role::FilePruner';

use ExtUtils::Manifest;


has skipfile => (is => 'ro', required => 1, default => 'MANIFEST.SKIP');

sub prune_files {
  my ($self) = @_;

  my $skip = ExtUtils::Manifest::maniskip($self->skipfile);

  my $files = $self->zilla->files;
  @$files = grep { ! $skip->($_->name) } @$files;

  return;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__
=pod

=head1 NAME

Dist::Zilla::Plugin::ManifestSkip - decline to build files that appear in a MANIFEST.SKIP-like file

=head1 VERSION

version 1.100651

=head1 DESCRIPTION

This plugin reads a MANIFEST.SKIP-like file, as used by L<ExtUtils::MakeMaker>
and L<ExtUtils::Manifest>, and prunes any files that it declares should be
skipped.

=head1 ATTRIBUTES

=head2 skipfile

This is the name of the file to read for MANIFEST.SKIP-like content.  It
defaults, unsurprisingly, to F<MANIFEST.SKIP>.

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

