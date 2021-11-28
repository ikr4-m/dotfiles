from typing import List  # noqa: F401

import os
import subprocess
import getpass
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

# Configuration here
mod = "mod4"
widget_show = True
myTerm = "alacritty"
myFileExplorer = "thunar"

"""
List shortcut keyboard
"""
def get_user_path(path):
    return "/home/" + getpass.getuser() + "/" + path

keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key(["control", "mod1"], "Tab", lazy.layout.down(), desc="Move focus down, shorthand"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key(["mod1"], "Tab", lazy.layout.next(),
        desc="Move window focus to other window"),
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),

    # Move windows between left/right columns or move up/down in current stack.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(),
        desc="Move window up"),

    ### Treetab controls
    Key([mod, "shift", "control"], "h", lazy.layout.move_left(), desc='Move up a section in treetab'),
    Key([mod, "shift", "control"], "l", lazy.layout.move_right(), desc='Move down a section in treetab'),

    # Manipulate windows
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod, "control"], "n", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "f", lazy.window.toggle_floating(), desc="Toggle floating"),

    # Monitor focus
    Key([mod], "period", lazy.next_screen(), desc='Move focus to next monitor'),
    Key([mod], "comma", lazy.prev_screen(), desc='Move focus to prev monitor'),

    # Launch application
    Key([mod], "Return", lazy.spawn(myTerm), desc="Launch terminal"),
    Key([mod], "r", lazy.spawn("eww open mainmenu"), desc="Open mainmenu"),
    Key([mod], "e", lazy.spawn(myFileExplorer), desc="Open explorer"),
    Key([mod, "control"], "Return", lazy.spawn("slock"), desc="Lock computer"),
    Key([mod, "shift"], "s",
            lazy.spawn("scrot --select -e 'mv $f ~/Pictures'"),
            desc="Screenshot region"),
    Key([mod, "shift", "control"], "s",
            lazy.spawn("scrot --pointer -e 'mv $f ~/Pictures'"),
            desc="Screenshot all region"),

    # Media Hotkeys
    Key([], 'XF86AudioRaiseVolume', lazy.spawn('pamixer -i 10')),
    Key([], 'XF86AudioLowerVolume', lazy.spawn('pamixer -d 10')),
    Key([], 'XF86AudioMute', lazy.spawn('pamixer -t')),

    # Utility
    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "shift"], "r", lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]


"""
Workspace/Group
"""
# You can change with name that you want
group_names = '1 2 3 4 5 6 7 8 9'.split()
groups = [Group(name, layout='columns') for name in group_names]
for i, name in enumerate(group_names):
    indx = str(i + 1)
    keys += [
        Key([mod], indx, lazy.group[name].toscreen()),
        Key([mod, 'shift'], indx, lazy.window.togroup(name, switch_group=True))
    ]

"""
Layouting
"""
layout_theme = {
    "border_width": 2,
    "margin": 8,
    "border_focus": "#d8dee9",
    "border_normal": "#2e3440",
    "border_focus_stack": "#e5e9f0",
    "border_normal_stack": "#3b4252",
    "active_fg": "000000",
    "inactive_fg": "ffffff"
}
layouts = [
    layout.Columns(**layout_theme),
    layout.Max(**layout_theme),
    layout.Floating(**layout_theme),
    layout.TreeTab(
        fontsize=10,
        sections=["TreeTab"],
        section_fontsize=10,
        border_width=2,
        bg_color=layout_theme["border_normal"],
        active_bg=layout_theme["border_focus"],
        active_fg=layout_theme["active_fg"],
        inactive_bg=layout_theme["border_normal_stack"],
        inactive_fg=layout_theme["inactive_fg"],
        padding_left=0,
        padding_x=0,
        padding_y=5,
        level_shift=8,
        vspace=3,
        panel_width=200
    )
]

"""
Widget and Screen
"""
def get_monitor_length():
    output = subprocess.run(['xrandr'], stdout=subprocess.PIPE).stdout.decode('utf-8')
    output = output.split("\n")
    output = [o for o in output if "connected" in o]
    return len(output)

widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()
screen_bottom = bar.Bar(
    [
        widget.CurrentLayout(),
        widget.GroupBox(),
        widget.Prompt(),
        widget.WindowName(),
        widget.Chord(
            chords_colors={
                'launch': ("#ff0000", "#ffffff"),
            },
            name_transform=lambda name: name.upper(),
        ),
        widget.Volume(),
        #widget.Systray(),
        widget.Clock(format='%Y-%m-%d %a %I:%M %p'),
        widget.QuickExit(),
    ],
    24,
)
screens = []
for i in range(0, get_monitor_length()):
    screens.append(Screen(bottom=screen_bottom))

@hook.subscribe.startup_once
def autostart():
    """
    Autostart
    """
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.call([home])

@hook.subscribe.startup
def startup():
    screen_bottom.show(widget_show)

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

wmname = "LG3D"
