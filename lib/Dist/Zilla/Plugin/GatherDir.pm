package Dist::Zilla::Plugin::GatherDir;
BEGIN {
  $Dist::Zilla::Plugin::GatherDir::VERSION = '4.101880';
}
# ABSTRACT: gather all the files in a directory
use Moose;
use Moose::Autobox;
use MooseX::Types::Path::Class qw(Dir File);
with 'Dist::Zilla::Role::FileGatherer';


use File::Find::Rule;
use File::HomeDir;
use File::Spec;
use Path::Class;

use namespace::autoclean;


has root => (
  is   => 'ro',
  isa  => Dir,
  lazy => 1,
  coerce   => 1,
  required => 1,
  default  => sub { shift->zilla->root },
);


has prefix => (
  is  => 'ro',
  isa => 'Str',
  default => '',
);


has include_dotfiles => (
  is  => 'ro',
  isa => 'Bool',
  default => 0,
);

sub gather_files {
  my ($self) = @_;

  my $root = "" . $self->root;
  $root =~ s{^~([\\/])}{File::HomeDir->my_home . $1}e;
  $root = Path::Class::dir($root);

  my @files;
  FILE: for my $filename (File::Find::Rule->file->in($root)) {
    unless ($self->include_dotfiles) {
      my $file = file($filename)->relative($root);
      next FILE if $file->basename =~ qr/^\./;
      next FILE if grep { /^\.[^.]/ } $file->dir->dir_list;
    }

    push @files, $self->_file_from_filename($filename);
  }

  for my $file (@files) {
    (my $newname = $file->name) =~ s{\A\Q$root\E[\\/]}{}g;
    $newname = File::Spec->catdir($self->prefix, $newname) if $self->prefix;
    $newname = Path::Class::dir($newname)->as_foreign('Unix')->stringify;

    $file->name($newname);
    $self->add_file($file);
  }

  return;
}

sub _file_from_filename {
  my ($self, $filename) = @_;

  return Dist::Zilla::File::OnDisk->new({
    name => $filename,
    mode => (stat $filename)[2] & 0755, # kill world-writeability
  });
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__
=pod

=head1 NAME

Dist::Zilla::Plugin::GatherDir - gather all the files in a directory

=head1 VERSION

version 4.101880

=head1 DESCRIPTION

This is a very, very simple L<FileGatherer|Dist::Zilla::Role::FileGatherer>
plugin.  It looks in the directory named in the L</root> attribute and adds all
the files it finds there.  If the root begins with a tilde, the tilde is
replaced with the current user's home directory according to L<File::HomeDir>.

Almost every dist will be built with one GatherDir plugin, since it's the
easiest way to get files from disk into your dist.  Most users just need:

  [GatherDir]

...and this will pick up all the files from the current directory into the
dist.  You can use it multiple times, as you can any other plugin, by providing
a plugin name.  For example, if you want to include external specification
files into a subdir of your dist, you might write:

  [GatherDir]
  ; this plugin needs no config and gathers most of your files

  [GatherDir / SpecFiles]
  ; this plugin gets all the files in the root dir and adds them under ./spec
  root   = ~/projects/my-project/spec
  prefix = spec

=head1 ATTRIBUTES

=head2 root

This is the directory in which to look for files.  If not given, it defaults to
the dist root -- generally, the place where your F<dist.ini> or other
configuration file is located.

=head2 prefix

This parameter can be set to gather all the files found under a common
directory.  See the L<description|DESCRIPTION> above for an example.

=head2 include_dotfiles

By default, files will not be included if they begin with a dot.  This goes
both for files and for directories relative to the C<root>.

In almost all cases, the default value (false) is correct.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

