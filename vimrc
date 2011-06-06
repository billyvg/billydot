set nocompatible                " No vi support
set nobackup                    " Don't create backups
set mouse=a                     " Enable mouse support
set confirm                     " Fuck if I know
set ruler                       " Show cursor position 
"set number                      " Show line numbers
set showcmd                     " Show (partial) command in status line
set wildmenu                    " Show wild menu
set wildmode=list:longest
set backspace=indent,eol,start  " Allow backspacing over everything in insert mode
set incsearch                   " Allow incremental search 
set hlsearch                    " Highlight search results
set ignorecase                  " Smart case sensitivty 
set smartcase
set showmatch                   " Show matching brackets.
set history=1000                " keep a bunch of command line history
set autowrite                   " Automatically save before commands like :next and :make
"set autochdir                   " Automatically set current directory to file's location
set hidden                      " Permit changing buffers without saving
set foldmethod=marker           " folding 
set list
set listchars=tab:»·,trail:·    " Show tabs and trailing spaces
filetype on                     " Detect filetype
filetype plugin indent on
syntax on                       " Enable syntax highlighting
set autoindent                  " Enable auto indent
set smartindent
" use spaces instead of tabs (python optimized)
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab

" ** Font and color scheme **
"set gfn=Consolas:h10:cANSI
"set gfn=Inconsolata:h10:cANSI
"colorscheme fruity
"colorscheme womba
"colorscheme desert
" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" ** Key Mappings **
nnoremap <F5> :set invpaste paste?<Enter>
imap <F5> <C-O><F5>
set pastetoggle=<F5>

" Undo in Insert mode (Ctrl+z)
map <c-z> <c-o>u

" remap omni-complete to ctrl+space
inoremap <C-space> <C-x><C-o>

" ** Functions **
" Function for cleaning up tabs and spaces
function! RemoveTrailingSpaces()
    %s/\s\+$//e
    %s/
//ge
endfunction
 
function! ConvertTabsToSpaces()
    %retab
endfunction
 
function! CleanFile()
    call ConvertTabsToSpaces()
    call RemoveTrailingSpaces()
endfunction

" Key binding \f to clean up file
nmap <silent> <leader>f <Esc>:call CleanFile()<CR>

" Python-specific settings
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\" 
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m 
autocmd FileType python set omnifunc=pythoncomplete#Complete    " Code completion

" Adds the ability to jump between python class libraries.
" This snippet sets up vim to know where the Python libs are so
" you can use 'gf' to get to them (gf is goto file).
python << EOF
import os
import sys
import vim
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF

" Continuing accessibility of the Python class libraries we are going to want 
" to use ctags to generate an index of all the code for vim to reference:
" $ ctags -R -f ~/.vim/tags/python.ctags /usr/lib/python2.5/
set tags+=$HOME/.vim/tags/python.ctags

" This will give you the ability to use CTRL+] to jump to the method/property 
" under your cursor in the system libraries and CTRL+T to jump back to your
" source code.

" Allow you to be able to visually select a method/class and execute it by 
" hitting “Ctrl+h”.
python << EOL 
import vim 
def EvaluateCurrentRange(): 
    eval(compile('\n'.join(vim.current.range),'','exec'),globals()) 
EOL 
map <C-h> :py EvaluateCurrentRange() 
