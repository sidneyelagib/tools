syntax on " Syntax highlight

colorscheme desert " Color Scheme

set encoding=utf-8 " File encoding

set spell spelllang=en_us " Spellcheck

set number " Display line numbers

set tabstop=4 " Number of tabs

set autoindent " Automatic indentation

set expandtab " Replace tabs with whitespaces

set cursorline " Highlight the current line

set showcmd "Show command in bottom bar

filetype indent on " load filetype-specific indent files

set wildmenu " visual autocomplete for command menu

set incsearch " search as characters are entered

set hlsearch  " highlight matches

set foldenable " enable folding

:set backspace=indent,eol,start

let g:rainbow_active = 1

" Installing some plugins
call plug#begin()
  Plug 'preservim/nerdtree'
  Plug 'preservim/nerdcommenter'
  Plug 'pangloss/vim-javascript'
  Plug 'vim-airline/vim-airline'
  Plug 'airblade/vim-gitgutter'
  Plug 'frazrepo/vim-rainbow'
call plug#end()
