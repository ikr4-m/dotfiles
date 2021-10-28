-- Standard awesome library
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- Theme handling library
local beautiful = require("beautiful") -- for awesome.icon

local M = {}  -- menu
local _M = {} -- module

-- reading
-- https://awesomewm.org/apidoc/popups%20and%20bars/awful.menu.html

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- This is used later as the default terminal and editor to run.
-- local terminal = "xfce4-terminal"
local terminal = RC.vars.terminal

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

M.awesome = {
  { "Shortcut", function() 
      hotkeys_popup.show_help(nil, awful.screen.focused()) 
    end },
  { "Manual", terminal .. " -e man awesome" },
  { "Terminal", terminal },
  { "Shutdown", "systemctl poweroff" },
  { "Restart", "reboot" },
  { "Logout", function() awesome.quit() end }
}

M.compositor = {
  { "Turn On", 'bash -c "picom &"' },
  { "Turn Off", "killall picom" }
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()

  -- Main Menu
  local menu_items = {
    { "awesome", M.awesome, beautiful.awesome_subicon },
    { "Terminal (Default)", terminal },
    { "Terminal (urxvt)", "urxvt" },
    { "Compositor", M.compositor, beautiful.awesome_subicon },
  }

  return menu_items
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
