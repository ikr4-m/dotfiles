return {
  "echasnovski/mini.diff", -- Inline and better diff over the default
  config = function()
    local diff = require("mini.diff")
    diff.setup({
      -- Disabled by default
      source = diff.gen_source.none(),
    })
  end,
}