package Dist::Zilla::Role::AfterRelease;
# ABSTRACT: something that runs after release is mostly complete
$Dist::Zilla::Role::AfterRelease::VERSION = '5.018';
use Moose::Role;
with 'Dist::Zilla::Role::Plugin';

use namespace::autoclean;

#pod =head1 DESCRIPTION
#pod
#pod Plugins implementing this role have their C<after_release> method called
#pod once the release is done.
#pod
#pod =cut

requires 'after_release';

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::Role::AfterRelease - something that runs after release is mostly complete

=head1 VERSION

version 5.018

=head1 DESCRIPTION

Plugins implementing this role have their C<after_release> method called
once the release is done.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
