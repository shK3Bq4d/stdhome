" ex: set expandtab ts=4 sw=4:
let g:pathogen_disabled = []
let s:sys=system('uname -s | perl -pe "chomp"')
let hostname = substitute(system('hostname'), '\n', '', '')
if s:sys == "Cygwin_NT""
    call add(g:pathogen_disabled, 'AutoComplPop')
else
    call add(g:pathogen_disabled, 'ingo-library')
endif
call add(g:pathogen_disabled, 'AutoComplPop')
"call add(g:pathogen_disabled, 'youcompleteme')
" should between youcomplete me or autocomplpop
if hostname == $WORK_PC1 || hostname == "bipbip" 
    "set complete=.,b,u,]
    "set wildmode=longest,list:longest
    "set completeopt=menu,preview
else
endif
if hostname == "bipbip" || hostname == "bipbip" 
    call add(g:pathogen_disabled, 'vim-gitgutter')
else
    " https://github.com/airblade/vim-gitgutter
    "let g:gitgutter_highlight_lines = 1
    let g:gitgutter_grep_command = 'grep'
    "let g:gitgutter_diff_args = ' --git-dir=/tmp --work-tree=/tmp '
    "let g:gitgutter_diff_args = ' --no-index '
    if executable('git-mr-gitgutter')
        let g:gitgutter_git_executable = 'git-mr-gitgutter'
    endif
    " let g:gitgutter_diff_args = ' --git-dir=/tmp '
    set updatetime=250
    " #!/usr/bin/env bash
    "
    " if [[ "$@" == *diff* ]]; then
    "     unset GIT_DIR
    "     unset GIT_WORK_TREE
    "     fi                                                                                   
    "     echo "$(date) $0 $@" >> /tmp/mrgit
    " /usr/local/bin/git "$@" 2>&1 | tee -a /tmp/mrgit
endif
try
    execute pathogen#infect()

catch /^Vim\%((\a\+)\)\=:E117/
    " we fall back here in case of sshrc to remote host or sudomr on localhost
    
    " The following block was found online and worked for sshrc, but not localsudomr
    " set default 'runtimepath' (without ~/.vim folders)
    "let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)
    " what is the name of the directory containing this file?
    "let s:portable = expand('<sfile>:p:h')
    " add the directory to 'runtimepath'
    "let &runtimepath = printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)
    

    let &runtimepath = printf('%s/.vim,$VIMRUNTIME', $RCD)
    try
        " in case of sudomr, we'd like to give pathogen#infect another try
        execute pathogen#infect()
    catch /^Vim\%((\a\+)\)\=:E117/
        " in case of sshrc no pathogen exists so let's forget about it
    endtry
endtry
let main_syntax = '' " trying to solve a bug in /usr/local/share/vim/vim80/syntax/html.vim:183 FreeBSD 2017.02.11


syntax on
filetype plugin indent on
" 256 colors support
set t_Co=256
"set t_AB=^[[48;5;%dm
"set t_AF=^[[38;5;%dm

:set nocompatible
:set encoding=utf-8
:set fileformat=unix
:set fileformats=unix,dos,mac
:set fileencoding=utf-8
:set cindent
:set ignorecase
:set smartcase
:set nostartofline
:set showcmd
:set hlsearch
:set incsearch
:set guioptions-=M
:set guioptions-=m  "remove menu bar
:set guioptions-=T  "remove toolbar
:set guioptions-=r  "remove right-hand scroll bar
:hi CursorLine   cterm=None ctermbg=yellow ctermfg=white guibg=yellow guifg=black
:hi CursorColumn cterm=None ctermbg=yellow ctermfg=white guibg=lightyellow guifg=lightyellow
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline nocursorcolumn
set cursorline nocursorcolumn
:set number
:set cmdheight=2
:set laststatus=2
:set statusline=%F%m%r%h%w\ 
"set statusline+=%{fugitive#statusline()}\    
:set statusline+=[%{strlen(&fenc)?&fenc:&enc}]
:set statusline+=\ [line\ %l\/%L:%c]          
"set statusline+=%{rvm#statusline()}    
:set wildmenu
:set wildmode=longest,list,full
:set hidden
:set showmatch "
:set lazyredraw "
" deactivate syntax for file greater than 90k
au BufReadPost * if getfsize(bufname("%")) > 90*1024 | 
\ set syntax= |
\ endif
:set noexpandtab
:set tabstop=4
:set shiftwidth=4
:set backspace=indent,eol,start
":nnoremap zt zt
":nnoremap zb zb
":nnoremap yt zt
":nnoremap yb zb
":nnoremap z y

