package Dist::Zilla::Stash::PAUSE;
{
  $Dist::Zilla::Stash::PAUSE::VERSION = '4.200013';
}
use Moose;
# ABSTRACT: a stash of your PAUSE credentials


sub mvp_aliases {
  return { user => 'username' };
}

has username => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

has password => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

with 'Dist::Zilla::Role::Stash::Login';
1;

__END__
=pod

=head1 NAME

Dist::Zilla::Stash::PAUSE - a stash of your PAUSE credentials

=head1 VERSION

version 4.200013

=head1 OVERVIEW

The PAUSE stash is a L<Login|Dist::Zilla::Role::Stash::Login> stash generally
used for uploading to PAUSE.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

