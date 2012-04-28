#!/usr/bin/env perl
# Update dot files from git repo. Place this script in ~/bin for manual usage,
# or in ~/scripts and to your crontab, for automatic usage:
#   */5 * * * * /home/jreisinger/scripts/update-dot-files.pl > /dev/null
use strict;
use warnings;
use File::Temp;
use File::Spec;
use File::Copy;

sub get_dot_files {

    # get the dot files
    chdir 'dot-files';
    my @dot_files;
    for my $file ( glob "*" ) {
        next if $file eq 'README';
        next if $file eq 'update-dot-files.pl';
        push @dot_files, $file;
    }

    return @dot_files;
}

sub copy_dot_files {
    # replace dot files in home dir with the repo version

    my @dot_files = @_;

    for my $file ( @dot_files ) {
        my $dotfile;
        if ( $file =~ /^_/ ) {
            ($dotfile = $file) =~ s/^_/./;          # e.g. _vimrc
        } else {
            ($dotfile = $file) =~ s/^.+?_(.*)/.$1/; # e.g. cygwin_bashrc
        }

        copy( $file, File::Spec->catfile($ENV{'HOME'}, $dotfile) ) and
            print "$file => $dotfile\n";
    }
}

# MAIN

# clone git repo into a temporary directory
my $tmpdir = File::Temp->newdir( DIR => '/tmp' );
chdir $tmpdir;
system 'git clone git@github.com:jreisinger/dot-files.git';

my @dot_files = get_dot_files;

my $os = $^O;
if ( $os eq 'cygwin' ) {
    @dot_files = grep /^_|^cygwin/, @dot_files;
    copy_dot_files(@dot_files);
} else {
    @dot_files = grep /^_/, @dot_files;
    copy_dot_files(@dot_files);
}

# cd to homedir to allow removal of the temporary directory
chdir;
