use strict;
use warnings;
package Dist::Zilla::App::Command::test;
BEGIN {
  $Dist::Zilla::App::Command::test::VERSION = '4.101831';
}
# ABSTRACT: test your dist
use Dist::Zilla::App -command;

use Moose::Autobox;


sub abstract { 'test your dist' }

sub execute {
  my ($self, $opt, $arg) = @_;

  $self->zilla->test;
}

1;

__END__
=pod

=head1 NAME

Dist::Zilla::App::Command::test - test your dist

=head1 VERSION

version 4.101831

=head1 SYNOPSIS

  dzil test

This command is a thin wrapper around the C<L<test|Dist::Zilla/test>> method in
Dist::Zilla.  It builds your dist and runs the tests with AUTHOR_TESTING and
RELEASE_TESTING environment variables turned on, so it's like doing this:

  export AUTHOR_TESTING=1
  export RELEASE_TESTING=1
  dzil build --no-tgz
  cd $BUILD_DIRECTORY
  perl Makefile.PL
  make
  make test

A build that fails tests will be left behind for analysis, and F<dzil> will
exit a non-zero value.  If the tests are successful, the build directory will
be removed and F<dzil> will exit with status 0.

=head1 SEE ALSO

The heavy lifting of this module is now done by
L<Dist::Zilla::Role::TestRunner> plugins.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

