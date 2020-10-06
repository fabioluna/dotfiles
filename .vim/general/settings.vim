""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""" Native settings""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
filetype off
colorscheme delek
let mapleader="\<space>"
set encoding=UTF-8
set smarttab
set expandtab
set smartindent
set number
set numberwidth=3
set hidden
set relativenumber
set clipboard^=unnamedplus
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
