package Dist::Zilla::Role::PluginBundle;
BEGIN {
  $Dist::Zilla::Role::PluginBundle::VERSION = '2.101040';
}
# ABSTRACT: something that bundles a bunch of plugins
use Moose::Role;


requires 'bundle_config';

no Moose::Role;
1;

__END__
=pod

=head1 NAME

Dist::Zilla::Role::PluginBundle - something that bundles a bunch of plugins

=head1 VERSION

version 2.101040

=head1 DESCRIPTION

When loading configuration, if the config reader encounters a PluginBundle, it
will replace its place in the plugin list with the result of calling its
C<bundle_config> method, which will be passed a Config::MVP::Section to
configure the bundle.

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

