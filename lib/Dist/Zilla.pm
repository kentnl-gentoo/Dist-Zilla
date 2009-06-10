package Dist::Zilla;
our $VERSION = '1.091610';

# ABSTRACT: distribution builder; installer not included!
use Moose;
use Moose::Autobox;
use Dist::Zilla::Types qw(DistName);
use MooseX::Types::Path::Class qw(Dir File);
use Moose::Util::TypeConstraints;

use File::Find::Rule;
use Path::Class ();
use Software::License;
use String::RewritePrefix;

use Dist::Zilla::File::OnDisk;
use Dist::Zilla::Role::Plugin;

use namespace::autoclean;


has 'dzil_app' => (
  is  => 'rw',
  isa => 'Dist::Zilla::App',
);


has name => (
  is   => 'ro',
  isa  => DistName,
  required => 1,
);


# XXX: *clearly* this needs to be really much smarter -- rjbs, 2008-06-01
has version => (
  is   => 'rw',
  isa  => 'Str',
  lazy => 1,
  predicate => 'has_version',
  required  => 1,
  default   => sub { die('this should never be reached') },
);

sub __initialize_version {
  my ($self) = @_;

  # Fix up version.
  my $has_version = $self->has_version;
  my $version;

  for my $plugin ($self->plugins_with(-VersionProvider)->flatten) {
    next unless defined(my $this_version = $plugin->provide_version);

    confess('attempted to set version twice') if $has_version;

    $version = $this_version;
    $has_version = 1;
  }

  $self->version($version) if defined $version;
  confess('no version was ever set') unless $self->has_version;

  $self->log("warning: version number does not look like a number")
    unless $self->version =~ m{\A\d+(?:\.\d+)\z};
}


has abstract => (
  is   => 'rw',
  isa  => 'Str',
  lazy => 1,
  required => 1,
  default  => sub {
    my ($self) = @_;

    require Dist::Zilla::Util;
    my $filename = $self->main_module->name;
    $self->log("extracting distribution abstract from $filename");
    my $abstract = Dist::Zilla::Util->abstract_from_file($filename);

    if (!defined($abstract)) {
        die "Unable to extract an abstract from $filename. Please add the following comment to the file with your abstract:
    # ABSTRACT: turns baubles into trinkets
";
    }

    return $abstract;
  }
);


has main_module => (
  is   => 'ro',
  isa  => 'Dist::Zilla::Role::File',
  lazy => 1,
  required => 1,
  default  => sub {
    my ($self) = @_;

    my $file = $self->files
             ->grep(sub { $_->name =~ m{\.pm\z} and $_->name =~ m{\Alib/} })
             ->sort(sub { length $_[0]->name <=> length $_[1]->name })
             ->head;

    $self->log("guessing dist's main_module is " . $file->name);

    return $file;
  },
);


has copyright_holder => (
  is   => 'ro',
  isa  => 'Str',
  required => 1,
);


has copyright_year => (
  is   => 'ro',
  isa  => 'Int',

  # Oh man.  This is a terrible idea!  I mean, what if by the code gets run
  # around like Dec 31, 23:59:59.9 and by the time the default gets called it's
  # the next year but the default was already set up?  Oh man.  That could ruin
  # lives!  I guess we could make this a sub to defer the guess, but think of
  # the performance hit!  I guess we'll have to suffer through this until we
  # can optimize the code to not take .1s to run, right? -- rjbs, 2008-06-13
  default => (localtime)[5] + 1900,
);


has _license_class => (is => 'rw');

has license => (
  is   => 'ro',
  isa  => 'Software::License',
  lazy => 1,
  required => 1,
  default  => sub {
    my ($self) = @_;
    my $license_class = $self->_license_class;

    unless ($license_class) {
      require Software::LicenseUtils;
      my @guess = Software::LicenseUtils->guess_license_from_pod(
        $self->main_module->content
      );

      Carp::confess("couldn't make a good guess at license") if @guess != 1;

      my $filename = $self->main_module->name;
      $license_class = $guess[0];
      $self->log("based on POD in $filename, guessing license is $guess[0]");
    }

    my $license = $license_class->new({
      holder => $self->copyright_holder,
      year   => $self->copyright_year,
    });
  },
);


has authors => (
  is   => 'ro',
  isa  => 'ArrayRef[Str]',
  lazy => 1,
  required => 1,
  default  => sub { [ $_[0]->copyright_holder ] },
);


has files => (
  is   => 'ro',
  isa  => 'ArrayRef[Dist::Zilla::Role::File]',
  lazy => 1,
  init_arg => undef,
  default  => sub { [] },
);


has root => (
  is   => 'ro',
  isa  => Dir,
  coerce   => 1,
  required => 1,
);


has plugins => (
  is   => 'ro',
  isa  => 'ArrayRef[Dist::Zilla::Role::Plugin]',
  default => sub { [ ] },
);


has built_in => (
  is   => 'rw',
  isa  => Dir,
  init_arg  => undef,
);


