set number relativenumber
set laststatus=0
set smartindent
set autoindent
set expandtab
set smarttab
set formatoptions-=cro
set hidden
set nowrap
set encoding=utf-8
set fileencoding=utf-8
set ruler
set mouse=a
set splitbelow
set splitright
set clipboard=unnamedplus
set background=dark
set autochdir
set nolist
syntax enable
filetype on
filetype indent on
filetype plugin on
autocmd vimenter * NERDTree

" for command mode
nnoremap <Tab> >>
nnoremap <S-Tab> <<
" for insert mode
inoremap <S-Tab> <C-d>

let g:airline_theme='violet'
let g:auto_save = 1
source $HOME/.config/nvim/vim-plug/plugins.vim
