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

"" Files and Trees
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" GIT
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'APZelos/blamer.nvim'
Plug 'rhysd/git-messenger.vim'

" Auto Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Commentter
Plug 'scrooloose/nerdcommenter'

" Utils
Plug 'liuchengxu/vim-which-key'
Plug 'MattesGroeger/vim-bookmarks'

" General
Plug 'tpope/vim-surround'
Plug 'wakatime/vim-wakatime'
Plug 'airblade/vim-rooter'
Plug 'voldikss/vim-floaterm'
Plug 'Stoozy/vimcord'
Plug 'ActivityWatch/aw-watcher-vim'

" Find and Replace
Plug 'kien/ctrlp.vim'
Plug 'albfan/ag.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'brooth/far.vim'

" Debug
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'

" Vim in Browser 🤘
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(69) } }


""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""Languages""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Python
Plug 'heavenshell/vim-pydocstring'
Plug 'nvie/vim-flake8'
Plug 'psf/black' ", { 'tag': '*' }
Plug 'fisadev/vim-isort'
Plug 'tell-k/vim-autopep8'

" Ansible
Plug 'pearofducks/ansible-vim'

" Dart
Plug 'dart-lang/dart-vim-plugin'

" Makdown
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

call plug#end()

