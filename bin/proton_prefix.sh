#!/bin/sh

# NOTE: I'm so fkin shame cuz last time I digging down the Proton and create
# `bin/proton_template.sh` script.
# TODO: Rewrite `bin/proton_{template,prefix}.sh` and make it one file.
# Maybe we can call it `proton_pfx.sh`?

if [ -t 1 ]; then
    echo 'Please run using "eval $(./prefix.sh <prefix>)"'
    exit 1
fi

PROTON_MODE="${PROTON_MODE:-}"
PREFIX="$HOME/wine/prefix/${1:-wine-ge}"
WINEPREFIX="$PREFIX$([ -n "$PROTON_MODE" ] && echo "/pfx")"

cat << EOF
    export WINEPREFIX='$WINEPREFIX'
    export STEAM_COMPAT_CLIENT_INSTALL_PATH='${COMPAT_INSTALL_PATH:-$HOME/.steam/steam}'
    export STEAM_COMPAT_DATA_PATH='$PREFIX'
EOF

if [ -n "$PROTON_MODE" ]; then
    echo "How to run: /path/to/proton run <exe>" >&2
else
    echo "How to run: /path/to/wine <exe>" >&2
fi