sub prereq {
  my ($self) = @_;

  # XXX: This needs to always include the highest version. -- rjbs, 2008-06-01
  my $prereq = {};
  $prereq = $prereq->merge( $_->prereq )
    for $self->plugins_with(-FixedPrereqs)->flatten;

  return $prereq;
}


sub from_config {
  my ($class, $arg) = @_;
  $arg ||= {};

  my $config_class = $arg->{config_class} || 'Dist::Zilla::Config::INI';
  unless (eval "require $config_class; 1") {
    die "couldn't load $config_class: $@"; ## no critic Carp
  }

  my $root = Path::Class::dir($arg->{dist_root} || '.');

  my $config_file = $root->file( $config_class->default_filename );
  $class->log("reading configuration from $config_file using $config_class");

  my $config = $config_class->new->read_file($config_file);

  my $plugins = delete $config->{plugins};

  my $license_name = delete $config->{license} unless ref $config->{license};

  my $self = $class->new($config->merge({ root => $root }));

  if ($license_name) {
    my $license_class = String::RewritePrefix->rewrite(
      {
        '=' => '',
        ''  => 'Software::License::'
      },
      $license_name,
    );

    eval "require $license_class; 1" or die;
    $self->_license_class($license_class);
  }

  for my $plugin (@$plugins) {
    my ($plugin_class, $arg) = @$plugin;
    $self->log("initializing plugin $arg->{'=name'} ($plugin_class)");
    $self->plugins->push(
      $plugin_class->new( $arg->merge({ zilla => $self }) )
    );
  }

  $self->__initialize_version;

  return $self;
}


sub plugins_with {
  my ($self, $role) = @_;

  $role =~ s/^-/Dist::Zilla::Role::/;
  my $plugins = $self->plugins->grep(sub { $_->does($role) });

  return $plugins;
}


sub build_in {
  my ($self, $root) = @_;

  Carp::confess("attempted to build " . $self->name . " a second time")
    if $self->built_in;

  $_->before_build for $self->plugins_with(-BeforeBuild)->flatten;

  my $build_root = $self->_prep_build_root($root);

  $self->log("beginning to build " . $self->name . " in $build_root");

  $_->gather_files    for $self->plugins_with(-FileGatherer)->flatten;
  $_->prune_files     for $self->plugins_with(-FilePruner)->flatten;
  $_->munge_files     for $self->plugins_with(-FileMunger)->flatten;
  $_->setup_installer for $self->plugins_with(-InstallTool)->flatten;

  $self->_check_dupe_files;

  for my $file ($self->files->flatten) {
    $self->_write_out_file($file, $build_root);
  }

  $_->after_build({ build_root => $build_root })
    for $self->plugins_with(-AfterBuild)->flatten;

  $self->built_in($build_root);
}


sub ensure_built_in {
  my ($self, $root) = @_;

  # $root ||= $self->name . q{-} . $self->version;
  return if $self->built_in and 
    (!$root or ($self->built_in eq $root));

  Carp::croak("dist is already built, but not in $root") if $self->built_in;
  $self->build_in($root);
}


sub build_archive {
  my ($self, $root) = @_;
  
  $self->ensure_built_in($root);

  require Archive::Tar;
  my $archive = Archive::Tar->new;
  my $built_in = $self->built_in;

  my %seen_dir;

  for my $file ($self->files->flatten) {
    my $in = Path::Class::file($file->name)->dir;
    $archive->add_files( $built_in->subdir($in) ) unless $seen_dir{ $in }++;
    $archive->add_files( $built_in->file( $file->name ) );
  }

  ## no critic
  my $file = Path::Class::file($self->name . '-' . $self->version . '.tar.gz');

  $self->log("writing archive to $file");
  $archive->write("$file", 9);

  return $file;
}

sub _check_dupe_files {
  my ($self) = @_;

  my %files_named;
  for my $file ($self->files->flatten) {
    ($files_named{ $file->name} ||= [])->push($file);
  }

  return unless
    my @dupes = grep { $files_named{$_}->length > 1 } keys %files_named;

  for my $name (@dupes) {
    warn "attempt to add $name multiple times; added by: "
       . join('; ', map { $_->added_by } @{ $files_named{ $name } }) . "\n";
  }

  Carp::croak("aborting; duplicate files would be produced");
}

sub _prep_build_root {
  my ($self, $build_root) = @_;

  my $default_name = $self->name . q{-} . $self->version;
  $build_root = Path::Class::dir($build_root || $default_name);

  $build_root->mkpath unless -d $build_root;

  my $dist_root = $self->root;

  $build_root->rmtree if -d $build_root;

  return $build_root;
}

sub _write_out_file {
  my ($self, $file, $build_root) = @_;

  # Okay, this is a bit much, until we have ->debug. -- rjbs, 2008-06-13
  # $self->log("writing out " . $file->name);

  my $file_path = Path::Class::file($file->name);

  my $to_dir = $build_root->subdir( $file_path->dir );
  my $to = $to_dir->file( $file_path->basename );
  $to_dir->mkpath unless -e $to_dir;
  die "not a directory: $to_dir" unless -d $to_dir;

  Carp::croak("attempted to write $to multiple times") if -e $to;

  open my $out_fh, '>', "$to" or die "couldn't open $to to write: $!";
  print { $out_fh } $file->content;
  close $out_fh or die "error closing $to: $!";
}


