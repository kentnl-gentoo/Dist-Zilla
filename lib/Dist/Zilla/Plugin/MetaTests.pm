package Dist::Zilla::Plugin::MetaTests;
# ABSTRACT: common extra tests for META.yml
$Dist::Zilla::Plugin::MetaTests::VERSION = '5.018';
use Moose;
extends 'Dist::Zilla::Plugin::InlineFiles';
with 'Dist::Zilla::Role::PrereqSource';

use namespace::autoclean;

#pod =head1 DESCRIPTION
#pod
#pod This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
#pod following files:
#pod
#pod   xt/release/meta-yaml.t - a standard Test::CPAN::Meta test
#pod
#pod Note that this test doesn't actually do anything unless you have
#pod L<Test::CPAN::Meta> installed.
#pod
#pod L<Test::CPAN::Meta> will be added as a C<develop requires> dependency.
#pod
#pod =head1 SEE ALSO
#pod
#pod Core Dist::Zilla plugins:
#pod L<MetaResources|Dist::Zilla::Plugin::MetaResources>,
#pod L<MetaNoIndex|Dist::Zilla::Plugin::MetaNoIndex>,
#pod L<MetaYAML|Dist::Zilla::Plugin::MetaYAML>,
#pod L<MetaJSON|Dist::Zilla::Plugin::MetaJSON>,
#pod L<MetaConfig|Dist::Zilla::Plugin::MetaConfig>.
#pod
#pod =cut

# Register the release test prereq as a "develop requires"
# so it will be listed in "dzil listdeps --author"
sub register_prereqs {
  my ($self) = @_;

  $self->zilla->register_prereqs(
    {
      phase => 'develop', type  => 'requires',
    },
    'Test::CPAN::Meta'     => 0,
  );
}

__PACKAGE__->meta->make_immutable;
1;

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::Plugin::MetaTests - common extra tests for META.yml

=head1 VERSION

version 5.018

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following files:

  xt/release/meta-yaml.t - a standard Test::CPAN::Meta test

Note that this test doesn't actually do anything unless you have
L<Test::CPAN::Meta> installed.

L<Test::CPAN::Meta> will be added as a C<develop requires> dependency.

=head1 SEE ALSO

Core Dist::Zilla plugins:
L<MetaResources|Dist::Zilla::Plugin::MetaResources>,
L<MetaNoIndex|Dist::Zilla::Plugin::MetaNoIndex>,
L<MetaYAML|Dist::Zilla::Plugin::MetaYAML>,
L<MetaJSON|Dist::Zilla::Plugin::MetaJSON>,
L<MetaConfig|Dist::Zilla::Plugin::MetaConfig>.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

__DATA__
___[ xt/release/distmeta.t ]___
#!perl
# This file was automatically generated by Dist::Zilla::Plugin::MetaTests.

use Test::CPAN::Meta;

meta_yaml_ok();
