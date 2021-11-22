#!/bin/sh

# Thunar Daemon
thunar --daemon &

# Feh
feh --bg-scale ~/.wallpaper/default.jpg &

# Compositor
picom -b &

# Notification daemon
dunst -conf ~/.config/dunst/dunstrc-dark &

# XFCE4 Helper
xfce4-power-manager &
start-pulseaudio-x11 &
xfsettingsd &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/xfconf/xfconfd &

# Wifi Applet
nm-applet &
