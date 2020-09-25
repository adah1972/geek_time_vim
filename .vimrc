" vim:set expandtab shiftwidth=2 tabstop=8 textwidth=72:

if exists('$VIM_TERMINAL')
  echoerr 'Do not run Vim inside a Vim terminal'
  quit
endif

if has('autocmd')
  " 为了可以重新执行 vimrc，开头先清除当前组的自动命令
  au!
endif

if has('gui_running')
  " 下面两行仅为占位使用；请填入你自己的字体
  set guifont=
  set guifontwide=

  " 不延迟加载菜单（需要放在下面的 source 语句之前）
  let do_syntax_sel_menu = 1
  let do_no_lazyload_menus = 1
endif

set enc=utf-8
source $VIMRUNTIME/vimrc_example.vim

" 启用 man 插件
source $VIMRUNTIME/ftplugin/man.vim

set fileencodings=ucs-bom,utf-8,gb18030,latin1
set formatoptions+=mM
set keywordprg=:Man
set scrolloff=1
set spelllang+=cjk
set tags=./tags;,tags,/usr/local/etc/systags
set nobackup

if has('persistent_undo')
  set undofile
  set undodir=~/.vim/undodir
  if !isdirectory(&undodir)
    call mkdir(&undodir, 'p', 0700)
  endif
endif

if has('mouse')
  if has('gui_running') || (&term =~ 'xterm' && !has('mac'))
    set mouse=a
  else
    set mouse=nvi
  endif
endif

if !has('gui_running')
  " 设置文本菜单
  if has('wildmenu')
    set wildmenu
    set cpoptions-=<
    set wildcharm=<C-Z>
    nnoremap <F10>      :emenu <C-Z>
    inoremap <F10> <C-O>:emenu <C-Z>
  endif

  " 识别终端的真彩支持
  if has('termguicolors') &&
        \($COLORTERM == 'truecolor' || $COLORTERM == '24bit')
    set termguicolors
  endif
endif

if exists('g:loaded_minpac')
  " Minpac is loaded.
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  " Other plugins
  call minpac#add('adah1972/vim-copy-as-rtf')
  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('junegunn/fzf', {'do': {-> fzf#install()}})
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('majutsushi/tagbar')
  call minpac#add('mbbill/undotree')
  call minpac#add('mg979/vim-visual-multi')
  call minpac#add('preservim/nerdcommenter')
  call minpac#add('preservim/nerdtree')
  call minpac#add('skywind3000/asyncrun.vim')
  call minpac#add('tpope/vim-eunuch')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-repeat')
  call minpac#add('tpope/vim-surround')
  call minpac#add('vim-airline/vim-airline')
  call minpac#add('vim-scripts/SyntaxAttr.vim')
  call minpac#add('yegappan/mru')
endif

if has('eval')
  " Minpac commands
  command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
  command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
  command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

  " 和 asyncrun 一起用的异步 make 命令
  command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
endif

if v:version >= 800
  packadd! editexisting
endif

" 修改光标上下键一次移动一个屏幕行
nnoremap <Up>        gk
inoremap <Up>   <C-O>gk
nnoremap <Down>      gj
inoremap <Down> <C-O>gj

" 切换窗口的键映射
nnoremap <C-Tab>   <C-W>w
inoremap <C-Tab>   <C-O><C-W>w
nnoremap <C-S-Tab> <C-W>W
inoremap <C-S-Tab> <C-O><C-W>W

" 检查光标下字符的语法属性的键映射
nnoremap <Leader>a :call SyntaxAttr()<CR>

" 替换光标下单词的键映射
nnoremap <Leader>v viw"0p
vnoremap <Leader>v    "0p

" 停止搜索高亮的键映射
nnoremap <silent> <F2>      :nohlsearch<CR>
inoremap <silent> <F2> <C-O>:nohlsearch<CR>

" 映射按键来快速启停构建
nnoremap <F5>  :if g:asyncrun_status != 'running'<bar>
                 \if &modifiable<bar>
                   \update<bar>
                 \endif<bar>
                 \exec 'Make'<bar>
               \else<bar>
                 \AsyncStop<bar>
               \endif<CR>

" 开关撤销树的键映射
nnoremap <F6>      :UndotreeToggle<CR>
inoremap <F6> <C-O>:UndotreeToggle<CR>

" 开关 Tagbar 插件的键映射
nnoremap <F9>      :TagbarToggle<CR>
inoremap <F9> <C-O>:TagbarToggle<CR>

" 用于 quickfix、标签和文件跳转的键映射
if !has('mac')
nnoremap <F11>   :cn<CR>
nnoremap <F12>   :cp<CR>
else
nnoremap <D-F11> :cn<CR>
nnoremap <D-F12> :cp<CR>
endif
nnoremap <M-F11> :copen<CR>
nnoremap <M-F12> :cclose<CR>
nnoremap <C-F11> :tn<CR>
nnoremap <C-F12> :tp<CR>
nnoremap <S-F11> :n<CR>
nnoremap <S-F12> :prev<CR>

if has('unix') && !has('gui_running')
  " Unix 终端下使用两下 Esc 来离开终端作业模式
  tnoremap <Esc><Esc> <C-\><C-N>
else
  " 其他环境则使用 Esc 来离开终端作业模式
  tnoremap <Esc>      <C-\><C-N>
  tnoremap <C-V><Esc> <Esc>
endif

if has('autocmd')
  function! GnuIndent()
    setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
    setlocal shiftwidth=2
    setlocal tabstop=8
  endfunction

  " 异步运行命令时打开 quickfix 窗口，高度为 10 行
  let g:asyncrun_open = 10

  " 用于 Airline 的设定
  let g:airline_powerline_fonts = 1  " 如没有安装合适的字体，则应置成 0
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#buffer_nr_show = 1
  let g:airline#extensions#tabline#overflow_marker = '…'
  let g:airline#extensions#tabline#show_tab_nr = 0

  " 非图形环境不使用 NERD Commenter 菜单
  if !has('gui_running')
    let g:NERDMenuMode = 0
  endif

  " 用于 YouCompleteMe 的设定
  let g:ycm_auto_hover = ''
  let g:ycm_filetype_whitelist = {
        \ 'c': 1,
        \ 'cpp': 1,
        \ 'java': 1,
        \ 'python': 1,
        \ 'vim': 1,
        \ 'sh': 1,
        \ 'zsh': 1,
        \ }
  let g:ycm_goto_buffer_command = 'split-or-existing-window'
  let g:ycm_key_invoke_completion = '<C-Z>'
  let g:ycm_use_clangd = 1
  nnoremap <Leader>fi :YcmCompleter FixIt<CR>
  nnoremap <Leader>gt :YcmCompleter GoTo<CR>
  nnoremap <Leader>gd :YcmCompleter GoToDefinition<CR>
  nnoremap <Leader>gh :YcmCompleter GoToDeclaration<CR>
  nnoremap <Leader>gr :YcmCompleter GoToReferences<CR>

  au FileType c,cpp,objc  setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4 cinoptions=:0,g0,(0,w1
  au FileType json        setlocal expandtab shiftwidth=2 softtabstop=2
  au FileType vim         setlocal expandtab shiftwidth=2 softtabstop=2

  au FileType help        nnoremap <buffer> q <C-W>c

  au BufRead /usr/include/*  call GnuIndent()
endif
