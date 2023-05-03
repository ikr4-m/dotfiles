#!/bin/sh

alias l="ls -l"
alias ll="ls -lAh"
alias rimraf="rm -rf"
alias cpr="cp -r"

alias wine32="WINEPREFIX=\"$HOME/.wine32/\" WINEARCH=win32"
alias wine64="WINEPREFIX=\"$HOME/.wine/\""
alias wine_nvidia_32="WINEPREFIX=\"$HOME/.wine32/\" WINEARCH=win32 prime-run wine"
alias wine_nvidia_64="WINEPREFIX=\"$HOME/.wine/\" prime-run wine"

alias genieup="$HOME/dotfiles/.localscript/bashrc/exec/genie_start.sh up"
alias geniedown="$HOME/dotfiles/.localscript/bashrc/exec/genie_start.sh down"
alias genieshell="$HOME/dotfiles/.localscript/bashrc/exec/genie_start.sh shell"

alias looking-glass="looking-glass-client -m 97 -kT -c DXGI"
alias gpu-integrated="sudo envycontrol -s integrated"
alias gpu-nvidia="sudo envycontrol -s nvidia"
