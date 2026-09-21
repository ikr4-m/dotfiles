#!/bin/sh
# Ensure desktop session & audio bus exist in non-interactive/subshell environments
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=${XDG_RUNTIME_DIR}/bus}"
export DISPLAY="${DISPLAY:-:0}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"

SCRIPT_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd)"
AUDIO_FILE="${SCRIPT_DIR}/fahhhh.mp3"

notify-send "${1:-Antigravity}" "${2:-Task Completed!}" --icon "dialog-information"

# Play audio synchronously (only 1.6s) so agy session teardown doesn't kill it prematurely
if [ -f "$AUDIO_FILE" ]; then
    if command -v pw-play >/dev/null 2>&1; then
        pw-play "$AUDIO_FILE" >/dev/null 2>&1
    elif command -v paplay >/dev/null 2>&1; then
        paplay "$AUDIO_FILE" >/dev/null 2>&1
    elif command -v mpv >/dev/null 2>&1; then
        mpv --no-video --really-quiet "$AUDIO_FILE" >/dev/null 2>&1
    fi
fi
