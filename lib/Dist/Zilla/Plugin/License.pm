package Dist::Zilla::Plugin::License;
{
  $Dist::Zilla::Plugin::License::VERSION = '5.004';
}
# ABSTRACT: output a LICENSE file
use Moose;
with 'Dist::Zilla::Role::FileGatherer';

use namespace::autoclean;


use Dist::Zilla::File::InMemory;

sub gather_files {
  my ($self, $arg) = @_;

  my $file = Dist::Zilla::File::InMemory->new({
    name    => 'LICENSE',
    content => $self->zilla->license->fulltext,
  });

  $self->add_file($file);
  return;
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Dist::Zilla::Plugin::License - output a LICENSE file

=head1 VERSION

version 5.004

=head1 DESCRIPTION

This plugin adds a F<LICENSE> file containing the full text of the
distribution's license, as produced by the C<fulltext> method of the
dist's L<Software::License> object.

=head1 SEE ALSO

=over 4

=item *

the C<license> attribute of the L<Dist::Zilla> object to select the license
to use.

=item *

Dist::Zilla roles:
L<FileGatherer|Dist::Zilla::Role::FileGatherer>.

=item *

Other modules:
L<Software::License>,
L<Software::License::Artistic_2_0>.

=back

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
