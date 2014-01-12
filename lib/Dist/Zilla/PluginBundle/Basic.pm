package Dist::Zilla::PluginBundle::Basic;
# ABSTRACT: the basic plugins to maintain and release CPAN dists
$Dist::Zilla::PluginBundle::Basic::VERSION = '5.010';
use Moose;
with 'Dist::Zilla::Role::PluginBundle::Easy';

use namespace::autoclean;

sub configure {
  my ($self) = @_;

  $self->add_plugins(qw(
    GatherDir
    PruneCruft
    ManifestSkip
    MetaYAML
    License
    Readme
    ExtraTests
    ExecDir
    ShareDir

    MakeMaker
    Manifest

    TestRelease
    ConfirmRelease
    UploadToCPAN
  ));
}

__PACKAGE__->meta->make_immutable;
1;

# =head1 DESCRIPTION
# 
# This plugin is meant to be a basic "first step" bundle for using Dist::Zilla.
# It won't munge any of your code, but will generate a F<Makefile.PL> and allows
# easy, reliable releasing of distributions.
# 
# It includes the following plugins with their default configuration:
# 
# =for :list
# * L<Dist::Zilla::Plugin::GatherDir>
# * L<Dist::Zilla::Plugin::PruneCruft>
# * L<Dist::Zilla::Plugin::ManifestSkip>
# * L<Dist::Zilla::Plugin::MetaYAML>
# * L<Dist::Zilla::Plugin::License>
# * L<Dist::Zilla::Plugin::Readme>
# * L<Dist::Zilla::Plugin::ExtraTests>
# * L<Dist::Zilla::Plugin::ExecDir>
# * L<Dist::Zilla::Plugin::ShareDir>
# * L<Dist::Zilla::Plugin::MakeMaker>
# * L<Dist::Zilla::Plugin::Manifest>
# * L<Dist::Zilla::Plugin::TestRelease>
# * L<Dist::Zilla::Plugin::ConfirmRelease>
# * L<Dist::Zilla::Plugin::UploadToCPAN>
# 
# =head1 SEE ALSO
# 
# Core Dist::Zilla plugins: L<@Filter|Dist::Zilla::PluginBundle::Filter>.
# 
# Dist::Zilla roles:
# L<PluginBundle|Dist::Zilla::Role::PluginBundle>,
# L<PluginBundle::Easy|Dist::Zilla::Role::PluginBundle::Easy>.
# 
# =cut

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::PluginBundle::Basic - the basic plugins to maintain and release CPAN dists

=head1 VERSION

version 5.010

=head1 DESCRIPTION

This plugin is meant to be a basic "first step" bundle for using Dist::Zilla.
It won't munge any of your code, but will generate a F<Makefile.PL> and allows
easy, reliable releasing of distributions.

It includes the following plugins with their default configuration:

=over 4

=item *

L<Dist::Zilla::Plugin::GatherDir>

=item *

L<Dist::Zilla::Plugin::PruneCruft>

=item *

L<Dist::Zilla::Plugin::ManifestSkip>

=item *

L<Dist::Zilla::Plugin::MetaYAML>

=item *

L<Dist::Zilla::Plugin::License>

=item *

L<Dist::Zilla::Plugin::Readme>

=item *

L<Dist::Zilla::Plugin::ExtraTests>

=item *

L<Dist::Zilla::Plugin::ExecDir>

=item *

L<Dist::Zilla::Plugin::ShareDir>

=item *

L<Dist::Zilla::Plugin::MakeMaker>

=item *

L<Dist::Zilla::Plugin::Manifest>

=item *

L<Dist::Zilla::Plugin::TestRelease>

=item *

L<Dist::Zilla::Plugin::ConfirmRelease>

=item *

L<Dist::Zilla::Plugin::UploadToCPAN>

=back

=head1 SEE ALSO

Core Dist::Zilla plugins: L<@Filter|Dist::Zilla::PluginBundle::Filter>.

Dist::Zilla roles:
L<PluginBundle|Dist::Zilla::Role::PluginBundle>,
L<PluginBundle::Easy|Dist::Zilla::Role::PluginBundle::Easy>.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
