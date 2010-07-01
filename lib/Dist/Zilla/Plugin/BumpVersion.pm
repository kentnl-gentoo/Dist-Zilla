package Dist::Zilla::Plugin::BumpVersion;
BEGIN {
  $Dist::Zilla::Plugin::BumpVersion::VERSION = '4.101812';
}
# ABSTRACT: bump the configured version number by one before building
use Moose;
with 'Dist::Zilla::Role::BeforeBuild';


sub before_build {
  my ($self) = @_;

  require Perl::Version;

  my $version = Perl::Version->new( $self->zilla->version );

  my ($r, $v, $s, $a) = map { scalar $version->$_ }
                        qw(revision version subversion alpha);

  my $method = $a > 0     ? 'inc_alpha'
             : defined $s ? 'inc_subversion'
             : defined $v ? 'inc_version'
             :              'inc_revision';

  $version->$method;

  $self->zilla->version("$version");
}

before register_component => sub {
  warn "!!! $_[0] will be removed in Dist::Zilla v5; remove it from your config\n";
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__
=pod

=head1 NAME

Dist::Zilla::Plugin::BumpVersion - bump the configured version number by one before building

=head1 VERSION

version 4.101812

=head1 SYNOPSIS

B<WARNING>  This plugin is deprecated and will be removed.  It is generally
useless.

If loaded, this plugin will ensure that the distribution's version number is
bumped up by one (in the smallest already-defined version units) before
building begins.  In other words, if F<dist.ini>'s version reads C<0.002> then
the newly built dist will be C<0.003>.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

