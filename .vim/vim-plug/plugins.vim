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
Plug 'ryanoasis/vim-devicons'
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" GIT
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Plug 'lewis6991/gitsigns.nvim'
Plug 'APZelos/blamer.nvim'
Plug 'rhysd/git-messenger.vim'

" Auto Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Commentter
Plug 'scrooloose/nerdcommenter'

" Utils
Plug 'liuchengxu/vim-which-key'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'sheerun/vim-polyglot'
Plug 'mattn/vim-chatgpt'

" General
Plug 'tpope/vim-surround'
Plug 'wakatime/vim-wakatime'
Plug 'airblade/vim-rooter'
Plug 'voldikss/vim-floaterm'

" Find and Replace
Plug 'brooth/far.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

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

" Dart
Plug 'natebosch/vim-lsc'
Plug 'natebosch/vim-lsc-dart'

" Makdown
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

" Javascript
Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

" General
Plug 'mattn/emmet-vim'

call plug#end()

