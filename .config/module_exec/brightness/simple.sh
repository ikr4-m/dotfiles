#!/bin/bash
# Simple brightness parser
# Dependency: python3, brightnessctl

bright=$(py ~/.config/shellexecutor/brightness/parser.py)
state=""

if [[ $bright -ge 1 && $bright -le 10 ]]; then
  state=""
elif [[ $bright -ge 11 && $bright -le 50 ]]; then
  state=""
elif [[ $bright -ge 51 && $bright -le 100 ]]; then
  state=""
else
  state=""
  bright="error, brightnessctl not found"
fi

echo "${state}  ${bright}%"