sub test { die '...' }


sub release { die '...' }


# XXX: yeah, uh, do something more awesome -- rjbs, 2008-06-01
sub log { ## no critic
  my ($self, $msg) = @_;
  require Dist::Zilla::Util;
  Dist::Zilla::Util->_log($msg);
}

__PACKAGE__->meta->make_immutable;
1;



=pod

=head1 NAME

Dist::Zilla - distribution builder; installer not included!

=head1 VERSION

version 1.091610

=head1 DESCRIPTION

Dist::Zilla builds distributions of code to be uploaded to the CPAN.  In this
respect, it is like L<ExtUtils::MakeMaker>, L<Module::Build>, or
L<Module::Install>.  Unlike those tools, however, it is not also a system for
installing code that has been downloaded from the CPAN.  Since it's only run by
authors, and is meant to be run on a repository checkout rather than on
published, released code, it can do much more than those tools, and is free to
make much more ludicrous demands in terms of prerequisites.

For more information, see L<Dist::Zilla::Tutorial>.

=head1 ATTRIBUTES

=head2 dzil_app

This attribute (which is optional) will provide the Dist::Zilla::App object if
the Dist::Zilla object is being used in the context of the F<dzil> command (or
anything else using it through Dist::Zilla::App).

=head2 name

The name attribute (which is required) gives the name of the distribution to be
built.  This is usually the name of the distribution's main module, with the
double colons (C<::>) replaced with dashes.  For example: C<Dist-Zilla>.

=head2 version

This is the version of the distribution to be created.

=head2 abstract

This is a one-line summary of the distribution.  If none is given, one will be
looked for in the L</main_module> of the dist.

=head2 main_module

This is the module where Dist::Zilla might look for various defaults, like
the distribution abstract.  By default, it's the shorted-named module in the
distribution.  This is likely to change!

=head2 copyright_holder

This is the name of the legal entity who holds the copyright on this code.
This is a required attribute with no default!

=head2 copyright_year

This is the year of copyright for the dist.  By default, it's this year.

=head2 license

This is the L<Software::License|Software::License> object for this dist's
license.  It will be created automatically, if possible, with the
C<copyright_holder> and C<copyright_year> attributes.  If necessary, it will
try to guess the license from the POD of the dist's main module.

A better option is to set the C<license> name in the dist's config to something
understandable, like C<Perl_5>.

=head2 authors

This is an arrayref of author strings, like this:

  [
    'Ricardo Signes <rjbs@cpan.org>',
    'X. Ample, Jr <example@example.biz>',
  ]

This is likely to change at some point in the near future.

=head2 files

This is an arrayref of objects implementing L<Dist::Zilla::Role::File> that
will, if left in this arrayref, be built into the dist.

=head2 root

This is the root directory of the dist, as a L<Path::Class::Dir>.  It will
nearly always be the current working directory in which C<dzil> was run.

=head2 plugins

This is an arrayref of plugins that have been plugged into this Dist::Zilla
object.

=head2 built_in

This is the L<Path::Class::Dir>, if any, in which the dist has been built.

=head2 prereq

This is a hashref of module prerequisites.  This attribute is likely to get
greatly overhauled, or possibly replaced with a method based on other
(private?) attributes.

=head1 METHODS

=head2 from_config

  my $zilla = Dist::Zilla->from_config(\%arg);

This routine returns a new Zilla from the configuration in the current working
directory.

Valid arguments are:

  config_class - the class to use to read the config
                 default: Dist::Zilla::Config::INI

=head2 plugins_with

  my $roles = $zilla->plugins_with( -SomeRole );

This method returns an arrayref containing all the Dist::Zilla object's plugins
that perform a the named role.  If the given role name begins with a dash, the
dash is replaced with "Dist::Zilla::Role::"

=head2 build_in

  $zilla->build_in($root);

This method builds the distribution in the given directory.  If no directory
name is given, it defaults to DistName-Version.  If the distribution has
already been built, an exception will be thrown.

=head2 ensure_built_in

  $zilla->ensure_built_in($root);

This method behaves like C<L</build_in>>, but if the dist is already built in
C<$root> (or the default root, if no root is given), no exception is raised.

=head2 build_archive

  $dist->build_archive($root);

This method will ensure that the dist has been built in the given root, and
will then build a tarball of that directory in the current directory.

=head2 test

  $zilla->test;

This method builds a new copy of the distribution and tests it.  If the tests
appear to pass, it returns true.  If something goes wrong, it returns false.

=head2 release

  $zilla->release;

This method releases the distribution, probably by uploading it to the CPAN.
The actual effects of this method (as with most of the methods) is determined
by the loaded plugins.

=head2 log

  $zilla->log($message);

This method logs the given message.  In the future it will be a more useful and
expressive method.  For now, it just prints the string after tacking on a
newline.

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 



__END__
