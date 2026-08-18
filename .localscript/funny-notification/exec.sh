#!/bin/sh
notify-send "$1" "$2" --icon "dialog-information"
mpv --no-video ${0%/*}/fahhhh.mp3 >/dev/null 2>&1 &
