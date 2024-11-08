#!/bin/bash

if ! command -v grim &> /dev/null || ! command -v tesseract &> /dev/null || ! command -v wl-copy &> /dev/null || ! command -v slurp &> /dev/null; then
    echo "Please install grim, tesseract, wl-clipboard, and slurp."
    exit 1
fi

selected_area=$(slurp)

screenshot_file=$(mktemp /tmp/screenshot.XXXXXX.png)
grim -g "$selected_area" "$screenshot_file"

processed_file=$(mktemp /tmp/processed.XXXXXX.png)
convert "$screenshot_file" -colorspace Gray -contrast "$processed_file"

extracted_text=$(tesseract "$processed_file" stdout)

echo "$extracted_text" | wl-copy

rm "$screenshot_file" "$processed_file"

echo "Text copied to clipboard."
