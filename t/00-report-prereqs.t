#!perl

use strict;
use warnings;

# This test was generated by Dist::Zilla::Plugin::Test::ReportPrereqs 0.013

use Test::More tests => 1;

use ExtUtils::MakeMaker;
use File::Spec::Functions;
use List::Util qw/max/;
use version;

# hide optional CPAN::Meta modules from prereq scanner
# and check if they are available
my $cpan_meta = "CPAN::Meta";
my $cpan_meta_req = "CPAN::Meta::Requirements";
my $HAS_CPAN_META = eval "require $cpan_meta"; ## no critic
my $HAS_CPAN_META_REQ = eval "require $cpan_meta_req; $cpan_meta_req->VERSION('2.120900')";

# Verify requirements?
my $DO_VERIFY_PREREQS = 1;

sub _merge_requires {
    my ($collector, $prereqs) = @_;
    for my $phase ( qw/configure build test runtime develop/ ) {
        next unless exists $prereqs->{$phase};
        if ( my $req = $prereqs->{$phase}{'requires'} ) {
            my $cmr = CPAN::Meta::Requirements->from_string_hash( $req );
            $collector->add_requirements( $cmr );
        }
    }
}

my %include = map {; $_ => 1 } qw(

);

my %exclude = map {; $_ => 1 } qw(

);

# Add static prereqs to the included modules list
my $static_prereqs = do { my $x = {
       'configure' => {
                        'requires' => {
                                        'ExtUtils::MakeMaker' => '6.30',
                                        'File::ShareDir::Install' => '0.03'
                                      }
                      },
       'develop' => {
                      'requires' => {
                                      'Test::Pod' => '1.41'
                                    }
                    },
       'runtime' => {
                      'recommends' => {
                                        'Archive::Tar::Wrapper' => '0.15',
                                        'Term::ReadLine::Gnu' => '0'
                                      },
                      'requires' => {
                                      'App::Cmd::Command::version' => '0',
                                      'App::Cmd::Setup' => '0.309',
                                      'App::Cmd::Tester' => '0.306',
                                      'App::Cmd::Tester::CaptureExternal' => '0',
                                      'Archive::Tar' => '0',
                                      'CPAN::Meta::Converter' => '2.101550',
                                      'CPAN::Meta::Prereqs' => '2.120630',
                                      'CPAN::Meta::Requirements' => '2.121',
                                      'CPAN::Meta::Validator' => '2.101550',
                                      'CPAN::Uploader' => '0.103004',
                                      'Carp' => '0',
                                      'Class::Load' => '0.17',
                                      'Config::INI::Reader' => '0',
                                      'Config::MVP::Assembler' => '0',
                                      'Config::MVP::Assembler::WithBundles' => '0',
                                      'Config::MVP::Reader' => '2.101540',
                                      'Config::MVP::Reader::Findable::ByExtension' => '0',
                                      'Config::MVP::Reader::Finder' => '0',
                                      'Config::MVP::Reader::INI' => '2',
                                      'Config::MVP::Section' => '2.200002',
                                      'Data::Dumper' => '0',
                                      'Data::Section' => '0.200002',
                                      'DateTime' => '0.44',
                                      'Digest::MD5' => '0',
                                      'Encode' => '0',
                                      'ExtUtils::Manifest' => '1.54',
                                      'File::Copy::Recursive' => '0',
                                      'File::Find::Rule' => '0',
                                      'File::HomeDir' => '0',
                                      'File::Path' => '0',
                                      'File::ShareDir' => '0',
                                      'File::ShareDir::Install' => '0.03',
                                      'File::Spec' => '0',
                                      'File::Temp' => '0',
                                      'File::pushd' => '0',
                                      'Hash::Merge::Simple' => '0',
                                      'JSON' => '2',
                                      'List::AllUtils' => '0',
                                      'List::MoreUtils' => '0',
                                      'List::Util' => '0',
                                      'Log::Dispatchouli' => '1.102220',
                                      'Mixin::Linewise::Readers' => '0.100',
                                      'Moose' => '0.92',
                                      'Moose::Autobox' => '0.10',
                                      'Moose::Role' => '0',
                                      'Moose::Util::TypeConstraints' => '0',
                                      'MooseX::LazyRequire' => '0',
                                      'MooseX::Role::Parameterized' => '0',
                                      'MooseX::SetOnce' => '0',
                                      'MooseX::Types' => '0',
                                      'MooseX::Types::Moose' => '0',
                                      'MooseX::Types::Path::Class' => '0',
                                      'MooseX::Types::Perl' => '0',
                                      'PPI' => '0',
                                      'PPI::Document' => '0',
                                      'Params::Util' => '0',
                                      'Path::Class' => '0.22',
                                      'Path::Tiny' => '0',
                                      'Perl::PrereqScanner' => '1.016',
                                      'Perl::Version' => '0',
                                      'Pod::Eventual' => '0.091480',
                                      'Scalar::Util' => '0',
                                      'Software::License' => '0.101370',
                                      'Software::LicenseUtils' => '0',
                                      'Storable' => '0',
                                      'String::Formatter' => '0.100680',
                                      'String::RewritePrefix' => '0.005',
                                      'Sub::Exporter' => '0',
                                      'Sub::Exporter::ForMethods' => '0',
                                      'Sub::Exporter::Util' => '0',
                                      'Term::Encoding' => '0',
                                      'Term::ReadKey' => '0',
                                      'Term::ReadLine' => '0',
                                      'Term::UI' => '0',
                                      'Test::Deep' => '0',
                                      'Text::Glob' => '0.08',
                                      'Text::Template' => '0',
                                      'Try::Tiny' => '0',
                                      'YAML::Tiny' => '0',
                                      'autobox' => '2.53',
                                      'autodie' => '0',
                                      'namespace::autoclean' => '0',
                                      'parent' => '0',
                                      'perl' => 'v5.8.5',
                                      'strict' => '0',
                                      'version' => '0',
                                      'warnings' => '0'
                                    }
                    },
       'test' => {
                   'recommends' => {
                                     'CPAN::Meta' => '0',
                                     'CPAN::Meta::Requirements' => '2.120900'
                                   },
                   'requires' => {
                                   'ExtUtils::MakeMaker' => '0',
                                   'File::Spec::Functions' => '0',
                                   'Software::License::None' => '0',
                                   'Test::FailWarnings' => '0',
                                   'Test::Fatal' => '0',
                                   'Test::File::ShareDir' => '0',
                                   'Test::More' => '0.96',
                                   'lib' => '0',
                                   'utf8' => '0'
                                 }
                 }
     };
  $x;
 };

