package Dist::Zilla::Role::BeforeArchive;
# ABSTRACT: something that runs before the archive file is built
$Dist::Zilla::Role::BeforeArchive::VERSION = '6.005';
use Moose::Role;
with 'Dist::Zilla::Role::Plugin';

use namespace::autoclean;

#pod =head1 DESCRIPTION
#pod
#pod Plugins implementing this role have their C<before_archive> method
#pod called before the archive is actually built.
#pod
#pod =cut

requires 'before_archive';

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::Role::BeforeArchive - something that runs before the archive file is built

=head1 VERSION

version 6.005

=head1 DESCRIPTION

Plugins implementing this role have their C<before_archive> method
called before the archive is actually built.

=head1 AUTHOR

Ricardo SIGNES 😏 <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
