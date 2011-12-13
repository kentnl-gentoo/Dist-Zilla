package Dist::Zilla::Plugin::TestRelease;
{
  $Dist::Zilla::Plugin::TestRelease::VERSION = '4.300004';
}
use Moose;
with 'Dist::Zilla::Role::BeforeRelease';
# ABSTRACT: extract archive and run tests before releasing the dist

use namespace::autoclean;


use Archive::Tar;
use File::pushd ();
use Moose::Autobox;
use Path::Class ();

sub before_release {
  my ($self, $tgz) = @_;
  $tgz = $tgz->absolute;

  my $build_root = $self->zilla->root->subdir('.build');
  $build_root->mkpath unless -d $build_root;

  my $tmpdir = Path::Class::dir( File::Temp::tempdir(DIR => $build_root) );

  $self->log("Extracting $tgz to $tmpdir");

  my @files = do {
    my $wd = File::pushd::pushd($tmpdir);
    Archive::Tar->extract_archive("$tgz");
  };

  $self->log_fatal([ "Failed to extract archive: %s", Archive::Tar->error ])
    unless @files;

  # Run tests on the extracted tarball:
  my $target = $tmpdir->subdir( $self->zilla->built_in->dir_list(-1) );

  local $ENV{RELEASE_TESTING} = 1;
  local $ENV{AUTHOR_TESTING} = 1;
  $self->zilla->run_tests_in($target);

  $self->log("all's well; removing $tmpdir");
  $tmpdir->rmtree;
}

__PACKAGE__->meta->make_immutable;
1;

__END__
=pod

=head1 NAME

Dist::Zilla::Plugin::TestRelease - extract archive and run tests before releasing the dist

=head1 VERSION

version 4.300004

=head1 DESCRIPTION

This plugin runs before a release happens.  It will extract the to-be-released
archive into a temporary directory and use the TestRunner plugins to run its
tests.  If the tests fail, the release is aborted and the temporary directory
is left in place.  If the tests pass, the temporary directory is cleaned up and
the release process continues.

This will set the RELEASE_TESTING and AUTHOR_TESTING env vars while running the
testsuite.

=head1 CREDITS

This plugin was originally contributed by Christopher J. Madsen.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

