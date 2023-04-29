#!/bin/sh

# Notification daemon
dunst -conf ~/.config/dunst/dunstrc-dark &

# Compositor
#picom -experimental-backends &
picom -b &

# XFCE4 Helper
#xfce4-power-manager &
#start-pulseaudio-x11 &
#xfsettingsd &
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
#/usr/lib/xfce4/xfconf/xfconfd &

# KDE Helper
/usr/lib/polkit-kde-authentication-agent-1 &

# Wifi Applet
nm-applet &

# EWW Daemon
eww daemon
eww open widget
eww open music

#tint2 -c ~/.config/tint2/elaina.tint2rc &
#tint2 -c ~/.config/tint2/elaina2.tint2rc &
#tint2 -c ~/.config/tint2/elaina3.tint2rc &

# XRandr Dual Monitor
xrandr --output HDMI-1-1 --primary --auto --mode 1920x1080 --left-of eDP-1-1

# Feh
feh --bg-scale ~/.wallpaper/default.jpg &
