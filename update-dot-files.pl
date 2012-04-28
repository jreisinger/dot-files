#!/usr/bin/env perl
# Update dot files from git repo. Place this script in ~/bin for manual usage,
# or in ~/scripts and to your crontab, for automatic usage:
#   */5 * * * * /home/jreisinger/scripts/update-dot-files.pl > /dev/null
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
print "\nDOT FILES\n";
for my $file ( glob "*" ) {
    next if $file eq 'README';
    next if $file eq 'update-dot-files.pl';
    my $dotfile = '.' . $file;
    copy( $file, File::Spec->catfile($ENV{'HOME'}, $dotfile) ) and
        print "=> $file copied\n";
}

# cd to homedir to allow removal of the temporary directory
chdir;
