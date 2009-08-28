package Dist::Zilla::File::InMemory;
our $VERSION = '1.092400';

# ABSTRACT: a file that you build entirely in memory
use Moose;
with 'Dist::Zilla::Role::File';


has content => (
  is  => 'rw',
  isa => 'Str',
  required => 1,
);

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__

=pod

=head1 NAME

Dist::Zilla::File::InMemory - a file that you build entirely in memory

=head1 VERSION

version 1.092400

=head1 DESCRIPTION

This represents a file created in memory -- it's not much more than a glorified
string.

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut 


