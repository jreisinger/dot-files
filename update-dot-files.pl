#!/usr/bin/env perl
# Update dot files from git repo. Place this script in ~/bin for manual usage,
# or in ~/scripts and to your crontab, for automatic usage:
#   */5 * * * * /home/jreisinger/scripts/update-dot-files.pl > /dev/null
use strict;
use warnings;
use File::Temp;
use File::Spec;
use File::Copy;
use 5.010;

# clone git repo into a temporary directory
my $tmpdir = File::Temp->newdir( DIR => '/tmp' );
chdir $tmpdir;
system 'git clone git@github.com:jreisinger/dot-files.git';

# get the dot files
chdir 'dot-files';
my @dot_files;
for my $file ( glob "*" ) {
    next if $file eq 'README' or $file eq 'update-dot-files.pl';
    push @dot_files, $file;
}

print "@dot_files";

my $os = $^O;
given ( $os ) {
    when( $os eq 'cygwin' ) {
        @dot_files = grep $_ =~ /^_|^cygwin/, @dot_files;
        print @dot_files;
        continue;
    }
}


# replace dot files in home dir with the repo version
sub copy_dot_files {
    my @dot_files = @_;

    for my $file ( @dot_files ) {
        my $dotfile = '.' . $file;
        copy( $file, File::Spec->catfile($ENV{'HOME'}, $dotfile) ) and
            print "=> $file copied\n";
    }
}

# cd to homedir to allow removal of the temporary directory
chdir;
