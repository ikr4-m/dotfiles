return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    {
      "<C-t>",
      function() Snacks.explorer({ auto_close = true }) end, 
      desc = "Open Snacks Explorer",
    },
    {
      "<leader>zz",
      function() Snacks.zen() end,
      desc = "Zen mode"
    },
    {
      "<leader>lg",
      function() Snacks.lazygit() end,
      desc = "Lazygit"
    },
    {
      "<leader>n",
      function() Snacks.notifier.show_history() end,
      desc = "Show notification history"
    },
  },
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true, replace_netrw = true, },
    input = { enabled = true },
    indent = { enabled = true },
    lazygit = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    zen = { enabled = true },
  },
}
