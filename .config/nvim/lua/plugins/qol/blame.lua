return {
  "FabijanZulj/blame.nvim",
  lazy = false,
  config = function()
    require('blame').setup {}
    vim.api.nvim_set_keymap(
      "n", "<Leader>b",
      ":BlameToggle virtual<CR>",
      { silent = true, noremap = true, desc = "Toggle virtual blame" }
    )
  end,
}
