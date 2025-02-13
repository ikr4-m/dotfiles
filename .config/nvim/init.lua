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
    'IogaMaster/neocord',
    event = "VeryLazy",
    config = function ()
      require("neocord").setup({
        show_time = true,
        global_timer = false,
        editing_text = "Editing %s",
        file_explorer_text = "Browsing %s",
        git_commit_text = "Committing changes",
        plugin_manager_text = "Managing plugins",
        reading_text = "Reading %s",
        workspace_text = "Working on %s",
        line_number_text = "Line %s out of %s",
        terminal_text = "Using Terminal",
      })
    end,
  },
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
  "sindrets/diffview.nvim",
  "j-hui/fidget.nvim",
  {
    "Exafunction/codeium.vim",
    config = function ()
      vim.g.codeium_enabled = false
      vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    init = function ()
      vim.api.nvim_set_keymap("n", "<C-t>", ":Neotree toggle<CR>", { noremap = true })
    end
  },
  {
    "sheerun/vim-polyglot",
    init = function ()
      vim.g.polyglot_disabled = { 'markdown' }
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
    "kelly-lin/ranger.nvim",
    config = function()
      require("ranger-nvim").setup({ replace_netrw = true })
      vim.api.nvim_set_keymap("n", "<leader>e", "", {
        noremap = true,
        callback = function()
          require("ranger-nvim").open(true)
        end,
      })
    end,
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
      ]])
    end,
  },
  {
    "vigoux/notifier.nvim",
    init = function ()
      require('notifier').setup({})
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
          view = "cmdline_popup",
        },
      })
    end,
  },

  --------------------------
  -- LSP
  --------------------------
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "elkowar/yuck.vim",
    event = "VeryLazy",
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    init = function ()
      local lspconfig = require('lspconfig')

      -- JavaScript
      lspconfig.ts_ls.setup({})
      lspconfig.eslint.setup({})

      -- PHP
      lspconfig.intelephense.setup({})

      -- Nix
      lspconfig.nixd.setup({})

      -- Golang
      lspconfig.gopls.setup({})

      -- Csharp
      lspconfig.csharp_ls.setup({})

      -- Python
      lspconfig.pylsp.setup({})
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-signature-help'
    },
    config = function ()
      local cmp = require('cmp')
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
      end

      cmp.setup({
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
            elseif has_words_before() then
              cmp.complete()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
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
    'patrickpichler/hovercraft.nvim',
    event = "VeryLazy",
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },
    opts = function()
      return {
        providers = {
          providers = {
            {
              'LSP',
              require('hovercraft.provider.lsp.hover').new(),
            },
          }
        },
        window = {
          border = 'single',
        },
        keys = {
          { '<C-u>',   function() require('hovercraft').scroll({ delta = -4 }) end },
          { '<C-d>',   function() require('hovercraft').scroll({ delta = 4 }) end },
          { '<TAB>',   function() require('hovercraft').hover_next() end },
          { '<S-TAB>', function() require('hovercraft').hover_next({ step = -1 }) end },
        }
      }
    end,
    keys = {
      { "K", function()
        local hovercraft = require("hovercraft")
        if hovercraft.is_visible() then
          hovercraft.enter_popup()
        else
          hovercraft.hover()
        end
      end },
    },
  },

})

-- Setter
vim.cmd([[
  set autoindent
  set number
  set relativenumber
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

-- Setter for transparent background
vim.cmd([[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]])

-- Autoterminal command
vim.cmd([[
    " Enter Terminal-mode (insert) automatically
    autocmd TermOpen * startinsert
    " Disables number lines on terminal buffers
    autocmd TermOpen * :set nonumber norelativenumber
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
