#!/usr/bin/env perl
# Update dot files from git repo.
# Usage: run this script.
use strict;
use warnings;
use File::Spec;
use File::Copy;
use File::Path qw(make_path remove_tree);
use File::Basename;
use Cwd 'abs_path';

my $script_dir = dirname abs_path($0);

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

    for my $file (@dot_files) {

        # $file looks like linux/_vimrc
        my $dotfile = basename $file;
        $dotfile =~ s/^_/./;
        copy( $file, File::Spec->catfile( $ENV{'HOME'}, $dotfile ) )
          and print "$file => ", File::Spec->catfile( $ENV{'HOME'}, $dotfile ),
          "\n";
    }
}

sub install_vim_nerd_tree {

    # Install pathogen.vim
    my $autoload_dir = "$ENV{HOME}/.vim/autoload";
    make_path $autoload_dir unless -e $autoload_dir;
    my $pathogen_url =
      'https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim';

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

sub create_module_starter_config {
    my $conf_dir = File::Spec->catfile( $ENV{HOME}, '.module-starter' );
    mkdir($conf_dir) unless -d $conf_dir;

    copy( "$script_dir/_module-starter/config", $conf_dir ) or die "$!";
    print "$script_dir/_module-starter/config => ", "$conf_dir/config", "\n";
}

# MAIN

my @dot_files;

my $os = $^O;
if ( $os eq 'cygwin' ) {
    @dot_files = get_dot_files('cygwin');
} else {
    @dot_files = get_dot_files('linux');
}


print "==> Copy dot files\n";
copy_dot_files(@dot_files);
print "\n==> Install vim nerd tree\n";
install_vim_nerd_tree;
print "\n==> Install vim templates\n";
install_vim_templates;
print "\n==> Create module-starter config file\n";
create_module_starter_config;
