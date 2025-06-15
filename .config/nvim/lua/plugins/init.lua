return {
  --------------------------
  -- Customization
  --------------------------
  require("plugins.customization.lualine"),
  require("plugins.customization.neocord"),
  require("plugins.customization.nord_theme"),
  require("plugins.customization.tabby"),
  require("plugins.customization.treesitter"),

  --------------------------
  -- QOL (Quality of Life)
  --------------------------
  "folke/which-key.nvim",
  "folke/zen-mode.nvim",
  "j-hui/fidget.nvim",
  "Snyssfx/goerr-nvim",
  require("plugins.qol.blame"),
  require("plugins.qol.codecompanion"),
  require("plugins.qol.fzf"),
  require("plugins.qol.gitsigns"),
  require("plugins.qol.illuminate"),
  require("plugins.qol.mini_diff"),
  require("plugins.qol.noice"),
  require("plugins.qol.notifier"),
  require("plugins.qol.snacks"),

  --------------------------
  -- LSP (Language Server Protocol)
  --------------------------
  require("plugins.lsp.hovercraft"),
  require("plugins.lsp.mason"),
  require("plugins.lsp.nvim_cmp"),
  require("plugins.lsp.trouble"),
}
