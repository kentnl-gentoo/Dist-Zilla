package Dist::Zilla::App::Tester;
our $VERSION = '1.100710';
use base 'App::Cmd::Tester';
use App::Cmd::Tester 0.306 (); # result_class, ->app

use Dist::Zilla::App;
use File::Copy::Recursive qw(dircopy);
use File::chdir;
use File::Spec;
use File::Temp;
use Path::Class;

use Sub::Exporter::Util ();
use Sub::Exporter -setup => {
  exports => [ test_dzil => Sub::Exporter::Util::curry_method() ],
  groups  => [ default   => [ qw(test_dzil) ] ],
};

sub result_class { 'Dist::Zilla::App::Tester::Result' }

sub test_dzil {
  my ($self, $source, $argv, $arg) = @_;
  $arg ||= {};

  local @INC = map {; File::Spec->rel2abs($_) } @INC;

  my $tmpdir = $arg->{tempdir} || File::Temp::tempdir(CLEANUP => 1);
  my $root   = dir($tmpdir)->subdir('source');
  $root->mkpath;

  dircopy($source, $root);

  local $CWD = $root;

  my $result = $self->test_app('Dist::Zilla::App' => $argv);
  $result->{tempdir} = $tempdir;

  return $result;
}

{
  package Dist::Zilla::App::Tester::Result;
our $VERSION = '1.100710';
  BEGIN { our @ISA = qw(App::Cmd::Tester::Result); }

  sub tempdir {
    my ($self) = @_;
    return $self->{tempdir};
  }

  sub zilla {
    my ($self) = @_;
    return $self->app->zilla;
  }

  sub build_dir {
    my ($self) = @_;
    return $self->zilla->built_in;
  }

  sub clear_log_events {
    my ($self) = @_;
    $self->app->zilla->logger->logger->clear_events;
  }

  sub log_events {
    my ($self) = @_;
    $self->app->zilla->logger->logger->events;
  }
}


1;

__END__
=pod

=head1 NAME

Dist::Zilla::App::Tester

=head1 VERSION

version 1.100710

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

