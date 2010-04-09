use strict;
use warnings;
package Dist::Zilla::App::Command::nop;
# ABSTRACT: initialize dzil, then exit
use Dist::Zilla::App -command;


sub abstract { 'do nothing: initialize dzil, then exit' }

sub opt_spec {
}

sub execute {
  my ($self, $opt, $arg) = @_;

  $self->zilla;
}

1;

__END__
=pod

=head1 NAME

Dist::Zilla::App::Command::nop - initialize dzil, then exit

=head1 VERSION

version 2.100990

=head1 SYNOPSIS

This command does nothing.  It initializes Dist::Zill, then exits.  This is
useful to see the logging output of plugin initialization.

    dzil nop -v

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

