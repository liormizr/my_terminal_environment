" Sample .vimrc file by Martin Brochhaus
" Presented at PyCon APAC 2012


" ============================================
" Note to myself:
" DO NOT USE <C-z> FOR SAVING WHEN PRESENTING!
" ============================================


" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %


" Better copy & paste
" When you want to paste large blocks of code into vim, press F2 before you
" paste. At the bottom you should see ``-- INSERT (paste) --``.

set pastetoggle=<F2>
set clipboard=unnamed
"set clipboard=unnamedplus
vnoremap <C-c> "*y
vnoremap <C-x> "+c

set encoding=utf-8

" Mouse and backspace
set mouse=a  " on OSX press ALT and click
set bs=2     " make backspace behave like normal again


" Rebind <Leader> key
" I like to have it here becuase it is easier to reach than the default and
" it is next to ``m`` and ``n`` which I use for navigating between tabs.
let mapleader = ","


" Bind nohl
" Removes highlight of your last search
" ``<C>`` stands for ``CTRL`` and therefore ``<C-n>`` stands for ``CTRL+n``
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>


" Quicksave command
noremap <C-q> :update<CR>
vnoremap <C-q> <C-C>:update<CR>
inoremap <C-q> <C-O>:update<CR>
map <C-q> :w<CR>

" Quick quit command
noremap <Leader>q :quit<CR>  " Quit current window
noremap <Leader>Q :qa!<CR>   " Quit all windows


" bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
" Every unnecessary keystroke that can be saved is good for your health :)
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h



" easier moving between tabs
map <Leader>/ <esc>:bnext!<CR>
map <Leader>. <esc>:bprevious!<CR>
map <Leader>w <esc>:bd!<CR>
map <Leader>bq:bp <BAR> bd <CR>

" map sort function to a key
vnoremap <Leader>s :sort<CR>


" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several times.
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation


" Show whitespace
" MUST be inserted BEFORE the colorscheme command
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/
" Deletes extra spaces - :%s/\s\+$//


" Color scheme
" mkdir -p ~/.vim/colors && cd ~/.vim/colors
"wget -O wombat256mod.vim http://www.vim.org/scripts/download_script.php?src_id=13400
set t_Co=256
color wombat256mod


" Enable syntax highlighting
" You need to reload this file for the change to apply
filetype off
filetype plugin indent on
syntax on


" Showing line numbers and length
set number  " show line numbers
" set tw=79   " width of document (used by gd)
set nowrap  " don't automatically wrap on load
set fo-=t   " don't automatically wrap text when typing
set colorcolumn=100
highlight ColorColumn ctermbg=233


" easier formatting of paragraphs
" vmap Q gq
" nmap Q gqap

" Useful settings
set history=700
set undolevels=700


" Real programmers don't use TABs but spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab


" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase


" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile
set autoindent

" Setup Pathogen to manage your plugins
" mkdir -p ~/.vim/autoload ~/.vim/bundle
" curl -so ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
" Now you can install any plugin into a .vim/bundle/plugin-name/ folder
 call pathogen#infect()

" ============================================================================
" Python IDE Setup "
" ============================================================================

set laststatus=2

" Settings for ctrlp
" cd ~/.vim/bundle
" git clone https://github.com/kien/ctrlp.vim.git
let g:ctrlp_max_height = 30
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=*/coverage/*


" ============================================================================
" C++ IDE Setup
" ============================================================================
set exrc
set secure

set makeprg=[[\ -f\ Makefile\ ]]\ &&\ make\ \\\|\\\|\ make\ -C\ ..
nnoremap <F7> :make!<cr>
nnoremap <F5> :!./my_great_program<cr>

" NerdTree
"autocmd vimenter * NERDTree
autocmd BufEnter * lcd %:p:h
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let NERDTreeShowHidden=1
map <C-n> :NERDTreeToggle<CR>

" YCM
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
noremap <Leader>g :YcmCompleter GoToDefinition<CR>
noremap <Leader>h :YcmCompleter GoToDeclaration<CR>

:noremap <C-f> :Pss -i  *.cpp *.h *.c<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>


":noremap <C-f> :execute 'Pss' input('Pattern: ') '*.cpp *.h'<CR>

"Vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
"
" " The following are examples of different formats supported.
" " Keep Plugin commands between vundle#begin/end.
Bundle 'jlanzarotta/bufexplorer'

"
" " All of your Plugins must be added before the following line
 call vundle#end()            " required
 filetype plugin indent on    " required

"BufExplorer
" Buffers - explore/next/previous: Alt-F12, F12, Shift-F12.
nnoremap <silent> <M-F12> :BufExplorer<CR>
nnoremap <silent> <F12> :bn<CR>
nnoremap <silent> <S-F12> :bp<CR>

"airline
"git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" toggle source/headers
"noremap <C-t> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
noremap <C-t> :FSHere<CR>
noremap <Leader>t :FSRight<CR>
" ctags
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
set tags=./tags;/

noremap<Leader>; :CommandT <CR>
noremap<Leader>l :CommandTBuffer<CR>
noremap<Leader>' :CommandTTag<CR>
