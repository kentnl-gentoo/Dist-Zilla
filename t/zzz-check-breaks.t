use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::CheckBreaks 0.013

use Test::More 0.88;

SKIP: {
    eval 'require Moose::Conflicts; Moose::Conflicts->check_conflicts';
    skip('no Moose::Conflicts module found', 1) if not $INC{'Moose/Conflicts.pm'};

    diag $@ if $@;
    pass 'conflicts checked via Moose::Conflicts';
}

# this data duplicates x_breaks in META.json
my $breaks = {
  "Dist::Zilla::App::Command::stale" => "< 0.040",
  "Dist::Zilla::App::Command::update" => "<= 0.04",
  "Dist::Zilla::Plugin::MakeMaker::Awesome" => "< 0.22",
  "Dist::Zilla::Plugin::Run" => "<= 0.035",
  "Dist::Zilla::Plugin::TrialVersionComment" => "<= 0.003"
};

use CPAN::Meta::Requirements;
my $reqs = CPAN::Meta::Requirements->new;
$reqs->add_string_requirement($_, $breaks->{$_}) foreach keys %$breaks;

use CPAN::Meta::Check 0.011 'check_requirements';
our $result = check_requirements($reqs, 'conflicts');

if (my @breaks = grep { defined $result->{$_} } keys %$result)
{
    diag 'Breakages found with Dist-Zilla:';
    diag "$result->{$_}" for sort @breaks;
    diag "\n", 'You should now update these modules!';
}

done_testing;
