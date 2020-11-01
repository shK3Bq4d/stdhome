" ex: set expandtab ts=4 sw=4:
if version >= 500
let g:pathogen_disabled = []
let g:mapleader=" "
let s:sys=system('uname -s | perl -pe "chomp"')
let hostname = substitute(system('hostname'), '\n', '', '')
endif
if s:sys == "Cygwin_NT""
    call add(g:pathogen_disabled, 'AutoComplPop')
else
    call add(g:pathogen_disabled, 'ingo-library')
endif
if version >= 500
call add(g:pathogen_disabled, 'AutoComplPop')
let airline#extensions#c_like_langs = ['c', 'cpp', 'cuda', 'go', 'javascript', 'java', 'ld', 'php']
endif
"call add(g:pathogen_disabled, 'youcompleteme')
" should between youcomplete me or autocomplpop
if hostname == $WORK_PC1 || hostname == "bipbip"
    "set complete=.,b,u,]
    "set wildmode=longest,list:longest
    "set completeopt=menu,preview
else
endif
if hostname == "jly200" || hostname == "bipbip"
    let g:airline#extensions#whitespace#mixed_indent_algo = 2
endif
if &diff
    " https://vi.stackexchange.com/questions/2705/create-mappings-that-only-apply-to-diff-mode
	" https://github.com/vim-syntastic/syntastic/issues/822
    " Your setting you want to set when using diff mode.
    "
	if v:false
		set ttyfast
		au FileWritePost * :redraw!
		au TermResponse * :redraw!
		au TextChanged * :redraw!
		au QuickFixCmdPre * :redraw!
		au QuickFixCmdPost * :redraw!
	endif
    "autocmd VimEnter * nnoremap <silent> <c-w>l <c-w>l<cr>:redraw!<cr>
    "autocmd VimEnter * nnoremap <silent> <c-w>h <c-w>h<cr>:redraw!<cr>
	if v:false
		let g:loaded_youcompleteme = 1
		let g:syntastic_check_on_open = 0
		let g:mrdiffmode = "yes you are in mrdiffmode" " :echo g:mrdiffmode
		call add(g:pathogen_disabled, 'vim-gitgutter')
		call add(g:pathogen_disabled, 'syntastic')
		call add(g:pathogen_disabled, 'SyntaxRange')
		call add(g:pathogen_disabled, 'tabular')
		call add(g:pathogen_disabled, 'Align')
		call add(g:pathogen_disabled, 'AnsiEsc')
		call add(g:pathogen_disabled, 'bufexplorer')
		call add(g:pathogen_disabled, 'colorschemes')
		call add(g:pathogen_disabled, 'dockerfile')
		call add(g:pathogen_disabled, 'ingo-library')
		call add(g:pathogen_disabled, 'syntastic')
		call add(g:pathogen_disabled, 'SyntaxRange')
		call add(g:pathogen_disabled, 'tabular')
		call add(g:pathogen_disabled, 'vim-airline')
		call add(g:pathogen_disabled, 'vim-airline-themes')
		call add(g:pathogen_disabled, 'vim-fugitive')
		call add(g:pathogen_disabled, 'vim-gitgutter')
		call add(g:pathogen_disabled, 'vim-indentwise')
		call add(g:pathogen_disabled, 'vim-puppet')
		call add(g:pathogen_disabled, 'youcompleteme')
	endif
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
if version >= 500
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
endif
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
"au WinLeave * set nocursorline nocursorcolumn
"u WinEnter * set cursorline nocursorcolumn
set cursorline nocursorcolumn

" https://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
set colorcolumn=80
"highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%81v.\+/
"match ErrorMsg '\%>80v.\+'

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
:map <C-a> :set cursorcolumn<CR><C-q>
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

"au BufRead,BufNewFile */iaac*/*.yml set filetype=yaml.ansible
au BufNewFile,BufRead *.yaml set expandtab cursorcolumn ts=2 sw=2
au BufNewFile,BufRead *.yml set expandtab cursorcolumn ts=2 sw=2
au BufNewFile,BufRead *.py set expandtab filetype=python
au BufNewFile,BufRead *.json set cursorcolumn ts=2 sw=2 filetype=json
au BufNewFile,BufRead *.java set filetype=java
au BufNewFile,BufRead *.js set filetype=javascript
au BufNewFile,BufRead *.item set filetype=xml
au BufNewFile,BufRead *.viz set filetype=dot
au BufNewFile,BufRead *.wsdl set filetype=xml
au BufNewFile,BufRead *.log set filetype=messages
au BufNewFile,BufRead *.tjp set filetype=tjp
au BufNewFile,BufRead *.tji set filetype=tjp
au BufNewFile,BufRead *.tf set expandtab cursorcolumn ts=2 sw=2
:set cpo=aABceFs$
"set directory=$RCD/.tmp/vim/directory,.
set directory=$RCD/.tmp/vim/directory,.
set backupdir=$RCD/.tmp/vim/backupdir,.
set undodir=$RCD/.tmp/vim/undodir
set undofile
set viminfo+=n$RCD/.tmp/vim/viminfo

