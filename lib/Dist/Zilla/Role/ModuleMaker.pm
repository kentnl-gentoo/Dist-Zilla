package Dist::Zilla::Role::ModuleMaker;
BEGIN {
  $Dist::Zilla::Role::ModuleMaker::VERSION = '4.102341';
}
# ABSTRACT: something that injects module files into the dist
use Moose::Role;
with qw(
  Dist::Zilla::Role::Plugin
  Dist::Zilla::Role::FileInjector
);


requires 'make_module';

no Moose::Role;
1;

__END__
=pod

=head1 NAME

Dist::Zilla::Role::ModuleMaker - something that injects module files into the dist

=head1 VERSION

version 4.102341

=head1 DESCRIPTION

Plugins implementing this role have their C<make_module> method called for each
module requesting creation by the plugin with this name.  It is passed a
hashref with the following data:

  name - the name of the module to make (a MooseX::Types::Perl::ModuleName)

Classes composing this role also compose
L<FileInjector|Dist::Zilla::Role::FileInjector> and are expected to inject a
file for the module being created.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

