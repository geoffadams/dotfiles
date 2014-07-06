" Encoding
scriptencoding utf-8
set encoding=utf-8

" Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Syntax highlighting
syntax enable
set background=dark
colorscheme solarized

" Tabs
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Whitespace
set nowrap

" Search
set ignorecase
set incsearch
set hlsearch

" Interface
set cursorline
set number
set ruler