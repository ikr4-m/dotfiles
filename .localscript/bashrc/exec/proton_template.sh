 #!/usr/bin/env bash
PROTON="GE-Proton7-55" # install GE-Proton using ProtonUp-QT
X="$HOME/.steam/root"
PROTON_BIN="${X}/compatibilitytools.d/${PROTON}/proton"
PROTON_WINE="${X}/compatibilitytools.d/${PROTON}/files/bin/wine64"
EXE_FILE="Game.exe"
PFX_PATH="$HOME/.wine-prefix/native/folder_here"

# Function to set environment variables
set_proton_env() {
  export PROTON_LOG=1
  export PROTON_DUMP_DEBUG_COMMANDS=1
  STEAM_COMPAT_DATA_PATH="${PFX_PATH}/"
  export STEAM_COMPAT_DATA_PATH
  WINEPREFIX="${PFX_PATH}/pfx"
  export WINEPREFIX
  export STEAM_COMPAT_CLIENT_INSTALL_PATH="${X}"
  export WINEDLLOVERRIDES="winhttp=n,b"
  export LANG=ja_JP.UTF-8
}

# Set environment variables
set_proton_env

# Add registry keys
add_reg_keys() {
    local reg_location="$1"
    shift

    if [ $(( $# % 2 )) -ne 0 ]; then
        echo "Error: The number of key-value pair arguments should be even."
        exit 1
    fi

    "${PROTON_WINE}" reg add "${reg_location}" /ve /f

    while [ "$#" -gt 0 ]; do
        "${PROTON_WINE}" reg add "${reg_location}" /v "$1" /d "$2" /f
        shift 2
    done
}

# Create dir if the dir doesn't exist
mkdir -p "${PFX_PATH}"

# Check if the EXE_FILE exists, if not, print a message and exit the script
if [ ! -e "$EXE_FILE" ]; then
  echo "$EXE_FILE does not exist"
  exit 1
fi

# Add registry keys
# Example HS2 Installer from github@mbahmodin. This is optional.
#REG_LOCATION_0="HKEY_CURRENT_USER\\Software\\illusion\\HoneySelect2\\HoneySelect2"
#add_reg_keys "${REG_LOCATION_0}" "INSTALLDIR" "Z:$(pwd | sed 's/\//\\/g')\\"

# Run the application using Proton
# Uncomment the command below to run the game with an NVIDIA graphics card if you use PRIME: https://wiki.archlinux.org/title/PRIME
# prime-run \
"${PROTON_BIN}" waitforexitandrun "$(pwd)/${EXE_FILE}"
