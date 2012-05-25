#!/usr/bin/env perl
# Update dot files from git repo.
# Usage: run this script.
use strict;
use warnings;
use File::Spec;
use File::Copy;
use File::Path qw(make_path remove_tree);

sub get_dot_files {

    # get the dot files
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

sub install_vim_nerd_tree {

    # Install pathogen.vim
    my $autoload_dir = "$ENV{HOME}/.vim/autoload";
    make_path $autoload_dir unless -e $autoload_dir;
    system "curl -so $ENV{HOME}/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim";

    # Install NERD tree
    my $bundle_dir = "$ENV{HOME}/.vim/bundle";
    mkdir $bundle_dir unless -e $bundle_dir;
    chdir $bundle_dir;
    remove_tree "nerdtree";
    system "git clone https://github.com/scrooloose/nerdtree.git";

}

# MAIN
my @dot_files = get_dot_files;

my $os = $^O;
if ( $os eq 'cygwin' ) {
    @dot_files = grep /^_|^cygwin/, @dot_files;
    copy_dot_files(@dot_files);
} else {
    @dot_files = grep /^_/, @dot_files;
    copy_dot_files(@dot_files);
}

install_vim_nerd_tree();
