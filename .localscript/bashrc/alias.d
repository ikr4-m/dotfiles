#!/bin/sh

# Prime Prefix
alias nvprime="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only"

# Genie Start
alias genieup="$HOME/dotfiles/.localscript/bashrc/exec/genie_start.sh up"
alias geniedown="$HOME/dotfiles/.localscript/bashrc/exec/genie_start.sh down"
alias genieshell="$HOME/dotfiles/.localscript/bashrc/exec/genie_start.sh shell"

# Looking Glass
alias looking-glass="looking-glass-client -m 97 -kT -c DXGI"
alias gpu-integrated="sudo envycontrol -s integrated"
alias gpu-hybrid="sudo envycontrol -s hybrid"
alias gpu-nvidia="sudo envycontrol -s nvidia"

# Nix Aliases
alias nix-prune="nix-collect-garbage -d"

# Vim
alias vim="nvim"
alias neovide="NEOVIDE_MULTIGRID=1 neovide ."
