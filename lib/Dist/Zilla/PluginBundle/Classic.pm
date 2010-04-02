package Dist::Zilla::PluginBundle::Classic;
$Dist::Zilla::PluginBundle::Classic::VERSION = '2.100920';
# ABSTRACT: build something more or less like a "classic" CPAN dist
use Moose;
use Moose::Autobox;
with 'Dist::Zilla::Role::PluginBundle';

sub bundle_config {
  my ($self, $arg) = @_;

  my @plugins = qw(
    GatherDir
    PruneCruft
    ManifestSkip
    MetaYAML
    License
    Readme
    PkgVersion
    PodVersion
    PodCoverageTests
    PodSyntaxTests
    ExtraTests
    ExecDir
    ShareDir

    MakeMaker
    Manifest

    ConfirmRelease
    UploadToCPAN
  );

  my @config;
  for (@plugins) {
    my $class = "Dist::Zilla::Plugin::$_";
    Class::MOP::load_class($class);

    push @config, [ "$arg->{name}/$_" => $class => {} ];
  }

  return @config;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;


=pod

=head1 NAME

Dist::Zilla::PluginBundle::Classic - build something more or less like a "classic" CPAN dist

=head1 VERSION

version 2.100920

=head1 DESCRIPTION

This bundle is meant to do just about everything needed for building a plain
ol' CPAN distribution in the manner of our forefathers.

It includes the following plugins with their default configuration:

=over

=item * L<Dist::Zilla::Plugin::GatherDir>

=item * L<Dist::Zilla::Plugin::PruneCruft>

=item * L<Dist::Zilla::Plugin::ManifestSkip>

=item * L<Dist::Zilla::Plugin::MetaYAML>

=item * L<Dist::Zilla::Plugin::License>

=item * L<Dist::Zilla::Plugin::Readme>

=item * L<Dist::Zilla::Plugin::PkgVersion>

=item * L<Dist::Zilla::Plugin::PodVersion>

=item * L<Dist::Zilla::Plugin::PodTests>

=item * L<Dist::Zilla::Plugin::ExtraTests>

=item * L<Dist::Zilla::Plugin::ExecDir>

=item * L<Dist::Zilla::Plugin::ShareDir>

=item * L<Dist::Zilla::Plugin::MakeMaker>

=item * L<Dist::Zilla::Plugin::Manifest>

=back

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__


