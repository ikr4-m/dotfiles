" Setter
set autoindent
set number
set cul
set ttyfast
set cursorline
set smartindent
set linebreak
set showmatch
set showtabline=1
set mouse=a
set tabstop=2 shiftwidth=2 softtabstop=2
set wrap!
set cmdheight=1
set hidden
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c
set expandtab
set guifont=Hack\ Nerd\ Font:h8

if has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

" Variable Setter
let g:vim_markdown_conceal = 0
