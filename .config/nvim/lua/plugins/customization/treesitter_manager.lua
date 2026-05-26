return {
  "romus204/tree-sitter-manager.nvim",
  --cmd = { "TSInstall", "TSUpdate", "TSRemove" },
  opts = {
    ensure_installed = { 
      "lua", "vim", "vimdoc", "javascript", "typescript", "python", "html", "css" 
    },
    auto_install = true,
    highlight = {
      enable = true,
    },
  },
}
