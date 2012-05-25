" activate pathogen.vim
call pathogen#infect()
" open a NERDTree automatically when vim starts up if no files were specified
autocmd vimenter * if !argc() | NERDTree | endif

syntax on                       " syntax highlighting
filetype on                     " try to detect filetypes
filetype plugin indent on       " enable loading indent file for filetype

" Python completion (Ctrl-O-X). Needs: vim >= 7.0, vim-nox.
" Problematic on cygwin.
set ofu=syntaxcomplete#Complete

" indenting
set tabstop=4
set shiftwidth=4
set expandtab " spaces instead of tab (looks same in all editors)

" highlight tabs and trailing spaces
set list!
set listchars=tab:>-,trail:-

" statusline
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
"              | | | | |  |   |      |  |     |    |
"              | | | | |  |   |      |  |     |    + current
"              | | | | |  |   |      |  |     |       column
"              | | | | |  |   |      |  |     +-- current line
"              | | | | |  |   |      |  +-- current % into file
"              | | | | |  |   |      +-- current syntax in
"              | | | | |  |   |          square brackets
"              | | | | |  |   +-- current fileformat
"              | | | | |  +-- number of lines
"              | | | | +-- preview flag in square brackets
"              | | | +-- help flag in square brackets
"              | | +-- readonly flag in square brackets
"              | +-- rodified flag in square brackets
"              +-- full path to file in the buffer
set laststatus=2

set textwidth=79
set nu          " show line numbers
colors koehler  " colorscheme
set showmatch   " show matching brackets

" don't bell or blink
set noerrorbells
set vb t_vb=

" paste/nopaste (inluding don't show/show numbers)
nnoremap <F2> :set nu! invpaste paste?<CR>
set pastetoggle=<F2>
set showmode
