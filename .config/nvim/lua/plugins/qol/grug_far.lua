return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    { 
      "<leader>gg", 
      function() require("grug-far").open() end, 
      desc = "Search & Replace (Project)" 
    },
    { 
      "<leader>gw", 
      function() 
        require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) 
      end, 
      desc = "Search & Replace Current Word" 
    },
    { 
      "<leader>gr", 
      function() 
        require("grug-far").with_visual_selection() 
      end, 
      mode = "v", 
      desc = "Search & Replace Selection" 
    },
    {
      "<leader>gf",
      function()
        require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
      end,
      desc = "Search & Replace (Current File)"
    }
  },
  opts = {
    headerMaxWidth = 80, 
    debounceMs = 500, 
    transient = true, 
    windowCreationCommand = "botright vsplit",
    keymaps = {
      close = { n = "q" },
      refresh = { n = "R" },
      syncLocations = { n = "<localleader>s" },
      historyOpen = { n = "<localleader>h" },
    },
  },
}