":map <C-q> <Esc>:qa!<CR>
:map <C-i> <C-q>
:nnoremap ö :
:nnoremap Z Y
:nnoremap zz yy
:nnoremap :q+ :q!
:nnoremap :wq+ :wq!
:nnoremap :w+ :w!
:noremap ° ~
:nnoremap ä "
:nnoremap à `
:nnoremap é ;
:noremap ç $
:noremap ' `
:noremap _ ?
:noremap - /
:set nowrap
:set scrolloff=5 " keep 10 lines (top/bottom) for scope
":auto BufEnter * let &titlestring = "vi" . strpart(v:servername, 3, 1) . " %t     " . expand("%:p:h:h:t") . "\\" . expand("%:p:h:t") . " %=%l/%L-%P "
:set title
:auto BufEnter * let &titlestring = "vim - " .$USER . "@" . hostname() . ":" . expand('%:p')

au BufNewFile,BufRead *.json set filetype=json
au BufNewFile,BufRead *.java set filetype=java
au BufNewFile,BufRead *.js set filetype=javascript
au BufNewFile,BufRead *.item set filetype=xml
au BufNewFile,BufRead *.viz set filetype=dot
au BufNewFile,BufRead *.wsdl set filetype=xml
au BufNewFile,BufRead *.log set filetype=messages
au BufNewFile,BufRead *.tjp set filetype=tjp
au BufNewFile,BufRead *.tji set filetype=tjp
:set cpo=aABceFs$
"set directory=$RCD/.tmp/vim/directory,.
set directory=$RCD/.tmp/vim/directory,.
set backupdir=$RCD/.tmp/vim/backupdir,.
set undodir=$RCD/.tmp/vim/undodir
set undofile
set viminfo+=n$RCD/.tmp/vim/viminfo

"colorscheme desert
let g:lucius_no_term_bg=1 " s'assure que le colorscheme lucius ne set pas le background color
"colorscheme desert
try
    colorscheme lucius
    LuciusLight
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
    " deal with it
endtry
set guifont=Consolas:h10
:set sidescroll=1 listchars=extends:>,precedes:< sidescrolloff=6
:nmap <silent> <C-k> :wincmd k<CR>
:nmap <silent> <C-j> :wincmd j<CR>
:nmap <silent> <C-h> :wincmd h<CR>
:nmap <silent> <C-l> :wincmd l<CR>
" http://vimdoc.sourceforge.net/htmldoc/cmdline.html#filename-modifiers
" http://stackoverflow.com/questions/3712725/can-i-change-vim-completion-preview-window-height
:set previewheight=30
au BufEnter ?* call PreviewHeightWorkAround()
func PreviewHeightWorkAround()
    if &previewwindow
        exec 'setlocal winheight='.&previewheight
    endif
endfunc
":nmap <F6> :w<CR>:silent !chmod +x %:p<CR>:silent !%:p 2>&1 \| tee d:/tmp/%:t.tmp<CR>:silent! :bd! d:/tmp/%:t.tmp<CR>:sview d:/tmp/%:t.tmp<CR>:redraw!<CR>
":nmap <F6> :w<CR>:silent !chmod +x %:p<CR>:silent !%:p 2>&1 \| tee ~/.vim/output<CR>:silent! :bd output<CR>:sview ~/.vim/output<CR>:redraw!<CR>



