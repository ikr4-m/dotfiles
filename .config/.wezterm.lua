  -- Pull in the wezterm API
local wezterm = require 'wezterm'

local act = wezterm.action
local mux = wezterm.mux
local pane_intensity = 4

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

config.color_scheme = 'nord'
config.font = wezterm.font 'Hack Nerd Font'

config.adjust_window_size_when_changing_font_size = false
config.use_fancy_tab_bar = false
config.enable_wayland = true
config.hide_tab_bar_if_only_one_tab = true

config.audible_bell = "Disabled"
config.font_size = 16.0

--config.default_domain = 'WSL:ArchWSL'
--config.wsl_domains = {
--    {
--        name = 'WSL:ArchWSL',
--        distribution = 'ArchWSL',
--        default_cwd = '~'
--    }
--}
--- Set Pwsh as the default on Windows
-- config.default_prog = { 'powershell.exe' }

-- config.use_ime = false
config.window_decorations = "RESIZE"

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.keys = {
  {
    key = 'd',
    mods = 'ALT',
    action = wezterm.action.SplitHorizontal {
      domain = 'CurrentPaneDomain',
      cwd = '~',
    },
  },
  {
    key = 's',
    mods = 'ALT',
    action = wezterm.action.SplitVertical {
      domain = 'CurrentPaneDomain',
      cwd = '~',
    },
  },
  {
    key = 't',
    mods = 'ALT',
    action = wezterm.action.SpawnCommandInNewTab {
      cwd = '~',
    },
  },
  {
    key = 't',
    mods = 'ALT|SHIFT',
    action = wezterm.action.SpawnCommandInNewTab {
      cwd = '~',
    },
  },
  {
    key = 'w',
    mods = 'ALT',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  {
    key = 'w',
    mods = 'ALT|SHIFT',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },
  {
    key = 'e',
    mods = 'ALT',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key = 'e',
    mods = 'ALT|SHIFT',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
  {
    key = 'p',
    mods = 'ALT',
    action = wezterm.action.ActivateLastTab,
  },
  {
    key = 'h',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Down',
  },
  {
    key = 'h',
    mods = 'ALT|SHIFT',
    action = act.AdjustPaneSize { 'Left', 2 * pane_intensity },
  },
  {
    key = 'l',
    mods = 'ALT|SHIFT',
    action = act.AdjustPaneSize { 'Right', 2 * pane_intensity },
  },
  {
    key = 'k',
    mods = 'ALT|SHIFT',
    action = act.AdjustPaneSize { 'Up', 1 * pane_intensity },
  },
  {
    key = 'j',
    mods = 'ALT|SHIFT',
    action = act.AdjustPaneSize { 'Down', 1 * pane_intensity },
  },
  {
    key = ',',
    mods = 'ALT',
    action = act.MoveTabRelative(-1)
  },
  {
    key = '.',
    mods = 'ALT',
    action = act.MoveTabRelative(1)
  },

-- switch active tab
{ key = '[', mods = 'ALT', action = act.ActivateTabRelative(-1)},
{ key = ']', mods = 'ALT', action = act.ActivateTabRelative(1)},

  {
    key = '8',
    mods = 'CTRL',
    action = act.PaneSelect
  },
  {
    key = '9',
    mods = 'CTRL',
    action = act.PaneSelect {
      alphabet = '1234567890',
    },
  },
  {
    key = '0',
    mods = 'CTRL',
    action = act.PaneSelect {
      -- mode = 'SwapWithActive',
      mode = 'SwapWithActiveKeepFocus',
    },
  },
  {
    key = 'b',
    mods = 'ALT|SHIFT',
    action = act.RotatePanes 'CounterClockwise',
  },
  { key = 'n', mods = 'CTRL|SHIFT', action = act.RotatePanes 'Clockwise' },
  {
    key = 'g',
    mods = 'ALT',
    action = wezterm.action.Search { Regex = '[a-f0-9]{6,}' },
  },
  -- { key = 'a', mods = 'ALT', action = wezterm.action.QuickSelect },
  -- { key = 'z', mods = 'ALT', action = wezterm.action.ActivateCopyMode },
}

for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'ALT',
    action = act.ActivateTab(i - 1),
  })

  table.insert(config.keys, {
    key = tostring(i),
    mods = 'CTRL',
    action = act.ActivateTab(i - 1),
  })

  -- F1 through F8 to activate that tab
  -- table.insert(config.keys, {
  --   key = 'F' .. tostring(i),
  --   action = act.ActivateTab(i - 1),
  -- })
end

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window{}
  window:gui_window():maximize()
end)

-- and finally, return the configuration to wezterm
return config
