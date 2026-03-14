return {
  "ruifm/gitlinker.nvim",
  requires = "nvim-lua/plenary.nvim",
  config = function()
    require("gitlinker").setup({
      opts = {
        mappings = "<leader>gy" 
      },
    })
  end,
}
