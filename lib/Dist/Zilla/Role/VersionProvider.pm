package Dist::Zilla::Role::VersionProvider;
# ABSTRACT: something that provides a version number for the dist
$Dist::Zilla::Role::VersionProvider::VERSION = '5.045';
use Moose::Role;
with 'Dist::Zilla::Role::Plugin';

use namespace::autoclean;

#pod =head1 DESCRIPTION
#pod
#pod Plugins implementing this role must provide a C<provide_version> method that
#pod will be called when setting the dist's version.
#pod
#pod If a VersionProvider offers a version but one has already been set, an
#pod exception will be raised.  If C<provides_version> returns undef, it will be
#pod ignored.
#pod
#pod =cut

requires 'provide_version';

1;

#pod =head1 SEE ALSO
#pod
#pod Core Dist::Zilla plugins implementing this role:
#pod L<AutoVersion|Dist::Zilla::Plugin::AutoVersion>.
#pod
#pod =cut

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::Role::VersionProvider - something that provides a version number for the dist

=head1 VERSION

version 5.045

=head1 DESCRIPTION

Plugins implementing this role must provide a C<provide_version> method that
will be called when setting the dist's version.

If a VersionProvider offers a version but one has already been set, an
exception will be raised.  If C<provides_version> returns undef, it will be
ignored.

=head1 SEE ALSO

Core Dist::Zilla plugins implementing this role:
L<AutoVersion|Dist::Zilla::Plugin::AutoVersion>.

=head1 AUTHOR

Ricardo SIGNES 🎃 <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
