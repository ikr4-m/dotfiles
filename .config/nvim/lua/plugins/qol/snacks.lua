return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true, replace_netrw = true, },
    input = { enabled = true },
    indent = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  init = function ()
    vim.keymap.set(
      "n", "<C-t>",
      function()
        Snacks.explorer({ auto_close = true })
      end, 
      { desc = "Open Snacks Explorer" }
    )
  end
}
