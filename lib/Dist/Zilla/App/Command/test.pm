use strict;
use warnings;
package Dist::Zilla::App::Command::test;
BEGIN {
  $Dist::Zilla::App::Command::test::VERSION = '4.200010';
}
# ABSTRACT: test your dist
use Dist::Zilla::App -command;


sub opt_spec {
  [ 'release'   => 'enables the RELEASE_TESTING env variable', { default => 0 } ],
  [ 'automated' => 'enables the AUTOMATED_TESTING env variable', { default => 0 } ],
  [ 'author!' => 'enables the AUTHOR_TESTING env variable (default behavior)', { default => 1 } ]
}


sub abstract { 'test your dist' }

sub execute {
  my ($self, $opt, $arg) = @_;

  local $ENV{RELEASE_TESTING} = 1 if $opt->release;
  local $ENV{AUTHOR_TESTING} = 1 if $opt->author;
  local $ENV{AUTOMATED_TESTING} = 1 if $opt->automated;

  $self->zilla->test;
}

1;

__END__
=pod

=head1 NAME

Dist::Zilla::App::Command::test - test your dist

=head1 VERSION

version 4.200010

=head1 SYNOPSIS

  dzil test [ --release ] [ --no-author ] [ --automated ]

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

This will run the testsuite with RELEASE_TESTING=1

=head2 --automated

This will run the testsuite with AUTOMATED_TESTING=1

=head2 --no-author

This will run the testsuite without setting AUTHOR_TESTING

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