"colorscheme desert
if version >= 500
auto BufEnter * let &titlestring = "vim - " .$USER . "@" . hostname() . ":" . expand('%:p')
let g:lucius_no_term_bg=1 " s'assure que le colorscheme lucius ne set pas le background color
"colorscheme desert
try
    let g:lucius_style="light"
    colorscheme lucius
    try
        LuciusLight
    catch /^Vim\%((\a\+)\)\=:E492/
        " old version of Lucius exported the command, now let g:lucius_style="light" is the way to go
    endtry
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
    " deal with it
endtry
endif
set guifont=Consolas:h10
:set sidescroll=1 listchars=extends:>,precedes:< sidescrolloff=6
:nmap <silent> <C-k> :wincmd k<CR>
:nmap <silent> <C-j> :wincmd j<CR>
:nmap <silent> <C-h> :wincmd h<CR>
:nmap <silent> <C-l> :wincmd l<CR>
" http://vimdoc.sourceforge.net/htmldoc/cmdline.html#filename-modifiers
" http://stackoverflow.com/questions/3712725/can-i-change-vim-completion-preview-window-height
:set previewheight=30
if version >= 500
au BufEnter ?* call PreviewHeightWorkAround()
func! PreviewHeightWorkAround()
    if &previewwindow
        exec 'setlocal winheight='.&previewheight
    endif
endfunc
endif
":nmap <F6> :w<CR>:silent !chmod +x %:p<CR>:silent !%:p 2>&1 \| tee d:/tmp/%:t.tmp<CR>:silent! :bd! d:/tmp/%:t.tmp<CR>:sview d:/tmp/%:t.tmp<CR>:redraw!<CR>
":nmap <F6> :w<CR>:silent !chmod +x %:p<CR>:silent !%:p 2>&1 \| tee ~/.vim/output<CR>:silent! :bd output<CR>:sview ~/.vim/output<CR>:redraw!<CR>



":nmap <F6> :w<CR>:silent !chmod +x %:p<CR>:silent !%:p 2>&1 \| tee /tmp/%:t.tmp<CR>:pedit! +:42343234 /tmp/%:t.tmp<CR>:redraw!<CR><CR>
":nmap <F6> :pc!<CR>:w<CR>:silent !chmod +x %:p<CR>:silent !%:p 2>&1 \| tee /tmp/%:t.tmp<CR>:pedit! +:42343234 /tmp/%:t.tmp<CR>:redraw!<CR><CR>
":nmap <F7> :pc!<CR>:w<CR>:pedit! +:42343234 `vim-exec.sh %:p`<CR>:redraw!<CR><CR>
"let g:mrf6oldbuffer=""
"if has('vim')
:map  <F6>      :call MrF6()<CR><CR>
:imap <F6> <Esc>:call MrF6()<CR><CR>
:map  <F5>      :call MrF5()<CR><CR>
:imap <F5> <Esc>:call MrF5()<CR><CR>
:nmap <F3> :AnsiEsc<CR><CR>
":nmap <F7> :pc!<CR>:let a:x=`date +'%Y'`<CR>:w<CR>:silent !chmod +x %:p<CR>:execute "silent !%:p 2>&1 \| tee /tmp/" . x . ".tmp"<CR>:pedit! +:42343234 /tmp/%:t.tmp<CR>:redraw!<CR><CR>

if version >= 500

