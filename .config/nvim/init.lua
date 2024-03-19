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
    "rcarriga/nvim-notify",
    config = function ()
      require('notify').setup({
        timeout = 3000,
        max_width = 60,
      })
    end,
  },
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
        nnoremap <Leader>fn <cmd>Telescope notify<cr>
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
          view = "hover",
        },
      })
    end,
  },

  --------------------------
  -- LSP
  --------------------------
  "folke/trouble.nvim",
  {
    "elkowar/yuck.vim",
    event = "VeryLazy",
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    init = function ()
      local lspconfig = require('lspconfig')
      lspconfig.tsserver.setup({})
      lspconfig.eslint.setup({})
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-nvim-lsp-signature-help'
    },
    config = function ()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        window = {
          --completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
              feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_words_before() then
              cmp.complete()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
              feedkey("<Plug>(vsnip-jump-prev)", "")
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
          { name = 'nvim_lsp_signature_help' },
        }, {
          { name = 'buffer' },
        })
      })
      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end,
  },
  {
    "lewis6991/hover.nvim",
    event = "VeryLazy",
    config = function ()
      require('hover').setup({
        init = function()
          require("hover.providers.lsp")
        end,
        preview_opts = {
          border = 'single'
        },
        preview_window = false,
        title = true,
        mouse_providers = {
            'LSP'
        },
        mouse_delay = 1000
      })
      -- Setup keymaps
      vim.keymap.set("n", "K", require("hover").hover, {desc = "hover.nvim"})
      vim.keymap.set("n", "gK", require("hover").hover_select, {desc = "hover.nvim (select)"})
      vim.keymap.set("n", "<C-p>", function() require("hover").hover_switch("previous") end, {desc = "hover.nvim (previous source)"})
      vim.keymap.set("n", "<C-n>", function() require("hover").hover_switch("next") end, {desc = "hover.nvim (next source)"})
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
