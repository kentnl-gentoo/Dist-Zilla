package Dist::Zilla::Role::FileFinderUser;
BEGIN {
  $Dist::Zilla::Role::FileFinderUser::VERSION = '3.101461';
}
use MooseX::Role::Parameterized;
# ABSTRACT: something that uses FileFinder plugins

parameter finder_arg_names => (
  isa => 'ArrayRef',
  default => sub { [ 'finder' ] },
);

parameter default_finders => (
  isa => 'ArrayRef',
  required => 1,
);

parameter method => (
  isa     => 'Str',
  default => 'found_files',
);

role {
  my ($p) = @_;

  my ($finder_arg, @finder_arg_aliases) = @{ $p->finder_arg_names };
  confess "no finder arg names given!" unless $finder_arg;

  around mvp_multivalue_args => sub {
    my ($orig, $self) = @_;

    my @start = $self->$orig;
    return (@start, $finder_arg);
  };

  if (@finder_arg_aliases) {
    around mvp_aliases => sub {
      my ($orig, $self) = @_;

      my $start = $self->$orig;

      for my $alias (@finder_arg_aliases) {
        confess "$alias is already an alias to $start->{$alias}"
          if exists $start->{$alias} and $orig->{$alias} ne $finder_arg;
        $start->{ $alias } = $finder_arg;
      }

      return $start;
    };
  }

  has $finder_arg => (
    is  => 'ro',
    isa => 'ArrayRef[Str]',
    default => sub { [ @{ $p->default_finders } ] },
  );

  method $p->method => sub {
    my ($self) = @_;

    my @filesets = map {; $self->zilla->find_files($_) }
                   @{ $self->$finder_arg };

    my %by_name = map {; $_->name, $_ } map { @$_ } @filesets;

    return [ values %by_name ];
  };
};

1;

__END__
=pod

=head1 NAME

Dist::Zilla::Role::FileFinderUser - something that uses FileFinder plugins

=head1 VERSION

version 3.101461

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

