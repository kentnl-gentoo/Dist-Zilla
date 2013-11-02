package Dist::Zilla::Plugin::InlineFiles;
{
  $Dist::Zilla::Plugin::InlineFiles::VERSION = '5.005';
}
# ABSTRACT: files in a data section
use Moose;
use Moose::Autobox;
with 'Dist::Zilla::Role::FileGatherer';

use namespace::autoclean;


use Sub::Exporter::ForMethods;
use Data::Section 0.200002 # encoding and bytes
  { installer => Sub::Exporter::ForMethods::method_installer },
  '-setup' => { encoding => 'bytes' };
use Dist::Zilla::File::InMemory;

sub gather_files {
  my ($self) = @_;

  my $data = $self->merged_section_data;
  return unless $data and %$data;

  for my $name (keys %$data) {
    $self->add_file(
      Dist::Zilla::File::InMemory->new({
        name    => $name,
        content => ${ $data->{$name} },
      }),
    );
  }

  return;
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Dist::Zilla::Plugin::InlineFiles - files in a data section

=head1 VERSION

version 5.005

=head1 DESCRIPTION

This plugin exists only to be extended, and gathers all files contained in its
data section and those of its ancestors.  For more information, see
L<Data::Section|Data::Section>.

=head1 SEE ALSO

Core Dist::Zilla plugins inheriting from L<InlineFiles>:
L<MetaTests|Dist::Zilla::Plugin::MetaTests>,
L<PodCoverageTests|Dist::Zilla::Plugin::PodCoverageTests>,
L<PodSyntaxTests|Dist::Zilla::Plugin::PodSyntaxTests>.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
