set tabstop=4
set shiftwidth=4
set makeprg=jam
set autoindent
set incsearch
filetype on
filetype plugin on
filetype indent on

command -nargs=* Jam make <args>|:clist!
map <F9> <Esc>:w<CR>:Jam<CR>
map <F7> <Esc>:w<CR>:Jam test<CR>
map <F3> <Esc>:w<CR>`T:w<CR>:Jam runtestsolico "-sSINGLE=`python tools/jam/relpath.py %`"<CR>

set hlsearch

set encoding=utf-8

command Ctags !ctags --exclude=testsuite --exclude=tools --exclude=*_debug --exclude=*_release --exclude=filesystems -R
command NewFile %!python newfile.py %
command Coverage !python coverage.py %
command -nargs=* Find vimgrep /<args>/ py/**/*.py py/**/*.js storytest/**/*.py whiteboxtest/**/*.py cpp/**/*.h cpp/**/*.cpp troubleshooting/**/*.py QA/**/*py

command -range Colin :<line1>,<line2>!python $TOP/tools/vim/columnident.py %
command VoodooHint call VoodooHintFunction()

map <F6> :Colin<CR>
"Fast movement in the location list:
map <C-j> :cn<CR>
map <C-k> :cp<CR>

"Fast movement in the buffer list:
map <C-h> :bp<CR>
map <C-l> :bn<CR>
map <M-Right> :bn
map <M-Left> :bp

"Fast movement for next/previous tags
map #8 :tp
map #9 :tn

"Fast movement between splits
map <M-Down> 
map <M-Up> W

if has("gui_running")
	colorscheme darkblue
	set guifont=Monospace\ 14
endif
"source $VIM/_vimrc

function! s:PathComplete(ArgLead, CmdLine, CursorPos)
	return genutils#UserFileComplete(a:ArgLead, a:CmdLine, a:CursorPos, 1, &path)
endfunction
command! -nargs=1 -bang -complete=custom,<SID>PathComplete FindInPath
          \ :find<bang> <args>

"if has("gui_running")
"  set lines=65000 columns=65000
"endif

