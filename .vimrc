set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" Language Spelling Tools
Plugin 'rhysd/vim-grammarous'


" GIT
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'


" UI
Plugin 'altercation/vim-colors-solarized'
Plugin 'ryanoasis/vim-devicons'
" Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

" UI -> NERDTree
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
map <C-n> :NERDTreeToggle<CR>
let NERDTreeMapOpenInTab='<ENTER>'
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" | NERDTree | endif

" UI -> Airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'enricobacis/vim-airline-clock'
let g:airline#extensions#virtualenv#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#ale#error_symbol = 'E:'
let g:airline#extensions#ale#warning_symbol = 'W:'
let g:airline_powerline_fonts = 1
let g:airline#extensions#capslock#enabled = 1


"Syntax and code
Plugin 'scrooloose/syntastic'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdcommenter'
Plugin 'davidhalter/jedi-vim'
Plugin 'wakatime/vim-wakatime'
Plugin 'tmhedberg/SimpylFold'


" Autoformat
Plugin 'chiel92/vim-autoformat'
"au BufWrite * :Autoformat


" Python
au BufNewFile,BufRead *.py
			\ set tabstop=4 |
			\ set softtabstop=4 |
			\ set shiftwidth=4 |
			"\ set textwidth=79 |
			\ set expandtab |
			\ set autoindent |
			\ set fileformat=unix

au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
highlight BadWhitespace ctermfg=16 ctermbg=253 guifg=#000000 guibg=#F8F8F0
"Plugin 'vim-scripts/indentpython.vim'
Plugin 'roxma/python-support.nvim'
Plugin 'heavenshell/vim-pydocstring'

" Python -> Flake8
Plugin 'nvie/vim-flake8'
let python_highlight_all=1
syntax on
let g:flake8_ignore="C0103"
let g:syntastic_python_checkers=['flake8 --ignore=E225,E501,E302,E261,E262,E701,E241,E126,E127,E128,W801','python3']

" Python -> Auto Complete
Plugin 'Valloric/YouCompleteMe'
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
" Track the engine.
Plugin 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-a>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Custom snippets
set runtimepath+=~/.vim/UltiSnips

" Python -> jedi-vim
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = "0"
let g:jedi#completions_command = "<C-Space>"

" Python -> virtualenv support
py3 << EOF
import os, sys, pathlib
if 'VIRTUAL_ENV' in os.environ:
    venv = os.getenv('VIRTUAL_ENV')
    site_packages = next(pathlib.Path(venv, 'lib').glob('python*/site-packages'), None)
    if site_packages:
        sys.path.insert(0, str(site_packages))
EOF

" Python -> Black
Plugin 'psf/black'
nnoremap <F9> :Black<CR>
let g:black_linelength = 79
" let g:black_skip_string_normalization = 1

" Frontend
au BufNewFile,BufRead *.js, *.html, *.css, *.xml
			\ set tabstop=2 |
			\ set softtabstop=2 |
			\ set shiftwidth=2 |
			\ set autoindent

" Emmet
Plugin 'mattn/emmet-vim'

" Others
Plugin 'tpope/vim-surround'
Plugin 'kien/ctrlp.vim'
Plugin 'mileszs/ack.vim'
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
" bind \ (backward slash) to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
Plugin 'akretion/vim-odoo-snippets'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


" Native settings
set encoding=UTF-8
set number
set numberwidth=3
set clipboard^=unnamed
set mouse=a
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

if ( $TERM == "xterm-256color" || $TERM == "screen-256color" )
	set t_Co=256

	" Enable powerline too, since we can.
	set rtp+=/usr/share/powerline/bindings/vim/
endif

" Move insert mode
:imap <C-h> <C-o>h
:imap <C-j> <C-o>j
:imap <C-k> <C-o>k
:imap <C-l> <C-o>l

" NERDCommenter
:imap <C-_> <esc><leader>cci
:imap <C-_><C-_> <esc><leader>cui


"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Tab Navigations and configs
nnoremap th :tabnext<CR>
nnoremap tl :tabprev<CR>
nnoremap tn :tabnew<CR>
nnoremap t1 1gt
nnoremap t2 2gt
nnoremap t3 3gt
nnoremap t4 4gt
nnoremap t5 5gt
nnoremap t6 6gt
nnoremap t7 7gt
nnoremap t8 8gt
nnoremap t9 9gt
nnoremap t0 10gt

" Enable folding
set foldmethod=indent
set foldlevel=99


" Enable folding with the spacebar
nnoremap <space> za

