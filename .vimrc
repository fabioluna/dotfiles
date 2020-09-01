""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""" Native settings""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
filetype off
colorscheme delek
let mapleader="\<space>"
set encoding=UTF-8
set expandtab
set number
set numberwidth=3
set hidden
set relativenumber
set clipboard^=unnamed
set mouse=a
set t_u7=
syntax on
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

if ( $TERM == "xterm-256color" || $TERM == "screen-256color" )
        set t_Co=256

        " Enable powerline too, since we can.
        set rtp+=/usr/share/powerline/bindings/vim/
endif

if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""Shortcuts"""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""
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

" Source
nnoremap <leader>sv :source $MYVIMRC<cr>

" Find
nnoremap <C-f> :Ag<space>

" Set Paste
nnoremap <leader>v :set paste<cr>
nnoremap <leader>nv :set nopaste<cr>


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
map <C-n> :NERDTreeToggle<CR>
let NERDTreeMapOpenInTab='<ENTER>'
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'enricobacis/vim-airline-clock'
let g:airline#extensions#virtualenv#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#capslock#enabled = 1


" GIT
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'APZelos/blamer.nvim'
"let g:blamer_enabled = 1
let g:blamer_delay = 1000

" Auto Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"


" Syntax 
Plug 'dense-analysis/ale'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#ale#error_symbol = 'E:'
let g:airline#extensions#ale#warning_symbol = 'W:'


" Commentter
Plug 'scrooloose/nerdcommenter'


""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""Languages""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" General
Plug 'tpope/vim-surround'
Plug 'kien/ctrlp.vim'
Plug 'wakatime/vim-wakatime'
Plug 'albfan/ag.vim'


" Python
au BufNewFile,BufRead *.py
                        \ set tabstop=4 |
                        \ set softtabstop=4 |
                        \ set shiftwidth=4 |
                        \ set autoindent |
                        \ set fileformat=unix
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
highlight BadWhitespace ctermfg=16 ctermbg=253 guifg=#000000 guibg=#F8F8F0

Plug 'heavenshell/vim-pydocstring'
Plug 'nvie/vim-flake8'
let python_highlight_all=1
let g:PyFlakeCheckers = 'pep8,mccabe'
let g:PyFlakeDefaultComplexity=10
let g:flake8_ignore="C0103"
let g:syntastic_python_checkers=['flake8 --ignore=E225,E501,E302,E261,E262,E701,E241,E126,E127,E128,W801','python3']
Plug 'psf/black' ", { 'tag': '*' }
nnoremap <F9> :Black<CR>
let g:black_linelength = 79
Plug 'fisadev/vim-isort'
let g:vim_isort_map = '<C-i>'


" JS
au BufNewFile,BufRead *.js,*.html,*.css
                        \ set tabstop=2 |
                        \ set softtabstop=2 |
                        \ set shiftwidth=2 |
                        \ set autoindent

au bufnewfile,bufread *.xml
                        \ set tabstop=4 |
                        \ set softtabstop=4

Plug 'mattn/emmet-vim'
let g:user_emmet_install_global = 0
autocmd FileType html,css,xml EmmetInstall


" Ansible
Plug 'pearofducks/ansible-vim'


" Flutter
au BufNewFile,BufRead *.dart
                        \ set tabstop=2 |
                        \ set softtabstop=2 |
                        \ set shiftwidth=2 |
                        \ set autoindent

Plug 'dart-lang/dart-vim-plugin'

" Bash
au BufNewFile,BufRead *.sh
                        \ set tabstop=2 |
                        \ set softtabstop=2 |
                        \ set shiftwidth=2 |
                        \ set autoindent


call plug#end()

