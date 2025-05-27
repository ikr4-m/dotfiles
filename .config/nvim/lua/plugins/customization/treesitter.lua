return {
  "nvim-treesitter/nvim-treesitter",
  ensure_installed = { "c", "lua", "vim", "query", "markdown", "markdown_inline" },
  build = ":TSUpdate",
  config = function ()
    require'nvim-treesitter.configs'.setup {
      sync_install = false,
      auto_install = true,
    }
  end,
}