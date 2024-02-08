" Encoding
scriptencoding utf-8
set encoding=utf-8

" Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Syntax highlighting
syntax enable
set termguicolors
set background=dark
colorscheme nord

" Tabs
set autoindent
set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set showtabline=2

" Whitespace
set nowrap
set list listchars=tab:·\ ,trail:·

" Backspace
set backspace=indent,eol,start

" Search
set ignorecase
set incsearch
set hlsearch

" Interface
set cursorline
set number
set ruler
set showcmd
set showmatch

" Extensions
au BufNewFile,BufRead .homesickrc set filetype=ruby
au BufNewFile,BufRead *.json set filetype=javascript

" GitGutter
let g:gitgutter_sign_column_always=1

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Use system clipboard
set clipboard=unnamed

" Automatic word wrapping
set tw=119
set formatoptions+=t

" Helpers
set wildmenu

" Misc
set updatetime=250