package Dist::Zilla::Plugin::NextRelease;
BEGIN {
  $Dist::Zilla::Plugin::NextRelease::VERSION = '2.101160';
}
# ABSTRACT: update the next release number in your changelog

use Moose;
with 'Dist::Zilla::Role::FileMunger';
with 'Dist::Zilla::Role::TextTemplate';
with 'Dist::Zilla::Role::AfterRelease';

use DateTime 0.44; # CLDR fixes
use String::Formatter 0.100680 stringf => {
  -as => '_format_version',

  input_processor => 'require_single_input',
  string_replacer => 'method_replace',
  codes => {
    v => sub { $_[0]->version },
    d => sub {
      DateTime->from_epoch(epoch => $^T, time_zone => 'local')
              ->format_cldr($_[1]),
    }
  },
};

has format => (
  is  => 'ro',
  isa => 'Str', # should be more validated Later -- rjbs, 2008-06-05
  default => '%-9v %{yyyy-MM-dd HH:mm:ss VVVV}d',
);

has filename => (
  is  => 'ro',
  isa => 'Str',
  default => 'Changes',
);

sub section_header {
  my ($self) = @_;

  return _format_version($self->format, $self->zilla);
}

sub munge_files {
  my ($self) = @_;

  my ($file) = grep { $_->name eq $self->filename } @{ $self->zilla->files };
  return unless $file;

  my $content = $self->fill_in_string(
    $file->content,
    {
      dist    => \($self->zilla),
      version => \($self->zilla->version),
      NEXT    => \($self->section_header),
    },
  );

  $self->log_debug([ 'updating contents of %s in memory', $file->name ]);
  $file->content($content);
}

# new release is part of distribution history, let's record that.
sub after_release {
  my ($self) = @_;
  my $filename = $self->filename;

  # read original changelog
  my $content = do {
    local $/;
    open my $in_fh, '<', $filename
      or Carp::croak("can't open $filename for reading: $!");
    <$in_fh>
  };

  # add the version and date to file content
  my $delim  = $self->delim;
  my $header = $self->section_header;
  $content =~ s{ (\Q$delim->[0]\E \s*) \$NEXT (\s* \Q$delim->[1]\E) }
               {$1\$NEXT$2\n\n$header}xs;

  $self->log_debug([ 'updating contents of %s on disk', $filename ]);

  # and finally rewrite the changelog on disk
  open my $out_fh, '>', $filename
    or Carp::croak("can't open $filename for writing: $!");
  print $out_fh $content or Carp::croak("error writing to $filename: $!");
  close $out_fh or Carp::croak("error closing $filename: $!");
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;


=pod

=head1 NAME

Dist::Zilla::Plugin::NextRelease - update the next release number in your changelog

=head1 VERSION

version 2.101160

=head1 SYNOPSIS

In your F<dist.ini>:

  [NextRelease]

In your F<Changes> file:

  {{$NEXT}}

=head1 DESCRIPTION

Tired of having to update your F<Changes> file by hand with the new
version and release date / time each time you release your distribution?
Well, this plugin is for you.

Add this plugin to your F<dist.ini>, and the following to your
F<Changes> file:

  {{$NEXT}}

The C<NextRelease> plugin will then do 2 things:

=over 4

=item * At build time, this special marker will be replaced with the
version and the build date, to form a standard changelog header. This
will be done to the in-memory file - the original F<Changes> file won't
be updated.

=item * After release (when running C<dzil release>), since the version
and build date are now part of your dist's history, the real F<Changes>
file (not the in-memory one) will be updated with this piece of
information.

=back

The module accepts the following options in its F<dist.ini> section:

=over 4

=item * filename - the name of your changelog file. defaults to F<Changes>.

=item * format - the date format. defaults to C<%-9v %{yyyy-MM-dd HH:mm:ss VVVV}d>.

=back

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

