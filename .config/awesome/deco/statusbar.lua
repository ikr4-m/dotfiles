-- Standard awesome library
local gears = require("gears")
local awful     = require("awful")

-- Wibox handling library
local wibox = require("wibox")

-- Custom Local Library: Common Functional Decoration
local deco = {
  taglist   = require("deco.taglist"),
  tasklist  = require("deco.tasklist")
}

local taglist_buttons  = deco.taglist()
local tasklist_buttons = deco.tasklist()

local show_statusbar = RC.vars.statusbar

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

if show_statusbar == true then
  -- {{{ Wibar
  -- Create a textclock widget
  mytextclock = wibox.widget.textclock()

  awful.screen.connect_for_each_screen(function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
      awful.button({ }, 1, function () awful.layout.inc( 1) end),
      awful.button({ }, 3, function () awful.layout.inc(-1) end),
      awful.button({ }, 4, function () awful.layout.inc( 1) end),
      awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
      screen  = s,
      filter  = awful.widget.taglist.filter.all,
      buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
      screen  = s,
      filter  = awful.widget.tasklist.filter.currenttags,
      buttons = tasklist_buttons
    }

    -- Create a margin
    s.margin = {
      widget = wibox.container.margin,
      left = 2,
      right = 2
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
      layout = wibox.layout.align.horizontal,
      { -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        RC.launcher,
        s.mytaglist,
        s.mypromptbox,
      },
      s.mytasklist, -- Middle widget
      { -- Right widgets
        layout = wibox.layout.fixed.horizontal,
        mykeyboardlayout,
        mytextclock,
        s.margin,
        awful.widget.watch('bash -c ~/.config/shellexecutor/wifi/parser.sh', 5),
        s.margin,
        awful.widget.watch('bash -c ~/.config/shellexecutor/cpu/pretty.sh', 2),
        s.margin,
        awful.widget.watch('bash -c ~/.config/shellexecutor/brightness/simple.sh', 1),
        s.margin,
        awful.widget.watch('bash -c ~/.config/shellexecutor/volume/simple.sh', 1),
        s.margin,
        wibox.widget.systray(),
        s.mylayoutbox
      },
    }
  end)
  -- }}}
end
