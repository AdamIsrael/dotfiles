set nocompatible

set number
set autoindent
set background=dark
set encoding=utf-8
set nomodeline
set hidden

" Install the plugin manager
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'ghifarit53/tokyonight-vim'

call plug#end()

" Install/config the tokyonight storm theme
set termguicolors           " enable true colors
let g:tokyonight_style = 'storm' " explicitly set the 'storm' style
colorscheme tokyonight      " load the colorscheme

filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
