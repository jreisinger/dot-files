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
use File::Compare;

my $script_dir = dirname abs_path($0);

sub get_dot_files {
    my $os = shift;

    my @dot_files;
    for my $file ( glob "$os/*" ) {
        push @dot_files, $file;
    }

    return @dot_files;
}

sub wanna_replace {
    my ( $old, $new ) = @_;

    while (1) {
        print "'$old' exists, wanna replace it? [y|n|diff]> ";
        chomp( my $answer = <STDIN> );
        system "diff $old $new" if "\L$answer" eq 'diff';
        return 1                if "\L$answer" eq 'y';
        return 0                if "\L$answer" eq 'n';
    }
}

sub copy_dot_files {

    # Replace dot files in home dir with the repo version.

    my @dot_files = @_;

    for my $new_file_path (@dot_files) {

        # $new_file_path looks like linux/_vimrc
        my $new_file = basename $new_file_path;
        $new_file =~ s/^_/./;
        my $old_file_path = File::Spec->catfile( $ENV{'HOME'}, $new_file );

        # dot-file already exists and differs from the upstream one
        if ( -e $old_file_path
            and compare( $old_file_path, $new_file_path ) != 0 )
        {
            if ( wanna_replace( $old_file_path, $new_file_path ) ) {
                copy( $new_file_path, $old_file_path )
                  and print "$new_file_path => ", $old_file_path,
                  "\n";
            }
        } elsif ( !-e $old_file_path ) {    # dot-file does not exist
            copy( $new_file_path, $old_file_path )
              and print "$new_file_path => ", $old_file_path,
              "\n";
        } else {
            print "'$old_file_path' and '$new_file_path' are equal\n";
        }
    }
}

sub install_vim_nerd_tree {

    # Install pathogen.vim
    my $autoload_dir = "$ENV{HOME}/.vim/autoload";
    make_path $autoload_dir unless -e $autoload_dir;
    my $pathogen_url =
      'https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim';

    system "curl -so $ENV{HOME}/.vim/autoload/pathogen.vim $pathogen_url";

    #system "wget -q -O $ENV{HOME}/.vim/autoload/pathogen.vim $pathogen_url";

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
    print "'$templates_dir/pl.template' installed\n";
}

sub install_vim_markdown {
    my $bundle_dir = "$ENV{HOME}/.vim/bundle";
    mkdir $bundle_dir unless -d $bundle_dir;
    chdir $bundle_dir;
    if ( -d "vim-markdown" ) {
        chdir "vim-markdown";
        system "git pull";
    } else {
        system "git clone https://github.com/plasticboy/vim-markdown.git";
    }
}

sub read_file {
    my ($filename) = @_;

    open my $in, '<:encoding(UTF-8)', $filename
      or die "Could not open '$filename' for reading $!";
    local $/ = undef;
    my $all = <$in>;
    close $in;

    return $all;
}

sub write_file {
    my ( $filename, $content ) = @_;

    open my $out, '>:encoding(UTF-8)', $filename
      or die "Could not open '$filename' for writing $!";
    print $out $content;
    close $out;

    return;
}

sub fillin_dotfiles {
    my $dot_files = shift;

    my $email;
    for my $dot_file ( glob "~/.*" ) {
        my $data = read_file($dot_file);
        next unless $data;
        next unless $data =~ /YOUR-EMAIL/;
        unless ($email) {
            print "Enter your email address: ";
            chomp( $email = <STDIN> );
        }
        $data =~ s/YOUR-EMAIL/$email/;
        print "edited '$dot_file'\n";
        write_file( $dot_file, $data );
    }
}

# MAIN

my @dot_files;

my $os = $^O;
if ( $os eq 'cygwin' ) {
    @dot_files = get_dot_files('cygwin');
} else {
    @dot_files = get_dot_files('linux');
}

print "\n--> Updating from repo\n";
system "git pull";

print "\n--> Copy dot files\n";
copy_dot_files(@dot_files);

print "\n--> Editing dotfiles on the fly\n";
fillin_dotfiles( \@dot_files );

print "\n--> Install vim nerd tree\n";
install_vim_nerd_tree;

print "\n--> Install vim templates\n";
install_vim_templates;

print "\n--> Install vim-markdown\n";
install_vim_markdown;
