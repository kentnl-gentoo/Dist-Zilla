package Dist::Zilla::Plugin::FailTest;
our $VERSION = '1.100160';
# ABSTRACT: fake plugin to test dzil testing

use Moose;

with 'Dist::Zilla::Role::TestRunner';

sub test {
  my $self = shift;
  die '[FailTest] Emitted an Fail';
  return;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

