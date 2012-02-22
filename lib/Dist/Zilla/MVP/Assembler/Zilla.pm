package Dist::Zilla::MVP::Assembler::Zilla;
{
  $Dist::Zilla::MVP::Assembler::Zilla::VERSION = '4.300009';
}
use Moose;
extends 'Dist::Zilla::MVP::Assembler';
# ABSTRACT: Dist::Zilla::MVP::Assembler for the Dist::Zilla object

use namespace::autoclean;


use MooseX::Types::Perl qw(PackageName);
use Dist::Zilla::MVP::RootSection;

sub BUILD {
  my ($self) = @_;

  my $root = Dist::Zilla::MVP::RootSection->new;
  $self->sequence->add_section($root);
}

has zilla_class => (
  is       => 'ro',
  isa      => PackageName,
  required => 1
);


sub zilla {
  my ($self) = @_;
  $self->sequence->section_named('_')->zilla;
}


sub register_stash {
  my ($self, $name, $object) = @_;
  $self->log_fatal("tried to register $name stash entry twice")
    if $self->zilla->_local_stashes->{ $name };

  $self->zilla->_local_stashes->{ $name } = $object;
  return;
}

__PACKAGE__->meta->make_immutable;
1;

__END__
=pod

=head1 NAME

Dist::Zilla::MVP::Assembler::Zilla - Dist::Zilla::MVP::Assembler for the Dist::Zilla object

=head1 VERSION

version 4.300009

=head1 OVERVIEW

This is a subclass of L<Dist::Zilla::MVP::Assembler> used when assembling the
Dist::Zilla object.

It has a C<zilla_class> attribute, which is used to determine what class of
Dist::Zilla object to create.  (This isn't very useful now, but will be in the
future when minting and building use different subclasses of Dist::Zilla.)

Upon construction, the assembler will create a L<Dist::Zilla::MVP::RootSection>
as the initial section.

=head1 METHODS

=head2 zilla

This method is a shortcut for retrieving the C<zilla> from the root section.
If called before that section has been finalized, it will result in an
exception.

=head2 register_stash

  $assembler->register_stash($name => $stash_object);

This adds a stash to the assembler's zilla's stash registry -- unless the name
is already taken, in which case an exception is raised.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

