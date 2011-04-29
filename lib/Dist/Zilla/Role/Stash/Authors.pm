package Dist::Zilla::Role::Stash::Authors;
BEGIN {
  $Dist::Zilla::Role::Stash::Authors::VERSION = '4.200006';
}
use Moose::Role;
with 'Dist::Zilla::Role::Stash';
# ABSTRACT: a stash that provides a list of author strings


requires 'authors';

1;

__END__
=pod

=head1 NAME

Dist::Zilla::Role::Stash::Authors - a stash that provides a list of author strings

=head1 VERSION

version 4.200006

=head1 OVERVIEW

An Authors stash must provide an C<authors> method that returns an arrayref of
author strings, generally in the form "Name <email>".

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
