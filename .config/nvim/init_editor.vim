call plug#begin('~/.vim/plug')
Plug 'rcarriga/nvim-notify'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
Plug 'neoclide/coc.nvim' 
Plug 'nordtheme/vim'
call plug#end()

" make vim startup more faster
let skip_defaults_vim=1
set viminfo=""

set number
set textwidth=79
set showmatch
set mouse=a
set wrap!

syntax on
colorscheme nord
let g:airline_theme='nord'
set termguicolors
highlight LineNr ctermfg=gray
filetype plugin indent on
set showtabline=2
 
set hlsearch
set smartcase
set ignorecase
set incsearch

set autoindent
set ts=2 sw=2
set expandtab

" set et  " uncomment to use space instead of tab
set smartindent
set smarttab
set noswapfile

" fixing <C-v> in wsl
nmap <Leader>v <C-v>

" hide number in terminal
if has("nvim")
  autocmd TermOpen * setlocal nonumber norelativenumber
endif

" disable rpc
silent exec ":!~/dotfiles/bashrc/exec/nvim_disable_rpc.sh"

map <C-x> :q<CR>
tmap <Esc> <C-\><C-n>
nmap <A-l> :vertical resize +1<CR>
nmap <A-h> :vertical resize -1<CR>

