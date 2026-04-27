return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers", -- Focuses on buffers (Scope handles the filtering)
        separator_style = "slant", -- Gives a nice "folder tab" aesthetic
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        color_icons = true,
        
        indicator = {
          icon = '▎', 
          style = 'icon',
        },
      },
    })
  end,
  init = function ()
    vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
    vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
    vim.keymap.set("n", "<leader>C", "<cmd>bdelete<cr>", { desc = "Close Buffer" })
  end,
}
