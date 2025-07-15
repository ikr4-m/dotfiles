return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  init = function ()
    vim.keymap.set("n", "<Leader>ff", ":FzfLua builtin<CR>", { desc = "FZF Lua Menu", silent = true })
    vim.keymap.set("n", "<Leader>fs", ":FzfLua files<CR>", { desc = "FZF Files", silent = true })
    vim.keymap.set("n", "<Leader>fg", ":FzfLua live_grep<CR>", { desc = "FZF Live Grep", silent = true })
    vim.keymap.set("n", "<Leader>fr", ":FzfLua resume<CR>", { desc = "FZF Live Grep", silent = true })

    require("fzf-lua").setup({
      grep = {
        rg_opts = "--sort-files --hidden --column --line-number --no-heading " ..
                  "--color=always --smart-case -g '!{.git,node_modules}/*'",
      }
    })
  end
}