":nmap <F6> :w<CR>:silent !chmod +x %:p<CR>:silent !%:p 2>&1 \| tee /tmp/%:t.tmp<CR>:pedit! +:42343234 /tmp/%:t.tmp<CR>:redraw!<CR><CR>
":nmap <F6> :pc!<CR>:w<CR>:silent !chmod +x %:p<CR>:silent !%:p 2>&1 \| tee /tmp/%:t.tmp<CR>:pedit! +:42343234 /tmp/%:t.tmp<CR>:redraw!<CR><CR>
":nmap <F7> :pc!<CR>:w<CR>:pedit! +:42343234 `vim-exec.sh %:p`<CR>:redraw!<CR><CR>
"let g:mrf6oldbuffer=""
"if has('vim') 
if version >= 500
    func MrF6()
        pc!
        if exists("g:mrf6oldbuffer")
            exec "silent bw! " g:mrf6oldbuffer
        end
        w!
        "silent !chmod +x %:p
        let a:output= $RCD . "/.tmp/vim/output/" . strftime("%Y.%m.%d-%H.%M.%S") . "-" . expand("%:t") . ".tmp"
        let g:mrf6oldbuffer=a:output
        silent !clear
        ":exec "silent !%:p 2>&1 \| tee" a:output 
        :exec "silent !" . $RCD . "/bin/notinpath/vimf6.sh %:p " . a:output 
        :exec "pedit! +setlocal\\ buftype=nofile " . a:output
        ":exec "silent AnsiEsc"
        
        silent redraw!
    endfunc
endif
:nmap <F6> :call MrF6()<CR><CR>
":nmap <F7> :pc!<CR>:let a:x=`date +'%Y'`<CR>:w<CR>:silent !chmod +x %:p<CR>:execute "silent !%:p 2>&1 \| tee /tmp/" . x . ".tmp"<CR>:pedit! +:42343234 /tmp/%:t.tmp<CR>:redraw!<CR><CR>



:command MrConfluence :TOhtml | :%!html2confluencewiki_bis.py
:command MrAlign0space :AlignCtrl "Ilp0P0=" '='
:command MrAlign0left1right :AlignCtrl "Ilp0P1" '='
:command MrAlign1left1right :AlignCtrl "Ilp1P0" '='
:command MrAlign1space :AlignCtrl "Ilp1P1=" '='
:command MrAlign2space :AlignCtrl "Ilp2P2=" '='
:command MrAlign3space :AlignCtrl "Ilp3P3=" '='
:command! -range=% MrAlignSql <line1>,<line2>Align! CW \(--\s|\|\<as\s\+\w\+\(,\|\s\|$\)\) -- fsdafsdfsdk | norm! ``
command -range=% RemoveTrailingWhitespace <line1>,<line2>s/\(\s\| \)\+$// | norm! ``
command -range=% RT                       <line1>,<line2>RemoveTrailingWhitespace
command -range=% MrMergeSingleQuote      :<line1>,<line2>!merge_single_quote.py
command -range=% MrMergeComma            :<line1>,<line2>!merge_comma.py
" See :h :tohtml and my application which is to use with html2confluence
" script
"By default, valid HTML 4.01 using cascading style sheets (CSS1) is generated.
"if you need to generate markup for really old browsers or some other user
"agent that lacks basic CSS support, use: >
let g:html_use_css=0
" By default "<pre>" and "</pre>" is used around the text.  This makes it show
" up as you see it in Vim, but without wrapping.    If you prefer wrapping, at the
" risk of making some things look a bit different, use: >
let g:html_no_pre=1

" Buffers - explore/next/previous: Alt-F12, F12, Shift-F12.
nnoremap <silent> <F12> :BufExplorer<CR>
" http://vim.wikia.com/wiki/Fix_syntax_highlighting
noremap <F11> <Esc>:syntax sync fromstart<CR>
inoremap <F11> <C-o>:syntax sync fromstart<CR>

map <F10> :set paste! wrap! number!<CR>:GitGutterToggle<CR>
map <F7> :GitGutterPrevHunk<CR>
map <F8> :GitGutterNextHunk<CR>
map <F9> :GitGutterPreviewHunk<CR>
:command Gstagehunk :GitGutterStageHunk
:command Gundohunk :GitGutterUndoHunk
set nocp

