-- Initialize lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set Map Leader to space
vim.g.mapleader = " "

-- The rest of plugin
require("lazy").setup({

  --------------------------
  -- Customization
  --------------------------
  "Yggdroot/indentLine",
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = function()
      require('lualine').setup {
        options = { theme = 'nord' }
      }
    end,
  },
  {
    "nordtheme/vim",
    init = function ()
      vim.cmd([[
        colorscheme nord
        set termguicolors
      ]])
    end,
  },

  --------------------------
  -- QOL
  --------------------------
  "folke/which-key.nvim",
  "folke/zen-mode.nvim",
  "sheerun/vim-polyglot",
  "sindrets/diffview.nvim",
  "j-hui/fidget.nvim",
  {
    "nanozuki/tabby.nvim",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function ()
      require('tabby.tabline').use_preset('active_wins_at_tail', {
        nerdfont = true,
        lualine_theme = 'nord',
        tab_name = {
          name_fallback = function(tabid)
            return ''
          end,
        },
        buf_name = {
          mode = 'shorten'
        }
      })
    end,
    init = function ()
      vim.o.showtabline = 2
      vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'

      vim.api.nvim_set_keymap("n", "<leader>ta", ":$tabnew<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>tc", ":tabclose<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>to", ":tabonly<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>tn", ":tabn<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>tp", ":tabp<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>tmp", ":-tabmove<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>tmn", ":+tabmove<CR>", { noremap = true })
    end
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = "VeryLazy",
    config = function ()
      require("nvim-tree").setup()
    end,
    init = function ()
      vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>fe", ":NvimTreeFocus<CR>", { noremap = true })
    end
  },
  {
    "goolord/alpha-nvim",
    config = function ()
      require("alpha").setup(require("alpha.themes.dashboard").config)
    end
  },
  {
    "neoclide/coc.nvim",
    branch = "release",
    init = function()
      local keyset = vim.keymap.set
      vim.cmd([[ 
        " Open coc diagnostic
        nnoremap <Leader>d :CocCommand diagnostic<CR>

        " Diagnostic
        nmap <silent> [g <Plug>(coc-diagnostic-prev)
        nmap <silent> ]g <Plug>(coc-diagnostic-next)
      
        " Definition overload
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)
      ]])

      -- Use Tab for trigger completion with characters ahead and navigate
      -- NOTE: There's always a completion item selected by default, you may want to enable
      -- no select by setting `"suggest.noselect": true` in your configuration file
      -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
      -- other plugins before putting this into your config
      local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
      keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
      keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
      
      -- Make <CR> to accept selected completion item or notify coc.nvim to format
      -- <C-g>u breaks current undo, please make your own choice
      keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
      
      -- Use <c-j> to trigger snippets
      keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
      -- Use <c-space> to trigger completion
      keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})
      
      -- Use K to show documentation in preview window
      function _G.show_docs()
          local cw = vim.fn.expand('<cword>')
          if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
              vim.api.nvim_command('h ' .. cw)
          elseif vim.api.nvim_eval('coc#rpc#ready()') then
              vim.fn.CocActionAsync('doHover')
          else
              vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
          end
      end
      keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "BurntSushi/ripgrep",
      "nvim-telescope/telescope-fzf-native.nvim",
      "sharkdp/fd",
    },
    init = function ()
      vim.cmd([[
        nnoremap <Leader>ff <cmd>Telescope find_files<cr>
        nnoremap <Leader>fg <cmd>Telescope live_grep<cr>
        nnoremap <Leader>fb <cmd>Telescope buffers<cr>
        nnoremap <Leader>fh <cmd>Telescope help_tags<cr>
      ]])
    end,
  },
  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        providers = { "lsp", "treesitter", "regex" },
        delay = 500,
      })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function ()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
        cmdline = {
          view = "cmdline",
        },
      })
    end,
  },

  --------------------------
  -- LSP
  --------------------------
  "dense-analysis/ale",
  "elkowar/yuck.vim",
  {
    "OmniSharp/omnisharp-vim",
    init = function()
      vim.cmd("autocmd FileType cs nnoremap <silent> K :OmniSharpDocumentation<CR>")
      vim.cmd("let g:OmniSharp_server_use_net6 = 1")
    end,
  },

})

-- Setter
vim.cmd([[
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
  set tabstop=2
  set shiftwidth=2
  set softtabstop=2
  set expandtab
  set wrap!
  set cmdheight=1
  set hidden
  set nobackup
  set nowritebackup
  set updatetime=300
  set shortmess+=c
  set guifont=Hack\ Nerd\ Font:h8

  if has("patch-8.1.1564")
    set signcolumn=number
  else
    set signcolumn=yes
  endif 
]])

-- Custom Mapping
vim.cmd([[ 
  " fixing X can cut
  map x "_d<CR>

  " fixing <C-v> in wsl
  nmap <Leader>v <C-v>

  " Escape from terminal
  tmap <Esc> <C-\><C-n>

  " Resize vertical window
  nmap <silent> <A-h> :vertical resize +1<CR>
  nmap <silent> <A-l> :vertical resize -1<CR>
  nmap <silent> <C-h> :vertical resize +50<CR>
  nmap <silent> <C-l> :vertical resize -50<CR>

  " Expand horizontal window
  nmap <space>w <C-w>_
  nmap <space>q <C-w>=

  " Wrap
  nmap <space>p :set wrap<CR>
  nmap <space><space>p : set wrap!<CR>

  " PgDown PgUp for 60% Keyboard
  nmap { <PageUp>
  nmap } <PageDown>

  " Load session
  nmap <space>d :source .vimsession<CR>

  " Save session
  nmap <space>s :mks! .vimsession<CR>

  " Search and replace
  nmap <space>r :%s /
]])
