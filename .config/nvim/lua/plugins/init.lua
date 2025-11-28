return {
  --------------------------
  -- Customization
  --------------------------
  require("plugins.customization.lualine"),
  require("plugins.customization.nord_theme"),
  require("plugins.customization.tabby"),
  require("plugins.customization.treesitter"),
  --require("plugins.customization.brainrot"), -- Enable for fun

  --------------------------
  -- QOL (Quality of Life)
  --------------------------
  "folke/which-key.nvim",
  require("plugins.qol.blame"),
  require("plugins.qol.fzf"),
  require("plugins.qol.snacks"),
  require("plugins.qol.hop"),
  require("plugins.qol.grug_far"),

  --------------------------
  -- LSP (Language Server Protocol)
  --------------------------
  "Snyssfx/goerr-nvim",
  require("plugins.lsp.hovercraft"),
  require("plugins.lsp.mason"),
  require("plugins.lsp.nvim_cmp"),
  require("plugins.lsp.trouble"),
}
