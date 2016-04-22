package Dist::Zilla::Plugin::Manifest;
# ABSTRACT: build a MANIFEST file
$Dist::Zilla::Plugin::Manifest::VERSION = '5.046';
use Moose;
with 'Dist::Zilla::Role::FileGatherer';

use namespace::autoclean;

use Dist::Zilla::File::FromCode;

#pod =head1 DESCRIPTION
#pod
#pod If included, this plugin will produce a F<MANIFEST> file for the distribution,
#pod listing all of the files it contains.  For obvious reasons, it should be
#pod included as close to last as possible.
#pod
#pod This plugin is included in the L<@Basic|Dist::Zilla::PluginBundle::Basic>
#pod bundle.
#pod
#pod =head1 SEE ALSO
#pod
#pod Dist::Zilla core plugins:
#pod L<@Basic|Dist::Zilla::PluginBundle::Manifest>,
#pod L<ManifestSkip|Dist::Zilla::Plugin::ManifestSkip>.
#pod
#pod Other modules: L<ExtUtils::Manifest>.
#pod
#pod =cut

sub __fix_filename {
  my ($name) = @_;
  return $name unless $name =~ /[ '\\]/;
  $name =~ s/\\/\\\\/g;
  $name =~ s/'/\\'/g;
  return qq{'$name'};
}

sub gather_files {
  my ($self, $arg) = @_;

  my $zilla = $self->zilla;

  my $file = Dist::Zilla::File::FromCode->new({
    name => 'MANIFEST',
    code_return_type => 'bytes',
    code => sub {
      my $generated_by = sprintf "%s v%s", ref($self), $self->VERSION || '(dev)';

      return "# This file was automatically generated by $generated_by.\n"
           . join("\n", map { __fix_filename($_) } sort map { $_->name } @{ $zilla->files })
           . "\n",
    },
  });

  $self->add_file($file);
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::Plugin::Manifest - build a MANIFEST file

=head1 VERSION

version 5.046

=head1 DESCRIPTION

If included, this plugin will produce a F<MANIFEST> file for the distribution,
listing all of the files it contains.  For obvious reasons, it should be
included as close to last as possible.

This plugin is included in the L<@Basic|Dist::Zilla::PluginBundle::Basic>
bundle.

=head1 SEE ALSO

Dist::Zilla core plugins:
L<@Basic|Dist::Zilla::PluginBundle::Manifest>,
L<ManifestSkip|Dist::Zilla::Plugin::ManifestSkip>.

Other modules: L<ExtUtils::Manifest>.

=head1 AUTHOR

Ricardo SIGNES 🎃 <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
