use strict;
use warnings;
package Dist::Zilla::App::Command::add;
# ABSTRACT: add a module to a dist
$Dist::Zilla::App::Command::add::VERSION = '5.037';
use Dist::Zilla::App -command;

#pod =head1 SYNOPSIS
#pod
#pod Adds a new module to a Dist::Zilla-based distribution
#pod
#pod   $ dzil add Some::New::Module
#pod
#pod There are two arguments, C<-p> and C<-P>. C<-P> specify the minting profile
#pod provider and C<-p> - the profile name. These work just like C<dzil new>.
#pod
#pod =cut

sub abstract { 'add modules to an existing dist' }

sub usage_desc { '%c %o <ModuleName>' }

sub opt_spec {
  [ 'profile|p=s',  'name of the profile to use',
    { default => 'default' }  ],

  [ 'provider|P=s', 'name of the profile provider to use',
    { default => 'Default' }  ],

  # [ 'module|m=s@', 'module(s) to create; may be given many times'         ],
}

sub validate_args {
  my ($self, $opt, $args) = @_;

  require MooseX::Types::Perl;

  $self->usage_error('dzil add takes one or more arguments') if @$args < 1;

  for my $name ( @$args ) {
    $self->usage_error("$name is not a valid module name")
      unless MooseX::Types::Perl::is_ModuleName($name);
  }
}

sub execute {
  my ($self, $opt, $arg) = @_;

  my $zilla = $self->zilla;
  my $dist = $zilla->name;

  require Path::Class;
  require File::pushd;

  require Dist::Zilla::Dist::Minter;
  my $minter = Dist::Zilla::Dist::Minter->_new_from_profile(
    [ $opt->provider, $opt->profile ],
    {
      chrome  => $self->app->chrome,
      name    => $dist,
      _global_stashes => $self->app->_build_global_stashes,
    },
  );

  my $root = Path::Class::dir($zilla->root)->absolute;
  my $wd = File::pushd::pushd($minter->root);

  my $factory = $minter->plugin_named(':DefaultModuleMaker');

  for my $name ( @$arg ) {
    $factory->make_module({ name => $name });
  }

  for my $file ( @{ $factory->zilla->files} ) {
    $zilla->_write_out_file($file, $root);
  }
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::App::Command::add - add a module to a dist

=head1 VERSION

version 5.037

=head1 SYNOPSIS

Adds a new module to a Dist::Zilla-based distribution

  $ dzil add Some::New::Module

There are two arguments, C<-p> and C<-P>. C<-P> specify the minting profile
provider and C<-p> - the profile name. These work just like C<dzil new>.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
