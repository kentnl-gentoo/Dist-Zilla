use strict;
use warnings;
package Dist::Zilla::App::Command::test;
# ABSTRACT: test your dist
$Dist::Zilla::App::Command::test::VERSION = '5.023';
use Dist::Zilla::App -command;

#pod =head1 SYNOPSIS
#pod
#pod   dzil test [ --release ] [ --no-author ] [ --automated ] [ --all ]
#pod
#pod =head1 DESCRIPTION
#pod
#pod This command is a thin wrapper around the L<test|Dist::Zilla::Dist::Builder/test> method in
#pod Dist::Zilla.  It builds your dist and runs the tests with the AUTHOR_TESTING
#pod environment variable turned on, so it's like doing this:
#pod
#pod   export AUTHOR_TESTING=1
#pod   dzil build --no-tgz
#pod   cd $BUILD_DIRECTORY
#pod   perl Makefile.PL
#pod   make
#pod   make test
#pod
#pod A build that fails tests will be left behind for analysis, and F<dzil> will
#pod exit a non-zero value.  If the tests are successful, the build directory will
#pod be removed and F<dzil> will exit with status 0.
#pod
#pod =cut

sub opt_spec {
  [ 'release'   => 'enables the RELEASE_TESTING env variable', { default => 0 } ],
  [ 'automated' => 'enables the AUTOMATED_TESTING env variable', { default => 0 } ],
  [ 'author!' => 'enables the AUTHOR_TESTING env variable (default behavior)', { default => 1 } ],
  [ 'all' => 'enables the RELEASE_TESTING, AUTOMATED_TESTING and AUTHOR_TESTING env variables', { default => 0 } ],
  [ 'keep-build-dir|keep' => 'keep the build directory even after a success' ],
  [ 'jobs|j=i' => 'number of parallel test jobs to run' ],
}

#pod =head1 OPTIONS
#pod
#pod =head2 --release
#pod
#pod This will run the test suite with RELEASE_TESTING=1
#pod
#pod =head2 --automated
#pod
#pod This will run the test suite with AUTOMATED_TESTING=1
#pod
#pod =head2 --no-author
#pod
#pod This will run the test suite without setting AUTHOR_TESTING
#pod
#pod =head2 --all
#pod
#pod Equivalent to --release --automated --author
#pod
#pod =cut

sub abstract { 'test your dist' }

sub execute {
  my ($self, $opt, $arg) = @_;

  local $ENV{RELEASE_TESTING} = 1 if $opt->release or $opt->all;
  local $ENV{AUTHOR_TESTING} = 1 if $opt->author or $opt->all;
  local $ENV{AUTOMATED_TESTING} = 1 if $opt->automated or $opt->all;

  $self->zilla->test({
    $opt->keep_build_dir
      ? (keep_build_dir => 1)
      : (),
    $opt->jobs
      ? (jobs => $opt->jobs)
      : (),
  });
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::App::Command::test - test your dist

=head1 VERSION

version 5.023

=head1 SYNOPSIS

  dzil test [ --release ] [ --no-author ] [ --automated ] [ --all ]

=head1 DESCRIPTION

This command is a thin wrapper around the L<test|Dist::Zilla::Dist::Builder/test> method in
Dist::Zilla.  It builds your dist and runs the tests with the AUTHOR_TESTING
environment variable turned on, so it's like doing this:

  export AUTHOR_TESTING=1
  dzil build --no-tgz
  cd $BUILD_DIRECTORY
  perl Makefile.PL
  make
  make test

A build that fails tests will be left behind for analysis, and F<dzil> will
exit a non-zero value.  If the tests are successful, the build directory will
be removed and F<dzil> will exit with status 0.

=head1 OPTIONS

=head2 --release

This will run the test suite with RELEASE_TESTING=1

=head2 --automated

This will run the test suite with AUTOMATED_TESTING=1

=head2 --no-author

This will run the test suite without setting AUTHOR_TESTING

=head2 --all

Equivalent to --release --automated --author

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
