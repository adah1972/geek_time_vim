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

set fileencodings=ucs-bom,utf-8,gb18030,latin1
set scrolloff=1
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
