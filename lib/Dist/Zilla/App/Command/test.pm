use strict;
use warnings;
package Dist::Zilla::App::Command::test;
our $VERSION = '1.093140';


# ABSTRACT: test your dist
use Dist::Zilla::App -command;

use Moose::Autobox;



sub abstract { 'test your dist' }

sub execute {
  my ($self, $opt, $arg) = @_;

  Carp::croak("you can't release without any TestRunner plugins")
    unless my @testers = $self->zilla->plugins_with(-TestRunner)->flatten;

  require Dist::Zilla;
  require File::chdir;
  require File::Temp;
  require Path::Class;

  my $build_root = Path::Class::dir('.build');
  $build_root->mkpath unless -d $build_root;

  my $target = Path::Class::dir( File::Temp::tempdir(DIR => $build_root) );
  $self->log("building test distribution under $target");

  local $ENV{AUTHOR_TESTING} = 1;
  local $ENV{RELEASE_TESTING} = 1;

  $self->zilla->ensure_built_in($target);

  my $error;

  for my $tester ( @testers ) {
    eval {
      local $File::chdir::CWD = $target;
      $tester->test( $target );
    } or do {
      $error = $@;
      last;
    };
  }

  if ( $error ) {
    $self->log($error);
    $self->log("left failed dist in place at $target");
    exit 1;                     # Indicate test failure
  } else {
    $self->log("all's well; removing $target");
    $target->rmtree;
  }

}

1;

__END__
=pod

=head1 NAME

Dist::Zilla::App::Command::test - test your dist

=head1 VERSION

version 1.093140

=head1 SYNOPSIS

Test your distribution.

    dzil test

This runs with AUTHOR_TESTING and RELEASE_TESTING environment variables turned on, so its ultimately like doing this:

    export AUTHOR_TESTING=1
    export RELEASE_TESTING=1
    dzil build
    rsync -avp My-Project-Version/ .build/
    cd .build;
    perl Makefile.PL
    make
    make test

Except for the fact it's built directly in a subdir of .build ( such as .build/ASDF123 );

A Build that fails tests will be left behind for analysis, and dzil
will exit with status 1.  If the tests are successful, the build
directory will be removed and dzil will exit with status 0.

=head1 SEE ALSO

The heavy lifting of this module is now done by L<Dist::Zilla::Role::TestRunner> plugins.

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

