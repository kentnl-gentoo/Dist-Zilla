package Dist::Zilla::Plugin::ExecDir;
BEGIN {
  $Dist::Zilla::Plugin::ExecDir::VERSION = '4.101801';
}
# ABSTRACT: install a directory's contents as executables
use Moose;

use Moose::Autobox;


has dir => (
  is   => 'ro',
  isa  => 'Str',
  default => 'bin',
);

sub find_files {
  my ($self) = @_;

  my $dir = $self->dir;
  my $files = $self->zilla->files->grep(sub { index($_->name, "$dir/") == 0 });
}

with 'Dist::Zilla::Role::ExecFiles';
__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__
=pod

=head1 NAME

Dist::Zilla::Plugin::ExecDir - install a directory's contents as executables

=head1 VERSION

version 4.101801

=head1 SYNOPSIS

In your F<dist.ini>:

  [ExecDir]
  dir = scripts

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

