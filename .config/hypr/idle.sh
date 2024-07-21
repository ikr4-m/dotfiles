#!/bin/sh

# Constant
LOCKSCREEN_TIMEOUT=300
DIM_SCREEN_TIMEOUT=450
SLEEP_TIMEOUT=600

# Get variable
LOCKSCREEN_COMMAND=$1
if [[ $LOCKSCREEN_COMMAND = "" ]]; then
  echo "No lockscreen provided"
  exit 1
fi

# Execute swayidle
swayidle -w \
  timeout $LOCKSCREEN_TIMEOUT "$LOCKSCREEN_COMMAND" \
  timeout $DIM_SCREEN_TIMEOUT 'hyprctl dispatch dpms off' \
  resume 'hyprctl dispatch dpms on' &
  #timeout $SLEEP_TIMEOUT 'systemctl suspend' \
  #before-sleep "$LOCKSCREEN_COMMAND" &
