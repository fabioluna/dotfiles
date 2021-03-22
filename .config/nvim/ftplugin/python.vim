au BufNewFile,BufRead *.py
                        \ set tabstop=4 |
                        \ set softtabstop=4 |
                        \ set shiftwidth=4 |
                        \ set autoindent |
                        \ set fileformat=unix
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
highlight BadWhitespace ctermfg=16 ctermbg=253 guifg=#000000 guibg=#F8F8F0

let python_highlight_all=1
let g:flake8_cmd="/home/fabio/.asdf/installs/python/3.9.0/bin/flake8"
let g:PyFlakeCheckers = 'pep8,mccabe'
let g:PyFlakeDefaultComplexity=10
let g:flake8_ignore="C0103"
let g:syntastic_python_checkers=['flake8 --ignore=E225,E501,E302,E261,E262,E701,E241,E126,E127,E128,W801','python3']
nnoremap <F9> :Black<CR>
let g:black_linelength = 79
let g:vim_isort_map = '<C-i>'
let g:vim_isort_python_version = 'python3'
