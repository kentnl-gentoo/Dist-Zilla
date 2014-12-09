package Dist::Zilla::Plugin::PodCoverageTests;
# ABSTRACT: a release test for Pod coverage
$Dist::Zilla::Plugin::PodCoverageTests::VERSION = '5.026';
use Moose;
extends 'Dist::Zilla::Plugin::InlineFiles';
with 'Dist::Zilla::Role::PrereqSource';

use namespace::autoclean;

#pod =head1 DESCRIPTION
#pod
#pod This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
#pod following files:
#pod
#pod   xt/release/pod-coverage.t - a standard Test::Pod::Coverage test
#pod
#pod This test uses L<Pod::Coverage::TrustPod> to check your Pod coverage.  This
#pod means that to indicate that some subs should be treated as covered, even if no
#pod documentation can be found, you can add:
#pod
#pod   =for Pod::Coverage sub_name other_sub this_one_too
#pod
#pod L<Test::Pod::Coverage> C<1.08> and L<Pod::Coverage::TrustPod> will be added as
#pod C<develop requires> dependencies.
#pod
#pod =cut

# Register the release test prereq as a "develop requires"
# so it will be listed in "dzil listdeps --author"
sub register_prereqs {
  my ($self) = @_;

  $self->zilla->register_prereqs(
    {
      type  => 'requires',
      phase => 'develop',
    },
    'Test::Pod::Coverage'     => '1.08',
    'Pod::Coverage::TrustPod' => 0,
  );
}

__PACKAGE__->meta->make_immutable;
1;

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::Plugin::PodCoverageTests - a release test for Pod coverage

=head1 VERSION

version 5.026

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following files:

  xt/release/pod-coverage.t - a standard Test::Pod::Coverage test

This test uses L<Pod::Coverage::TrustPod> to check your Pod coverage.  This
means that to indicate that some subs should be treated as covered, even if no
documentation can be found, you can add:

  =for Pod::Coverage sub_name other_sub this_one_too

L<Test::Pod::Coverage> C<1.08> and L<Pod::Coverage::TrustPod> will be added as
C<develop requires> dependencies.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

__DATA__
___[ xt/release/pod-coverage.t ]___
#!perl
# This file was automatically generated by Dist::Zilla::Plugin::PodCoverageTests.

use Test::Pod::Coverage 1.08;
use Pod::Coverage::TrustPod;

all_pod_coverage_ok({ coverage_class => 'Pod::Coverage::TrustPod' });
