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
set background=dark
colorscheme solarized

" Tabs
set autoindent
set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

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

" Extensions
au BufNewFile,BufRead .homesickrc set filetype=ruby
au BufNewFile,BufRead *.json set filetype=javascript

" GitGutter
let g:gitgutter_sign_column_always=1
highlight SignColumn ctermbg=8 guibg=#002b36
highlight GitGutterAdd ctermbg=8 ctermfg=2 guibg=#002b36 guifg=#859900
highlight GitGutterChange ctermbg=8 ctermfg=4 guibg=#002b36 guifg=#268bd2
highlight GitGutterDelete ctermbg=8 ctermfg=1 guibg=#002b36 guifg=#dc322f
highlight GitGutterChangeDelete ctermbg=8 ctermfg=4 guibg=#002b36 guifg=#268bd2
