package Dist::Zilla::Role::NameProvider;
# ABSTRACT: something that provides a name for the dist
$Dist::Zilla::Role::NameProvider::VERSION = '5.010';
use Moose::Role;
with 'Dist::Zilla::Role::Plugin';

# =head1 DESCRIPTION
# 
# Plugins implementing this role must provide a C<provide_name> method that
# will be called when setting the dist's name.
# 
# If a NameProvider offers a name but one has already been set, an
# exception will be raised.  If C<provide_name> returns undef, it will be
# ignored.
# 
# =cut

requires 'provide_name';

no Moose::Role;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::Role::NameProvider - something that provides a name for the dist

=head1 VERSION

version 5.010

=head1 DESCRIPTION

Plugins implementing this role must provide a C<provide_name> method that
will be called when setting the dist's name.

If a NameProvider offers a name but one has already been set, an
exception will be raised.  If C<provide_name> returns undef, it will be
ignored.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
