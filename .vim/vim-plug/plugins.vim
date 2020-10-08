" auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""" Plugins"""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" Colors
Plug 'flazz/vim-colorschemes'

"" NERDTree
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'enricobacis/vim-airline-clock'

" GIT
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'APZelos/blamer.nvim'

" Auto Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Syntax 
Plug 'dense-analysis/ale'

" Commentter
Plug 'scrooloose/nerdcommenter'

" Utils
Plug 'liuchengxu/vim-which-key'

" General
Plug 'tpope/vim-surround'
Plug 'wakatime/vim-wakatime'
Plug 'airblade/vim-rooter'
Plug 'voldikss/vim-floaterm'

" Find and Replace
Plug 'kien/ctrlp.vim'
Plug 'albfan/ag.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'brooth/far.vim'

""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""Languages""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Python
Plug 'heavenshell/vim-pydocstring'
Plug 'nvie/vim-flake8'
Plug 'psf/black' ", { 'tag': '*' }
Plug 'fisadev/vim-isort'

" Ansible
Plug 'pearofducks/ansible-vim'

" Dart
Plug 'dart-lang/dart-vim-plugin'

call plug#end()