delete $static_prereqs->{develop} if not $ENV{AUTHOR_TESTING};
$include{$_} = 1 for map { keys %$_ } map { values %$_ } values %$static_prereqs;

# Merge requirements for major phases (if we can)
my $all_requires;
if ( $DO_VERIFY_PREREQS && $HAS_CPAN_META_REQ ) {
    $all_requires = $cpan_meta_req->new;
    _merge_requires($all_requires, $static_prereqs);
}


# Add dynamic prereqs to the included modules list (if we can)
my ($source) = grep { -f } 'MYMETA.json', 'MYMETA.yml';
if ( $source && $HAS_CPAN_META ) {
  if ( my $meta = eval { CPAN::Meta->load_file($source) } ) {
    my $dynamic_prereqs = $meta->prereqs;
    delete $dynamic_prereqs->{develop} if not $ENV{AUTHOR_TESTING};
    $include{$_} = 1 for map { keys %$_ } map { values %$_ } values %$dynamic_prereqs;

    if ( $DO_VERIFY_PREREQS && $HAS_CPAN_META_REQ ) {
        _merge_requires($all_requires, $dynamic_prereqs);
    }
  }
}
else {
  $source = 'static metadata';
}

my @modules = sort grep { ! $exclude{$_} } keys %include;
my @reports = [qw/Version Module/];
my @dep_errors;
my $req_hash = defined($all_requires) ? $all_requires->as_string_hash : {};

for my $mod ( @modules ) {
  next if $mod eq 'perl';
  my $file = $mod;
  $file =~ s{::}{/}g;
  $file .= ".pm";
  my ($prefix) = grep { -e catfile($_, $file) } @INC;
  if ( $prefix ) {
    my $ver = MM->parse_version( catfile($prefix, $file) );
    $ver = "undef" unless defined $ver; # Newer MM should do this anyway
    push @reports, [$ver, $mod];

    if ( $DO_VERIFY_PREREQS && $all_requires ) {
      my $req = $req_hash->{$mod};
      if ( defined $req && length $req ) {
        if ( ! defined eval { version->parse($ver) } ) {
          push @dep_errors, "$mod version '$ver' cannot be parsed (version '$req' required)";
        }
        elsif ( ! $all_requires->accepts_module( $mod => $ver ) ) {
          push @dep_errors, "$mod version '$ver' is not in required range '$req'";
        }
      }
    }

  }
  else {
    push @reports, ["missing", $mod];

    if ( $DO_VERIFY_PREREQS && $all_requires ) {
      my $req = $req_hash->{$mod};
      if ( defined $req && length $req ) {
        push @dep_errors, "$mod is not installed (version '$req' required)";
      }
    }
  }
}

if ( @reports ) {
  my $vl = max map { length $_->[0] } @reports;
  my $ml = max map { length $_->[1] } @reports;
  splice @reports, 1, 0, ["-" x $vl, "-" x $ml];
  diag "\nVersions for all modules listed in $source (including optional ones):\n",
    map {sprintf("  %*s %*s\n",$vl,$_->[0],-$ml,$_->[1])} @reports;
}

if ( @dep_errors ) {
  diag join("\n",
    "\n*** WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING ***\n",
    "The following REQUIRED prerequisites were not satisfied:\n",
    @dep_errors,
    "\n"
  );
}

pass;

# vim: ts=4 sts=4 sw=4 et: