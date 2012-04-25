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
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2

set textwidth=79
set nu          " show line numbers
colors koehler  " colorscheme

" don't bell or blink
set noerrorbells
set vb t_vb=

" paste/nopaste (inluding don't show/show numbers)
nnoremap <F2> :set nu! invpaste paste?<CR>
set pastetoggle=<F2>
set showmode
