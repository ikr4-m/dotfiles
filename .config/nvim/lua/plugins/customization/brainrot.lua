return {
  "sahaj-b/brainrot.nvim",
  event = "VeryLazy",
  dependencies = {
    {
      "3rd/image.nvim",
      init = function ()
        require("image").setup({
          backend = "kitty", -- or "ueberzug" or "sixel"
          processor = "magick_cli", -- or "magick_rock"
        })
      end
    },
  },
  opts = {
    disable_phonk = false,    -- skip phonk/overlay on "no errors"
    phonk_time = 2.5,         -- seconds the phonk/image overlay stays
    min_error_duration = 0.5, -- minimum seconds errors must exist before phonk triggers (0 = instant)
    block_input = true,       -- block input during phonk/overlay
    dim_level = 60,           -- phonk overlay darkness 0..100

    sound_enabled = true,     -- enable sounds
    image_enabled = true,     -- enable images (needs image.nvim)

    boom_volume = 100,         -- volume for vine boom sound (0..100)
    phonk_volume = 100,        -- volume for phonk sound (0..100)

    --boom_sound = nil,         -- custom boom sound path (e.g., "~/sounds/boom.ogg")
    --phonk_dir = nil,          -- custom phonk folder path (e.g., "~/sounds/phonks")
    --image_dir = nil,          -- custom image folder path (e.g., "~/memes/images")

    lsp_wide = true,         -- track errors workspace-wide(get ALL lsp errors)
  },
}
