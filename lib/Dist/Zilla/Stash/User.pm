package Dist::Zilla::Stash::User;
BEGIN {
  $Dist::Zilla::Stash::User::VERSION = '4.200006';
}
use Moose;
# ABSTRACT: a stash of user name and email

has name => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

has email => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

sub authors {
  my ($self) = @_;
  return [ sprintf "%s <%s>", $self->name, $self->email ];
}

with 'Dist::Zilla::Role::Stash::Authors';
1;

__END__
=pod

=head1 NAME

Dist::Zilla::Stash::User - a stash of user name and email

=head1 VERSION

version 4.200006

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

