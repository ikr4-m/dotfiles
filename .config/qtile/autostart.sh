#!/bin/sh

thunar --daemon &
feh --bg-scale ~/.wallpaper/default.jpg &
picom -b &
dunst -conf ~/.config/dunst/dunstrc-dark &
xfce4-power-manager &
start-pulseaudio-x11 &
xfsettingsd &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/xfconf/xfconfd &
nm-applet &