nnoremap    <F2> :<C-U>setlocal lcs=tab:>-,trail:-,eol:$ list! list? <CR>

"let g:dbext_default_profile_ORA         = 'type=ORA:user=pretim:passwd=michel:host=gmadora05:dbname=gma3d.groupemutuel.ch'

":colorscheme desert256
if s:sys == "Linux"
elseif s:sys == "Cygwin_NT""
endif
if s:sys == "Cygwin_NT""
    map <C-x>  y: call system("xclip -i -selection clipboard", getreg("\""))<CR>
    "vmap <C-c> y: call system("xclip -i -selection clipboard", getreg("\""))<CR>
    "map <C-c> Y: call system("xclip -i -selection clipboard", getreg("\""))<CR>
    map <C-c> "*yy
    map <C-a> "*1,$y
    "vmap <C-a> :1,$y<CR>:call system("xclip -i -selection clipboard", getreg("\""))<CR>
    "map <C-a> :1,$y<CR>:call system("xclip -i -selection clipboard", getreg("\""))<CR>
    nmap <C-v> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>P
else
    nmap <C-b> :%d+<CR>"*p<CR>:diffupdate<CR>
    nmap <C-x> :%y+<CR>
    vmap <C-c> "*yy
    nmap <C-c> "*yy
    "vmap <C-a> :1,$y<CR>:call system("xclip -i -selection clipboard", getreg("\""))<CR>
    "nmap <C-a> :1,$y<CR>:call system("xclip -i -selection clipboard", getreg("\""))<CR>
    map <C-v> o<Esc>"*p
endif
imap <C-v> <Esc><C-v>a
:set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

inoremap <ScrollWheelUp> <Nop> 
inoremap <ScrollWheelDown> <Nop> 

func MrSyntaxRange()
    try
        call SyntaxRange#Include('@begin=css@'       ,'@end=css@'       ,'css'       ,'NonText')
        call SyntaxRange#Include('@begin=docker@'    ,'@end=docker@'    ,'Dockerfile','NonText')
        call SyntaxRange#Include('@begin=html@'      ,'@end=html@'      ,'html'      ,'NonText')
        call SyntaxRange#Include('@begin=javascript@','@end=javascript@','javascript','NonText')
        call SyntaxRange#Include('@begin=json@'      ,'@end=json@'      ,'javascript','NonText')
        call SyntaxRange#Include('@begin=puppet@'    ,'@end=puppet@'    ,'puppet',    'NonText')
        call SyntaxRange#Include('@begin=python@'    ,'@end=python@'    ,'python'    ,'NonText')
        call SyntaxRange#Include('@begin=ruby@'      ,'@end=ruby@'      ,'ruby',      'NonText')
        call SyntaxRange#Include('@begin=sh@'        ,'@end=sh@'        ,'sh'        ,'NonText')
        call SyntaxRange#Include('@begin=sql@'       ,'@end=sql@'       ,'sql'       ,'NonText')
        call SyntaxRange#Include('@begin=xml@'       ,'@end=xml@'       ,'xml'       ,'NonText')
        call SyntaxRange#Include('@begin=yaml@'      ,'@end=yaml@'      ,'yaml',      'NonText')
    catch /^Vim\%((\a\+)\)\=:E117/
        " deal with it
    catch /^Vim\%((\a\+)\)\=:E484/
        " deal with it
    endtry
endfunc

fun! UpByIndent()
    norm! ^
    let start_col = col(".")
    let col = start_col
    while col >= start_col
        norm! k^
        if getline(".") =~# '^\s*$'
            let col = start_col
        elseif col(".") <= 1
            return
        else
            let col = col(".")
        endif
    endwhile
endfun

"http://lglinux.blogspot.ch/2008/01/rewrapping-paragraphs-in-vim.html
"map <C-q> {gq} 
map <C-j> gq} '.

nnoremap <c-p> :call UpByIndent()<cr>
:autocmd Syntax * call MrSyntaxRange()
