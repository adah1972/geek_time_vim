set enc=utf-8
set nocompatible
source $VIMRUNTIME/vimrc_example.vim

set nobackup
set undodir=~/.vim/undodir

if !isdirectory(&undodir)
  call mkdir(&undodir, 'p', 0700)
endif
