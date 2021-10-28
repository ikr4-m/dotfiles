-- {{{ Autostart }}}
local awful = require("awful")

-- Resource Configuration
local vars = RC.vars

local cmds =
{
    -- Reinit
    "killall tint2",
    "killall thunar",

    -- Spawner
    "feh --bg-scale \"" .. vars.wallpaper .. "\"",
    "thunar --daemon",
    "xfce4-power-manager &",
    "start-pulseaudio-x11 &",
    "xfsettingsd &",
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &",
    "/usr/lib/xfce4/xfconf/xfconfd &",
    "nm-applet &",

    -- Shell
    RC.vars.statusbar and '' or "bash -c ~/.config/awesome/shell/spawn_tint2.sh"
}

for _,i in pairs(cmds) do
    awful.util.spawn(i)
end
