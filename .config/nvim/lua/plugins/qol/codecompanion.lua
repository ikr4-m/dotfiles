return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "j-hui/fidget.nvim",
    "ravitemer/codecompanion-history.nvim",
    {
      "ravitemer/mcphub.nvim",
      cmd = "MCPHub",
      build = "npm install -g mcp-hub@latest",
      config = true,
    },
    {
      "Davidyz/VectorCode",
      version = "*",
      build = "pipx install vectorcode",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "codecompanion" },
      opts = {
        render_modes = true,
        sign = {
          enabled = false,
        },
      },
    },
  },
  opts = {
    diff = {
      provider = "mini_diff",
    },
    display = {
      action_palette = {
        provider = "default",
      },
      chat = {
        show_references = true,
        show_header_separator = false,
        show_settings = false,
      },
    },
    extensions = {
      history = {
        enabled = true,
        opts = {
          keymap = "aih",
          auto_generate_title = true,
          continue_last_chat = false,
          delete_on_clearing_chat = false,
          picker = "snacks",
          enable_logging = false,
          dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
        },
      },
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true,
        },
      },
      vectorcode = {
        opts = {
          add_tool = true,
        },
      },
    },
    adapters = {
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          model = {
            default = "gemini-2.5-pro-preview-05-06"
          },
          env = {
            api_key = "cmd:cat ~/.config/nvim/secrets/gemini_api.key"
          }
        })
      end,
    },
    strategies = {
      chat = {
        adapter = "gemini"
      },
      inline = {
        adapter = "gemini"
      },
    }
  },
  init = function()
    vim.cmd([[ cab cc CodeCompanion ]])
  end
}
