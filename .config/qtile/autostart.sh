#!/bin/sh

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

# Optimus Manager applet
optimus-manager-qt &

# EWW Daemon
eww daemon
eww open widget
eww open music

# Feh
feh --bg-scale ~/.wallpaper/default.jpg &

# Alacritty (First Workspace)
alacritty -o font.size=10 &
