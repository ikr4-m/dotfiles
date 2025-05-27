return {
  "nordtheme/vim",
  init = function ()
    vim.cmd([[
      colorscheme nord
      set termguicolors
    ]])
  end,
}