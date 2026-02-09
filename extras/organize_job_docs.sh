#!/usr/bin/env bash

set -euo pipefail

DOWNLOADS="$HOME/Downloads"
RESUME_DIR="$DOWNLOADS/Job_Applications/resume"
COVER_DIR="$DOWNLOADS/Job_Applications/cover_letter"

mkdir -p "$RESUME_DIR"
mkdir -p "$COVER_DIR"

for file in "$DOWNLOADS"/*.pdf "$DOWNLOADS"/*.PDF; do
    [ -e "$file" ] || continue   # prevents loop errors if no PDFs exist

    filename="$(basename "$file")"

    if [[ "$filename" == *Resume* ]]; then
        mv -f "$file" "$RESUME_DIR/"
        echo "Moved (overwritten if existed): $filename → resume/"
        
    elif [[ "$filename" == *_Cover_Letter* ]]; then
        mv -f "$file" "$COVER_DIR/"
        echo "Moved (overwritten if existed): $filename → cover_letter/"
    fi
done

echo "Done."

