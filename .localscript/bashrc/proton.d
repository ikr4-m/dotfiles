#!/bin/sh

# Set COMPAT_PATH for Proton
export STEAM_COMPAT_DATA_PATH="$HOME/.proton"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam"

# Set Proton exclusive path
alias proton="$HOME/.steam/steam/steamapps/common/Proton\ -\ Experimental/proton"

# Prevent input frameworks from working in the Wine
# Note: Change your input to US Layout
# Note2: You can add it manually to some game like XIV
export XMODIFIERS="@im=null"
