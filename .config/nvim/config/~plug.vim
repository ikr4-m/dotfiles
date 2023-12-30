call plug#begin('~/.vim/plug')

"""""""""""""""""""""""""""""""
" Customization
" airline
Plug 'vim-airline/vim-airline'
" vim-devicons
Plug 'ryanoasis/vim-devicons'
" Indentline
Plug 'Yggdroot/indentLine'
" polyglot
Plug 'sheerun/vim-polyglot'
" shades-of-purple
Plug 'Rigellute/shades-of-purple.vim'
" Sonokai
Plug 'sainnhe/sonokai'
" Nord
Plug 'nordtheme/vim'

"""""""""""""""""""""""""""""""
" QoL
" vim.coc
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" emmet-vim
Plug 'mattn/emmet-vim'
" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm i' }
" Telescope & Notifier
Plug 'rcarriga/nvim-notify'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
" Noice
Plug 'folke/noice.nvim'
Plug 'MunifTanjim/nui.nvim'
" Illuminate
Plug 'RRethy/vim-illuminate'
" Git Signs
Plug 'lewis6991/gitsigns.nvim'
" Git View
Plug 'sindrets/diffview.nvim'

"""""""""""""""""""""""""""""""
" LSP
" Ale
Plug 'dense-analysis/ale'
" Omnisharp
Plug 'OmniSharp/omnisharp-vim'
" yuck
Plug 'elkowar/yuck.vim'

call plug#end()

" Lua setup
lua require("noice").setup()
lua require("gitsigns").setup()
