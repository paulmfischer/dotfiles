" my options either for pref or from mastering vim book to supplement
set backspace=2             " Fix backspace behavior on most terminals.
set number relativenumber   " display line number and relative to cursor

set directory=$HOME/.vim/swap// " swap file location to stop littering everywhere

" set persistant undo across all files
set undofile
let my_undo_dir = expand('$HOME/.vim/undodir')
if !isdirectory(my_undo_dir)
    call mkdir(my_undo_dir, "p")
endif
execute "set undodir=".my_undo_dir

" My Mappings

" map the leader key to comman.
let mapleader = "\<space>"

" Fast split navigation with <Ctrl> + hjkl (<c-?>).
noremap <c-h> <c-w><c-h>
noremap <c-j> <c-w><c-j>
noremap <c-k> <c-w><c-k>
noremap <c-l> <c-w><c-l>

" => Chapter 1: Getting started
syntax on                   " Enable syntax highlighting
filetype plugin indent on   " Enable file type based options.

set nocompatible            " Don't run in backwards compatible mode.

set autoindent              " Respect indentation when starting new line.
set expandtab               " Expand tabs to spaces. Essential in Python.
set tabstop=4               " Number of spaces tab is counted for.
set shiftwidth=4            " Number of spaces to use for autindent.

colorscheme gruvbox         " change colorscheme

" => Chapter 2: Advanced Movement and Navigation

packloadall                 " Load all plugins
silent! helptags ALL        " Load help files for all plugins.

set wildmenu                " Enable enhanced tab autocomplete
set wildoptions=pum         " display as a popup

set hlsearch                " highlight all matches when searching, :noh to clear
set incsearch                " navigate to the first match on search

set clipboard=unnamed,unnamedplus   " Copy into system (*, +) register.

" Folds
" python folds
" autocmd filetype python set foldmethod=indent
" expand all folds on load (not working for some reason)
" autocmd BufRead * normal zR 

" Commands
command! Bd :bp | bd #      " keymap Bd to Close buffer without closing window

" NERDTree
"let NERDTreeShowBookmarks=1 " Display bookmarks on startup
"let NERDTreeHijackNetrw=0   " Aviod NERDTree from replace Netrw
" autocmd VimEnter * NERDTree " Enable NERDTree on Vim startup
" Autoclose NERDTree if it's the only window open
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" => Chapter 3: Follow the leader

" Download and install vim-plug (Linux).
"if empty(glob('$HOME/.vim/autoload/plug.vim'))
" execute 'curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"else
"call plug#begin()

"Plug 'scrooloose/nerdtree'
"Plug 'mileszs/ack.vim'
"Plug 'easymotion/vim-easymotion'
" Chapter 4
"let g:plug_timeout = 300 " Increase vim-plug timeout for YouCompleteMe."
"Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }
" Plug 'mbbil/undotree'

" Chapter 5
"Plug 'tpope/vim-fugitive'
"call plug#end()
"endif

" Use ; in addition to : to type commands.
noremap ; :

inoremap ' ''<esc>i
inoremap " ""<esc>i
inoremap ( ()<esc>i
inoremap { {}<esc>i
inoremap [ []<esc>i
inoremap < <><esc>i

" save a file with leader-w.
noremap <leader>w :w<cr>
"noremap <leader>n :NERDTreeToggle<cr>

" => Chapter 4: Understanding Structured Text

noremap <leader>] :YcmCompleter GoTo<cr>

set tags=tags; " Look for a tags file recursively in parent directories.

" Regenerate tags when saving files.
autocmd BufWritePost *.cs,*.ts,*.tsx,*.js,*.jsx,*.py,*.sh silent! !ctags -R &
