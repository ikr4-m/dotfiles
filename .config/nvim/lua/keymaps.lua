-- General keymaps
vim.api.nvim_set_keymap("n", "x", "_d", { noremap = true, desc = "Fix X can cut" })
vim.api.nvim_set_keymap("n", "<Leader>v", "<C-v>", { noremap = true, desc = "Fix <C-v> in WSL" })
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true, desc = "Escape from terminal" })

-- Resize vertical window
vim.api.nvim_set_keymap("n", "<A-h>", ":vertical resize +1<CR>", { noremap = true, silent = true, desc = "Increase vertical window width" })
vim.api.nvim_set_keymap("n", "<A-l>", ":vertical resize -1<CR>", { noremap = true, silent = true, desc = "Decrease vertical window width" })
vim.api.nvim_set_keymap("n", "<C-h>", ":vertical resize +50<CR>", { noremap = true, silent = true, desc = "Increase vertical window width (large)" })
vim.api.nvim_set_keymap("n", "<C-l>", ":vertical resize -50<CR>", { noremap = true, silent = true, desc = "Decrease vertical window width (large)" })

-- Expand horizontal window
vim.api.nvim_set_keymap("n", "<Leader>w", "<C-w>_", { noremap = true, desc = "Maximize window horizontally" })
vim.api.nvim_set_keymap("n", "<Leader>q", "<C-w>=", { noremap = true, desc = "Equalize window sizes" })

-- Wrap text
vim.api.nvim_set_keymap("n", "<Leader>p", ":set wrap<CR>", { noremap = true, desc = "Enable wrap" })
vim.api.nvim_set_keymap("n", "<Leader><Leader>p", ":set wrap!<CR>", { noremap = true, desc = "Toggle wrap" })

-- Page Up/Down for 60% Keyboard
vim.api.nvim_set_keymap("n", "{", "<PageUp>", { noremap = true, desc = "Page Up" })
vim.api.nvim_set_keymap("n", "}", "<PageDown>", { noremap = true, desc = "Page Down" })

-- Session management
vim.api.nvim_set_keymap("n", "<Leader>d", ":source .vimsession<CR>", { noremap = true, desc = "Load session" })
vim.api.nvim_set_keymap("n", "<Leader>s", ":mks! .vimsession<CR>", { noremap = true, desc = "Save session" })

-- Search and replace
vim.api.nvim_set_keymap("n", "<Leader>r", ":%s /", { noremap = true, desc = "Search and replace" })

-- No Highlight
vim.api.nvim_set_keymap("n", "<Leader><Leader>", ":nohlsearch<CR>", { silent = true })

-- Custom Mapping for tabbing (tabstop/shiftwidth)
for i = 2, 4, 2 do
  vim.api.nvim_set_keymap(
    "n",
    string.format("<Leader>t%is", i),
    string.format(":set sw=%i ts=%i expandtab<CR>", i, i), 
    { noremap = true, desc = string.format("Set softtabstop=%i, tabstop=%i, expandtab", i, i) }
  )
  vim.api.nvim_set_keymap(
    "n",
    string.format("<Leader>t%it", i),
    string.format(":set sw=%i ts=%i noexpandtab<CR>", i, i),
    { noremap = true, desc = string.format("Set softtabstop=%i, tabstop=%i, noexpandtab", i, i) }
  )
end

-- Custom mapping for disable all syntax
vim.api.nvim_set_keymap(
  "n",
  "<Leader>ppp",
  ":syntax off<CR>:filetype off<CR>:filetype plugin off<CR>:filetype indent off<CR>:lua require(\'cmp\').setup.buffer { enabled = false }<CR>",
  { noremap = true, desc = "Disable syntax and filetype detection" }
)

-- "Cursor always center" toggle
vim.g.cursor_center_is_on = false
local function toggle_cursor_centering()
  vim.g.cursor_center_is_on = not vim.g.cursor_center_is_on
  if vim.g.cursor_center_is_on then
    vim.opt.scrolloff = 999
    vim.notify("Cursor Centering: ON", vim.log.levels.INFO)
  else
    vim.opt.scrolloff = 0
    vim.notify("Cursor Centering: OFF", vim.log.levels.INFO)
  end
end
if vim.g.cursor_center_is_on then
  vim.opt.scrolloff = 999
else
  vim.opt.scrolloff = 0
end
vim.keymap.set("n", "<Leader>cc", toggle_cursor_centering, {
  noremap = true,
  silent = true,
  desc = "Toggle cursor centering (scrolloff)",
})
