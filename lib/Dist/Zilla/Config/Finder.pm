package Dist::Zilla::Config::Finder;
our $VERSION = '1.100650';
use Moose;
extends 'Config::MVP::Reader::Finder';
with 'Dist::Zilla::Config';
# ABSTRACT: the reader for dist.ini files

use Dist::Zilla::Util::MVPAssembler;

sub default_search_path {
  return qw(Dist::Zilla::Config Config::MVP::Reader);
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__
=pod

=head1 NAME

Dist::Zilla::Config::Finder - the reader for dist.ini files

=head1 VERSION

version 1.100650

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

