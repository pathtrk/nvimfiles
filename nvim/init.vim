" BASIC SETTINGS ---------------------------------------------------------------- {{{
language en_US

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Turn off bell
set belloff=all

" Enable mouse click support
set mouse=a

" Support true colors
set termguicolors

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Show line numbers by default in normal buffers
set number

" Hide line numbers only in terminal buffers
augroup TerminalSettings
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd BufEnter term://* setlocal nonumber norelativenumber
    autocmd BufLeave term://* setlocal number
augroup END

" Make the backspace work like in most other programs
set backspace=indent,eol,start

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Use space characters instead of tabs.
set expandtab

" Do not save backup files.
set nobackup

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=10

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Use html binding for ejs files
au BufNewFile,BufRead *.ejs set filetype=html


" }}}


" PLUGINS ---------------------------------------------------------------- {{{

call plug#begin()

Plug 'VundleVim/Vundle.vim'
Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'prisma/vim-prisma'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
Plug 'pmizio/typescript-tools.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

call plug#end()

" }}}


" VIMSCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
"
" Use the marker method of folding.
"
" zo to open a single fold under the cursor.
" zc to close the fold under the cursor.
" zR to open all folds.
" zM to close all folds.
"
"
" Ale related settings.
"
let g:ale_fix_on_save = 1 " Format on save.
let g:ale_python_auto_virtualenv = 1

" Enable Ale fixers for TypeScript, Python, HTML, JavaScript, C, and C++.
let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'html': ['prettier'],
    \ 'javascript': ['eslint', 'prettier'],
    \ 'typescript': ['eslint', 'prettier'],
    \ 'python': ['black', 'autoflake', 'isort']
    \ }

let b:ale_javascript_prettier_options = '--tab-width 4 --single-quote'

" If Vim version is equal to or greater than 7.3 enable undofile.
" This allows you to undo changes to a file even after saving it.
if version >= 703
    set undodir=~/.vim/backup
    set undofile
    set undoreload=10000
endif

set background=dark     " for the light version
colorscheme lunaperche

" }}}


" STATUS LINE ------------------------------------------------------------ {{{

" Enable the statusline
set laststatus=2

" Indicataor like -- INSERT -- is unnecessary because the mode information is displayed in the statusline
set noshowmode

" Settings for vim-airline
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts = 1
let g:airline_theme='base16_black_metal_mayhem'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#ale#enabled = 1
let g:airline_mode_map = {
      \ '__'     : '-',
      \ 'c'      : 'C',
      \ 'i'      : 'I',
      \ 'ic'     : 'I',
      \ 'ix'     : 'I',
      \ 'n'      : 'N',
      \ 'multi'  : 'M',
      \ 'ni'     : 'N',
      \ 'no'     : 'N',
      \ 'R'      : 'R',
      \ 'Rv'     : 'R',
      \ 's'      : 'S',
      \ 'S'      : 'S',
      \ ''     : 'S',
      \ 't'      : 'T',
      \ 'v'      : 'V',
      \ 'V'      : 'V',
      \ ''     : 'V',
      \ }

" }}}


" MAPPINGS --------------------------------------------------------------- {{{

" Set the semicomma as the leader key.
let mapleader = ';'

" Press ,, to jump back to the last cursor position.
nnoremap <leader>; ``

" Press \p to print the current file to the default printer from a Linux operating system.
" View available printers:   lpstat -v
" Set default printer:       lpoptions -d <printer_name>
" <silent> means do not display output.
nnoremap <silent> <leader>p :%w !lp<CR>

" Type jj to exit insert mode quickly.
imap jj <Esc>

" Comment/uncomment with ctrl+/
noremap ,/ :Commentary<cr>

" Press the space bar to type the : character in command mode.
nnoremap <space> :

" Center the cursor vertically when moving to the next word during a search.
nnoremap n nzz
nnoremap N Nzz

" Clipboard yank and paste
"
" Yank all the content with ,ya
nnoremap ,ya ggVG"+y<C-O>
"
" Yank a whole line in normal mode, copy selected in visual mode
nnoremap ,y "+y
vnoremap ,y "+y
"
" Paste text in either normal or visual mode
nnoremap ,p  "+p
vnoremap ,p  "+p

" Map the F5 key to run a Python script inside Vim.
" I map F5 to a chain of commands here.
"
" :w saves the file.
" <CR> (carriage return) is like pressing the enter key.
" !clear runs the external clear screen command.
" !python3 % executes the current file with Python
"
nnoremap <f5> :w <CR>:!clear <CR>:!python3 % <CR>

" You can split the window in Vim by typing :split or :vsplit.
" Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

nnoremap <c-left> :bprevious<CR>
nnoremap <c-right> :bnext<CR>
nnoremap <c-up> :bfirst<CR>
nnoremap <c-down> :blast<CR>

" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
noremap <c-s-up> <c-w>+
noremap <c-s-down> <c-w>-
noremap <c-s-left> <c-w>>
noremap <c-s-right> <c-w><

" NERDTree specific mappings.
" Map the F3 key to toggle NERDTree open and close.
nnoremap <leader>b :NERDTreeToggle<cr>

" Have nerdtree ignore certain files and directories.
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']
" }}}

" Load lua script: lua/init.lua
luafile $HOME/.config/nvim/lsp.lua
