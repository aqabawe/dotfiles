" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
filetype off

set colorcolumn=120

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'thoughtbot/vim-rspec'
Plugin 'repeat.vim'
Plugin 'surround.vim'
Plugin 'SuperTab'
Plugin 'file-line'
Plugin 'grep.vim'
Plugin 'Tabular'
Plugin 'Lokaltog/vim-powerline'
Plugin 'The-NERD-tree'
Plugin 'FindInNERDTree'
Plugin 'textobj-user'
Plugin 'textobj-rubyblock'
Plugin 'Puppet-Syntax-Highlighting'
Plugin 'EasyMotion'
Plugin 'airblade/vim-gitgutter'
Plugin 'kien/ctrlp.vim'
Plugin 'L9'
Plugin 'FuzzyFinder'
Plugin 'tComment'
Plugin 'vim-syntastic/syntastic'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'github/copilot.vim'
call vundle#end()            " required
filetype plugin indent on    " required

"let g:CommandTMatchWindowAtTop=1 " show window at top
"nnoremap <silent> <Leader>t :CommandT<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_javascript_checkers = ['eslint']
nnoremap // :TComment<CR>
vnoremap // :TComment<CR>

" RSpec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

let mapleader=','
let g:fuf_modesDisable = [] " {{{
nnoremap <silent> <Leader>h :FufHelp<CR>
nnoremap <silent> <Leader>2  :FufFileWithCurrentBufferDir<CR>
nnoremap <silent> <Leader>f  :FufFile<CR>
nnoremap <silent> <Leader>b  :FufBuffer<CR>
nnoremap <silent> <Leader>4  :FufDirWithCurrentBufferDir<CR>
nnoremap <silent> <Leader>$  :FufDir<CR>
nnoremap <silent> <Leader>5  :FufChangeList<CR>
nnoremap <silent> <Leader>6  :FufMruFile<CR>
nnoremap <silent> <Leader>l  :FufLine<CR>
nnoremap <silent> <LocalLeader>8  :FufBookmark<CR>
nnoremap <silent> <Leader>*  :FuzzyFinderAddBookmark<CR><CR>
nnoremap <silent> <Leader>9  :FufTaggedFile<CR>
" " }}}

" tComment
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup    " do not keep a backup file, use versions instead
else
  set backup    " keep a backup file
endif
set history=50    " keep 50 lines of command line history
set ruler   " show the cursor position all the time
set showcmd   " display incomplete commands
set incsearch   " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
noremap j gj
noremap k gk

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent    " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
nnoremap <C-h> gT
nnoremap <C-l> gt
set nu

" map <F3> :execute "noautocmd vimgrep /" . expand("<cword>") . "/gj **/*." .  expand("%:e") <Bar> cw<CR>
map <F3> :execute "noautocmd vimgrep /" . expand("<cword>") . "/gj **/*." .  expand("%:e") <Bar> cw

function! CmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'gv'
    "call CmdLine("noautocmd vimgrep " . '/'. l:pattern . '/gj' . ' **/*')
    "execute "noautocmd vimgrep " . '/'. l:pattern . '/gj' . ' **/*'
    execute "Rgrep -i " . l:pattern
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

vnoremap <silent> * :call VisualSearch('b')<CR>
vnoremap <silent> # :call VisualSearch('f')<CR>
vnoremap <silent> gv :call VisualSearch('gv') <Bar> cw<CR>

set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

map <F2> :tabnew .<CR>
let NERDTreeShowBookmarks=1
set tabstop=2
set shiftwidth=2
set expandtab

set nobackup

nnoremap <silent> <C-i> :call FindInNERDTree()<CR>

autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
highlight EOLWS ctermbg=red guibg=red

function! <SID>StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
nmap <silent> <Leader><space> :call <SID>StripTrailingWhitespace()<CR>
nnoremap <F5> :GundoToggle<CR>

map <leader>cc :botright cope<cr>
map <leader>n :cn<cr>
map <leader>p :cp<cr>

""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

" Format the statusline
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c


function! CurDir()
    let curdir = substitute(getcwd(), '/home/waleed/', "~/", "g")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    else
        return ''
    endif
endfunction

set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors
let g:Powerline_symbols = 'unicode'

" Insert the charcode segment after the filetype segment
call Pl#Theme#InsertSegment('ws_marker', 'after', 'lineinfo')

au BufNewFile,BufRead *.ejs set filetype=html
au BufRead,BufNewFile *.handlebars,*.hbs set ft=html syntax=handlebars

autocmd QuickFixCmdPost *grep* cwindow
au FileType python  set tabstop=4 shiftwidth=4 textwidth=140 softtabstop=4

hi CursorColumn cterm=NONE ctermbg=black
"ctermfg=white guibg=darkred guifg=white

" Swap files in temp instead of the same dir
set backupdir=$TMPDIR//
set directory=$TMPDIR//
"------------------------------------------------------------
" FZF bindings
"------------------------------------------------------------
nnoremap <leader>f :Files<CR>
nnoremap <leader>a :Ack<space>
nnoremap <leader>sl :Lines<CR>
nnoremap <leader>sb :BLines<CR>
nnoremap <leader>b :Buffers<CR>
Plugin 'numkil/ag.nvim'
