return {
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
}