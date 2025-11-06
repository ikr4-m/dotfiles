#!/usr/bin/env bash

if [[ "$(pwd)" != "$HOME" ]]; then
    echo "Please execute this on home ($HOME) directory."
    exit 100
fi
if [ ! -f /usr/bin/zstd ]; then
    echo "Install zstd first"
    exit 100
fi

TARGET_DIRS=(
    "Documents/"
    "Music/"
    "Pictures/"
    "Videos/"
    ".ssh/"
    ".gnupg/"
)
FILENAME="$(date +%Y%m%d)-$(date +%H%M%S)-backup.tar.zst"

TARGET_DIRS+=("$@")
VALIDATED_DIRS=()
for dir in "${TARGET_DIRS[@]}"; do
    if [ -e "$dir" ]; then
        VALIDATED_DIRS+=("$dir")
    else
        echo "WARNING: Target '$dir' not found, ignored."
    fi
done
echo "--------------------------------------------------"
if [ ${#VALIDATED_DIRS[@]} -eq 0 ]; then
    echo "ERROR: There is no valid directory, exit."
    exit 1
else
    echo "List of directory/file selected:"
    printf "  - %s\n" "${VALIDATED_DIRS[@]}"
    echo ""
    read -p "Press [Enter] to start."
fi
echo "--------------------------------------------------"

echo "Calculating...."
TOTAL_SIZE=$(sudo du -scb "${TARGET_DIRS[@]}" | tail -n 1 | awk '{print $1}')
if [[ -z "$TOTAL_SIZE" || "$TOTAL_SIZE" -eq 0 ]]; then
    echo "ERROR: Backup size is 0, exit."
    exit 1
fi

echo "Backup Size: $(numfmt --to=iec-i --suffix=B "$TOTAL_SIZE")"
echo "Backup Name: $FILENAME"
sudo tar --same-permissions --same-owner -cf - "${TARGET_DIRS[@]}" \
    | pv -s "$TOTAL_SIZE" -b -p -t -e \
    | zstd -T0 - \
    > "$FILENAME"
