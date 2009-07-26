package Dist::Zilla::Role::MetaProvider;
our $VERSION = '1.092070';

# ABSTRACT: something that provides metadata (for META.yml/json)
use Moose::Role;
with 'Dist::Zilla::Role::Plugin';


requires 'metadata';

no Moose::Role;
1;

__END__

=pod

=head1 NAME

Dist::Zilla::Role::MetaProvider - something that provides metadata (for META.yml/json)

=head1 VERSION

version 1.092070

=head1 DESCRIPTION

This role provides data to merge into the distribution metadata.

=head1 METHODS

=head2 metadata

This method returns a hashref of data to be (deeply) merged together with
pre-existing metadata.

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


