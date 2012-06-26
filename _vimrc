" activate pathogen.vim
call pathogen#infect()
" open a NERDTree automatically when vim starts up if no files were specified
nnoremap <F4> :NERDTreeTabsToggle<CR>

" make templates work
autocmd BufNewFile * silent! 0r ~/.vim/templates/%:e.template

syntax on                       " syntax highlighting
filetype on                     " try to detect filetypes
filetype plugin indent on       " enable loading indent file for filetype
filetype plugin on              " enable templates

set ic  " ignore case during search

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

" folding
set foldmethod=manual
inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf
autocmd BufWinLeave *.* mkview          "save folds
autocmd BufWinEnter *.* silent loadview "load folds

"" Perl stuff

" Tidy selected lines (or entire file) with _t:
nnoremap <silent> _t :%!perltidy -q<Enter>
vnoremap <silent> _t :!perltidy -q<Enter>

" Check syntax: \l
command PerlLint !perl -c %
nnoremap <leader>l :PerlLint<CR>
" Fix errors: :w => :make => :copen => :cn | :cp
set makeprg=perl\ -c\ -MVi::QuickFix\ %
set errorformat+=%m\ at\ %f\ line\ %l\.
set errorformat+=%m\ at\ %f\ line\ %l
