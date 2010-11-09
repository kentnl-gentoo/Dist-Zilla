package Dist::Zilla::Role::MintingProfile::ShareDir;
BEGIN {
  $Dist::Zilla::Role::MintingProfile::ShareDir::VERSION = '4.102343';
}
# ABSTRACT: something that keeps its minting profile in a sharedir
use Moose::Role;
with 'Dist::Zilla::Role::MintingProfile';

use File::ShareDir;
use Path::Class;


sub profile_dir {
  my ($self, $profile_name) = @_;

  my $profile_dir = dir( File::ShareDir::module_dir($self->meta->name) )
                  ->subdir( $profile_name );

  return $profile_dir if -d $profile_dir;

  confess "Can't find profile $profile_name via $self";
}

no Moose::Role;
1;

__END__
=pod

=head1 NAME

Dist::Zilla::Role::MintingProfile::ShareDir - something that keeps its minting profile in a sharedir

=head1 VERSION

version 4.102343

=head1 DESCRIPTION

This role includes L<Dist::Zilla::Role::MintingProfile>, providing a
C<profile_dir> method that looks in the I<module>'s L<ShareDir|File::ShareDir>.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

