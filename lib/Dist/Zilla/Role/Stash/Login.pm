package Dist::Zilla::Role::Stash::Login;
BEGIN {
  $Dist::Zilla::Role::Stash::Login::VERSION = '4.102345';
}
use Moose::Role;
with 'Dist::Zilla::Role::Stash';
# ABSTRACT: a stash with username/password credentials


requires 'username';
requires 'password';

1;

__END__
=pod

=head1 NAME

Dist::Zilla::Role::Stash::Login - a stash with username/password credentials

=head1 VERSION

version 4.102345

=head1 OVERVIEW

A Login stash must provide a C<username> and C<password> method.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

