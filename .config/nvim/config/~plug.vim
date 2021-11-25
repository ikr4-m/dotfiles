call plug#begin('~/.vim/plug')

" airline
Plug 'vim-airline/vim-airline'
" vim-startify
Plug 'mhinz/vim-startify'
" vim.coc
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" vim-devicons
Plug 'ryanoasis/vim-devicons'
" emmet-vim
Plug 'mattn/emmet-vim'
" Indentline
Plug 'Yggdroot/indentLine'
" ctrlp
Plug 'ctrlpvim/ctrlp.vim'
" polyglot
Plug 'sheerun/vim-polyglot'
" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm i' }
" yuck
Plug 'elkowar/yuck.vim'

" Rest of theme here
" shades-of-purple
Plug 'Rigellute/shades-of-purple.vim'
" Sonokai
Plug 'sainnhe/sonokai'

call plug#end()

