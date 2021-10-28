#!/bin/bash
# Simple volume output
# Dependency: pamixer

volume_state=""
percentage=$(pamixer --get-volume)

# Dynamically change volume state
if [[ $percentage -ge 0 && $percentage -le 9 ]]; then
  volume_state="奄"
elif [[ $percentage -ge 10 && $percentage -le 50 ]]; then
  volume_state="奔"
elif [[ $percentage -ge 51 && $percentage -le 100 ]]; then
  volume_state="墳"
else
  volume_state=""
  percentage="error, pamixer not found!"
fi

# If mute state
if [[ $(pamixer --get-mute) = true ]]; then
  volume_state=""
fi

echo "${volume_state}  ${percentage}%"
