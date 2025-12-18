" Sets the default vim settings. 
source $VIMRUNTIME/defaults.vim

" Enable syntax highlighting.
syntax on

set ts=4 sw=4

filetype indent on

call plug#begin('~/.vim/plugged')
Plug 'jiangmiao/auto-pairs'
call plug#end()

