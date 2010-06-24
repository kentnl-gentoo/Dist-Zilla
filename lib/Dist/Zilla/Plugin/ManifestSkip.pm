package Dist::Zilla::Plugin::ManifestSkip;
BEGIN {
  $Dist::Zilla::Plugin::ManifestSkip::VERSION = '4.101740';
}
# ABSTRACT: decline to build files that appear in a MANIFEST.SKIP-like file
use Moose;
with 'Dist::Zilla::Role::FilePruner';

use ExtUtils::Manifest 1.54; # public maniskip routine


has skipfile => (is => 'ro', required => 1, default => 'MANIFEST.SKIP');

sub prune_files {
  my ($self) = @_;

  my $skipfile = $self->zilla->root->file( $self->skipfile );
  return unless -f $skipfile;
  my $skip = ExtUtils::Manifest::maniskip($skipfile);

  my $files = $self->zilla->files;
  @$files = grep {
    $skip->($_->name)
    ? do { $self->log_debug([ 'pruning %s', $_->name ]); 0 }
    : 1
  } @$files;

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

version 4.101740

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

