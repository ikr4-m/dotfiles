return {
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function ()
    require("mason").setup({})
    require("mason-lspconfig").setup({})
    vim.keymap.set("n", "R", vim.lsp.buf.references, { noremap = true, silent = true })
  end,
}
