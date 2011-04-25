use strict;
use warnings;
package Dist::Zilla::App::Command::smoke;
BEGIN {
  $Dist::Zilla::App::Command::smoke::VERSION = '4.200005';
}
# ABSTRACT: smoke your dist
use Dist::Zilla::App -command;
require Dist::Zilla::App::Command::test;


sub abstract { 'smoke your dist' }

sub execute {
  my $self = shift;

  local $ENV{AUTOMATED_TESTING} = 1;
  local @ARGV = qw(test);

  return $self->app->run;
}

1;

__END__
=pod

=head1 NAME

Dist::Zilla::App::Command::smoke - smoke your dist

=head1 VERSION

version 4.200005

=head1 SYNOPSIS

This command builds and tests distribution in "smoke testing mode."

  dzil smoke

Otherwise identical to

  AUTOMATED_TESTING=1 dzil test

See L<Dist::Zilla::App::Command::test> for more.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