func! MrBlockToUnicodeFunc()
    :silent! s/|/│/g
    :silent! s/-/─/g
    :silent! s/'/┘/g
    :silent! s/`/└/g
    :silent! s/,/┌/g
    :silent! s/\./┐/g
endfunc
command! -range=% MrBlockToUnicode :<line1>,<line2>:call MrBlockToUnicodeFunc()

func! MrFixWhiteSpaceFunc()
    ":<line1>,<line2>!fix-whitespaces.py &spl
    "exec ":<line1>,<line2>!tr '[:lower:]' '[:upper:]'"
    exec "silent !tac"
endfunc
command! -range=% MrFixWhiteSpace2 :<line1>,<line2>:call MrFixWhiteSpaceFunc()
command! -range=% MrFixWhiteSpace exec ":<line1>,<line2>!fix-whitespaces.py --tab-stops " . &ts

:command! MrConfluence :TOhtml | :%!html2confluencewiki_bis.py
:command! MrAlign0space :AlignCtrl "Ilp0P0=" '='
:command! MrAlign0left1right :AlignCtrl "Ilp0P1" '='
:command! MrAlign1left0right :AlignCtrl "Ilp1P0" '='
:command! MrAlign1left1right :AlignCtrl "Ilp1P1" '='
:command! MrAlign1space :AlignCtrl "Ilp1P1=" '='
:command! MrAlign2space :AlignCtrl "Ilp2P2=" '='
:command! MrAlign3space :AlignCtrl "Ilp3P3=" '='
:command! -range=% MrAlignSql <line1>,<line2>Align! CW \(--\s|\|\<as\s\+\w\+\(,\|\s\|$\)\) -- fsdafsdfsdk | norm! ``
command! -range=% RemoveTrailingWhitespace <line1>,<line2>s/\(\s\| \)\+$// | norm! ``
command! -range=% RT                       <line1>,<line2>RemoveTrailingWhitespace
command! -range=% MrMergeSingleQuote      :<line1>,<line2>!merge_single_quote.py
command! -range=% MrMergeComma            :<line1>,<line2>!merge_comma.py
":command! MrFixWhiteSpace :set expandtab | :silent! %s/[ \t]\+$// | :silent! %s/\t/    /g | norm! ``
:command! -range=% MrTasksFromBullet :silent! <line1>,<line2>g/^\s*\*\s*[^\[ \t]/ s/\*\s\?/* [ ] / | :noh | norm! ``
:command! -range=% MrTasksReset :silent! <line1>,<line2>s/\[.\]/[ ]/ | :noh | norm! ``
:command! MrReloadVimrc :so $MYVIMRC | :noh
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
:command! Gstagehunk :GitGutterStageHunk
:command! Gundohunk :GitGutterUndoHunk
endif

" http://vim.wikia.com/wiki/Fix_syntax_highlighting

nnoremap <F2>      :<C-U>setlocal lcs=tab:>-,trail:-,eol:$ list! list? <CR>
imap     <F2> <Esc>:<C-U>setlocal lcs=tab:>-,trail:-,eol:$ list! list? <CR>
if &diff
    map  <F7>      [c<CR>
    imap <F7> <Esc>[c<CR>
    map  <F8>      ]c<CR>
    imap <F8> <Esc>]c<CR>
    map  <F9>      :diffget<CR>
    imap <F9> <Esc>:diffget<CR>
else
    map  <F7>      :GitGutterPrevHunk<CR>
    imap <F7> <Esc>:GitGutterPrevHunk<CR>
    map  <F8>      :GitGutterNextHunk<CR>
    imap <F8> <Esc>:GitGutterNextHunk<CR>
    map  <F9>      :GitGutterPreviewHunk<CR>
    imap <F9> <Esc>:GitGutterPreviewHunk<CR>
endif
map  <F10>      :set paste! wrap! number!<CR>:GitGutterToggle<CR>:redraw!<CR>
imap <F10> <Esc>:set paste! wrap! number!<CR>:GitGutterToggle<CR>:redraw!<CR>
noremap  <F11> <Esc>:syntax sync fromstart<CR>:autocmd BufEnter <buffer> syntax sync fromstart<CR>
inoremap <F11> <C-o>:syntax sync fromstart<CR>:autocmd BufEnter <buffer> syntax sync fromstart<CR>
nnoremap <silent> <F12>      :BufExplorer<CR>
imap     <silent> <F12> <Esc>:BufExplorer<CR>
set nocp


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
    map <C-s> O<Esc>"*P
endif
imap <C-v> <Esc><C-v>a
:set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

inoremap <ScrollWheelUp> <Nop>
inoremap <ScrollWheelDown> <Nop>

if version >= 500
func! MrSyntaxRange()
    "try
    "    call SyntaxRange#Include('```none'       ,'```'       ,'nosyntax'       ,'NonText')
    "catch /^Vim\%((\a\+)\)\=:E117/
    "    " deal with it
    "catch /^Vim\%((\a\+)\)\=:E484/
    "    " deal with it
    "endtry
    try
        call SyntaxRange#Include('```markdown'       ,'```'       ,'markdown'       ,'NonText')
    catch /^Vim\%((\a\+)\)\=:E117/
        " deal with it
    catch /^Vim\%((\a\+)\)\=:E484/
        " deal with it
    endtry
    try
        call SyntaxRange#Include('```css'       ,'```'       ,'css'       ,'NonText')
    catch /^Vim\%((\a\+)\)\=:E117/
        " deal with it
    catch /^Vim\%((\a\+)\)\=:E484/
        " deal with it
    endtry
    try
        call SyntaxRange#Include('```docker'    ,'```'    ,'Dockerfile','NonText')
    catch /^Vim\%((\a\+)\)\=:E117/
        " deal with it
    catch /^Vim\%((\a\+)\)\=:E484/
        " deal with it
    endtry
    try
        call SyntaxRange#Include('```html'      ,'```'      ,'html'      ,'NonText')
    catch /^Vim\%((\a\+)\)\=:E117/
        " deal with it
    catch /^Vim\%((\a\+)\)\=:E484/
        " deal with it
    endtry
    try
        call SyntaxRange#Include('```js','```','javascript','NonText')
        call SyntaxRange#Include('```javascript','```','javascript','NonText')
    catch /^Vim\%((\a\+)\)\=:E117/
        " deal with it
    catch /^Vim\%((\a\+)\)\=:E484/
        " deal with it
    endtry
    try
        call SyntaxRange#Include('```tf'      ,'```'      ,'tf','NonText')
    catch /^Vim\%((\a\+)\)\=:E117/
        " deal with it
    catch /^Vim\%((\a\+)\)\=:E484/
        " deal with it
    endtry
    try
        call SyntaxRange#Include('```json'      ,'```'      ,'javascript','NonText')
    catch /^Vim\%((\a\+)\)\=:E117/
        " deal with it
    catch /^Vim\%((\a\+)\)\=:E484/
        " deal with it
    endtry
    try
        call SyntaxRange#Include('```puppet'    ,'```'    ,'puppet',    'NonText')
    catch /^Vim\%((\a\+)\)\=:E117/
        " deal with it
    catch /^Vim\%((\a\+)\)\=:E484/
        " deal with it
    endtry
    try
        call SyntaxRange#Include('```python'       ,'```'           ,'python'    ,'NonText')
    catch /^Vim\%((\a\+)\)\=:E117/
        " deal with it
    catch /^Vim\%((\a\+)\)\=:E484/
        " deal with it
    endtry
    try
        call SyntaxRange#Include('```sh'        ,'```'        ,'sh'        ,'NonText')
        call SyntaxRange#Include('```bash'        ,'```'        ,'sh'        ,'NonText')
    catch /^Vim\%((\a\+)\)\=:E117/
        " deal with it
    catch /^Vim\%((\a\+)\)\=:E484/
        " deal with it
    endtry
    try
        call SyntaxRange#Include('```ini'       ,'```'       ,'dosini'       ,'NonText')
    catch /^Vim\%((\a\+)\)\=:E117/
        " deal with it
    catch /^Vim\%((\a\+)\)\=:E484/
        " deal with it
    endtry
    try
        call SyntaxRange#Include('```sql'       ,'```'       ,'sql'       ,'NonText')
    catch /^Vim\%((\a\+)\)\=:E117/
        " deal with it
    catch /^Vim\%((\a\+)\)\=:E484/
        " deal with it
    endtry
    try
        call SyntaxRange#Include('```xml'       ,'```'       ,'xml'       ,'NonText')
    catch /^Vim\%((\a\+)\)\=:E117/
        " deal with it
    catch /^Vim\%((\a\+)\)\=:E484/
        " deal with it
    endtry
    try
        call SyntaxRange#Include('```yaml'      ,'```'      ,'yaml',      'NonText')
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
endif

"http://lglinux.blogspot.ch/2008/01/rewrapping-paragraphs-in-vim.html
"map <C-q> {gq}
map <C-j> gq} '.

nnoremap <c-p> :call UpByIndent()<cr>
:autocmd Syntax * call MrSyntaxRange()


" disable mouse interactions "
set mouse=
if empty($SSH_CLIENT) " mintty citrix problem
    set ttymouse=
endif
autocmd BufEnter * set mouse=
map <ScrollWheelUp> <nop>
map <S-ScrollWheelUp> <nop>
map <C-ScrollWheelUp> <nop>
map <ScrollWheelDown> <nop>
map <S-ScrollWheelDown> <nop>
map <C-ScrollWheelDown> <nop>
map <ScrollWheelLeft> <nop>
map <S-ScrollWheelLeft> <nop>
map <C-ScrollWheelLeft> <nop>
map <ScrollWheelRight> <nop>
map <S-ScrollWheelRight> <nop>
map <C-ScrollWheelRight> <nop>
" terminal see tab as C-i
map <C-i> <Esc>:bnext<CR>

:nnoremap <Space>   <C-d>
:nnoremap <C-M-Space> <C-u>
:nnoremap <M-Space> <C-u>
:nnoremap <C-Space> <C-u>

if version >= 500
let g:airline_powerline_fonts = 1
let g:airline_theme='papercolor'
let g:airline#extensions#tabline#enabled = 1
try
    " https://github.com/LucHermitte/local_vimrc
    " _vimrc_local.vim
    call lh#local_vimrc#munge('whitelist', $HOME.'/tmp')
catch /^Vim\%((\a\+)\)\=:E117/
endtry

" https://github.com/vim-syntastic/syntastic
" https://github.com/rodjek/vim-puppet

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_puppet_checkers = ['puppetlint']
let g:syntastic_python_checkers = []
let g:syntastic_ansible_checkers = []
let g:syntastic_javascript_checkers = ['jshint']

function! Py2()
  let g:syntastic_python_python_exec = '/usr/local/bin/python2.7'
endfunction

function! Py3()
  let g:syntastic_python_python_exec = '/usr/local/bin/python3.6'
endfunction

"call Py3()   " default to Py3 because I try to use it when possible
call Py2()   " default to Py2 because of legacy scripts
set clipboard=
try
    :set fixendofline
catch /./
    " no supported in old versions
endtry
:command! En :set spl=en
:command! Fr :set spl=fr
let &t_SI = "\<Esc>[5 q"
let &t_EI = "\<Esc>[1 q"
" :set t_ti=""

let g:tagbar_type_yaml = {
    \ 'ctagstype' : 'yaml',
    \ 'kinds' : [
        \ 'a:anchors',
        \ 's:section',
        \ 'e:entry'
    \ ],
  \ 'sro' : '.',
    \ 'scope2kind': {
      \ 'section': 's',
      \ 'entry': 'e'
    \ },
    \ 'kind2scope': {
      \ 's': 'section',
      \ 'e': 'entry'
    \ },
    \ 'sort' : 0
    \ }

if has ('autocmd') " Remain compatible with earlier versions
 augroup vimrc     " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
  augroup END
endif " has autocmd
endif

if version >= 500
    :function! MrF6()
        pc!
        if exists("g:mrf6oldbuffer")
            exec "silent bw! " g:mrf6oldbuffer
        endif
        w!
        "silent !chmod +x %:p
        let a:output= $RCD . "/.tmp/vim/output/" . strftime("%Y.%m.%d-%H.%M.%S") . "-" . expand("%:t") . ".tmp"
        let g:mrf6oldbuffer=a:output
        silent !clear
        ":exec "silent !%:p 2>&1 \| tee" a:output
        :exec "silent !" . $RCD . "/bin/notinpath/vimf6.sh %:p " . a:output
        :exec "pedit! +setlocal\\ buftype=nofile\\ ft= " . a:output
        if v:true
            noautocmd wincmd p " go to window up
            :2000000           " simulate go to end of file by going to line 2000000
            noautocmd wincmd P " go to windo down
        endif
        ":exec "silent AnsiEsc"

        silent redraw!
        return ""
    endfunc
    :function! MrF5()
        pc!
        if exists("g:mrf6oldbuffer")
            exec "silent bw! " g:mrf6oldbuffer
        endif
        w!
        "silent !chmod +x %:p
        let a:output= $RCD . "/.tmp/vim/output/" . strftime("%Y.%m.%d-%H.%M.%S") . "-" . expand("%:t") . ".tmp"
        let g:mrf6oldbuffer=a:output
        silent !clear
        ":exec "silent !%:p 2>&1 \| tee" a:output
        :exec "silent !" . $RCD . "/bin/notinpath/vimf5.sh %:p " . a:output
        :exec "pedit! +setlocal\\ buftype=nofile\\ ft= " . a:output
        if v:true
            noautocmd wincmd p " go to window up
            :2000000           " simulate go to end of file by going to line 2000000
            noautocmd wincmd P " go to windo down
        endif
        ":exec "silent AnsiEsc"

        silent redraw!
        return ""
    endfunc
endif
if &diff
	set t_Co=8
endif
