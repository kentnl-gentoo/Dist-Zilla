use strict;
use warnings;

package Dist::Zilla::Role::AfterRelease;
our $VERSION = '1.093250';


# ABSTRACT: something that runs after release is mostly complete

use Moose::Role;

with 'Dist::Zilla::Role::Plugin';
requires 'after_release';

no Moose::Role;
1;


=pod

=head1 NAME

Dist::Zilla::Role::AfterRelease - something that runs after release is mostly complete

=head1 VERSION

version 1.093250

=head1 DESCRIPTION

Plugins implementing this role have their C<after_release> method called
once the release is done.

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

