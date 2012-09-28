#!/usr/bin/env perl
# Update dot files from git repo.
# Usage: run this script.
use strict;
use warnings;
use File::Spec;
use File::Copy;
use File::Path qw(make_path remove_tree);
use File::Basename;

sub get_dot_files {
    my $os = shift;

    my @dot_files;
    for my $file ( glob "$os/*" ) {
        push @dot_files, $file;
    }

    return @dot_files;
}

sub copy_dot_files {
    # replace dot files in home dir with the repo version

    my @dot_files = @_;

    for my $file ( @dot_files ) {
        # $file looks like linux/_vimrc
        my $dotfile = basename $file;
        $dotfile =~ s/^_/./;
        copy( $file, File::Spec->catfile($ENV{'HOME'}, $dotfile) ) and
            print "$file => $dotfile\n";
    }
}

sub install_vim_nerd_tree {
    # Install pathogen.vim
    my $autoload_dir = "$ENV{HOME}/.vim/autoload";
    make_path $autoload_dir unless -e $autoload_dir;
    my $pathogen_url = 'https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim';
    #system "curl -so $ENV{HOME}/.vim/autoload/pathogen.vim $pathogen_url";
    system "wget -q -O $ENV{HOME}/.vim/autoload/pathogen.vim $pathogen_url";

    my $bundle_dir = "$ENV{HOME}/.vim/bundle";

    # Install NERDtree
    mkdir $bundle_dir unless -e $bundle_dir;
    chdir $bundle_dir;
    remove_tree "nerdtree";
    my $nerdtree_repo = 'https://github.com/scrooloose/nerdtree.git';
    system "git clone $nerdtree_repo";

    # Install NERDtree tabs
    chdir $bundle_dir;
    remove_tree "vim-nerdtree-tabs";
    my $nerdtree_tabs_repo = 'https://github.com/jistr/vim-nerdtree-tabs.git';
    system "git clone $nerdtree_tabs_repo";
}

sub install_vim_templates {
    my $templates_dir = "$ENV{HOME}/.vim/templates";
    make_path $templates_dir unless -e $templates_dir;

    # Perl template
    open my $fh, ">", "$templates_dir/pl.template" or die;
    print $fh "#!/usr/bin/perl\nuse strict;\nuse warnings;\n";
    close $fh;
}

# MAIN

my @dot_files;

my $os = $^O;
if ( $os eq 'cygwin' ) {
    @dot_files = get_dot_files('cygwin');
} else {
    @dot_files = get_dot_files('linux');
}

copy_dot_files(@dot_files);
install_vim_nerd_tree;
install_vim_templates;

