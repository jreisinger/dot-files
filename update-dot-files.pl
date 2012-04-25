#!/usr/bin/env perl
# Update dot files from git repo.
# Place this script in your crontab.
use strict;
use warnings;
use File::Temp;
use File::Spec;
use File::Copy;

# clone git repo into a temporary directory
my $tmpdir = File::Temp->newdir( DIR => '/tmp' );
chdir $tmpdir;
system 'git clone git@github.com:jreisinger/dot-files.git';

# replace dot files in home dir with the repo version
chdir 'dot-files';
for my $file ( glob "*" ) {
    next if $file eq 'README';
    next if $file eq 'update-dot-files.pl';
    my $dotfile = '.' . $file;
    copy( $file, File::Spec->catfile($ENV{'HOME'}, $dotfile) );
}

# cd to homedir to allow removal of the temporary directory
chdir;
