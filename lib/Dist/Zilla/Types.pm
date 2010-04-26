package Dist::Zilla::Types;
BEGIN {
  $Dist::Zilla::Types::VERSION = '2.101151';
}
# ABSTRACT: dzil-specific type library

use MooseX::Types -declare => [qw(DistName License VersionStr)];
use MooseX::Types::Moose qw(Str);

use version 0.82;

subtype DistName,
  as Str,
  where { !/::/ },
  message { "$_ looks like a module name, not a dist name" };

subtype License,
  as class_type('Software::License');

subtype VersionStr,
  as Str,
  where { version::is_lax($_) },
  message { "$_ is not a valid version string" };

1;

__END__
=pod

=head1 NAME

Dist::Zilla::Types - dzil-specific type library

=head1 VERSION

version 2.101151

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

