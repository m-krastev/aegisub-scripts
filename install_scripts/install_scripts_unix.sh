#!/bin/bash

echo "Aegisub Scripts Installer for macOS/Linux"
echo "========================================"
echo

# Determine OS and set appropriate directory
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    DEST_DIR="$HOME/Library/Application Support/Aegisub/automation/autoload"
else
    # Linux/Unix
    DEST_DIR="$HOME/.aegisub/automation/autoload"
fi

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRC_DIR="$SCRIPT_DIR/../scripts"

# Check if source directory exists
if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Scripts folder not found!"
    echo "Looking for: $SRC_DIR"
    echo "Please make sure all .lua scripts are placed in a 'scripts' folder."
    read -p "Press Enter to exit..."
    exit 1
fi

# Create destination directory if it doesn't exist
echo "Checking if Aegisub autoload directory exists..."
if [ ! -d "$DEST_DIR" ]; then
    echo "Creating directory $DEST_DIR"
    mkdir -p "$DEST_DIR"
fi

# Copy scripts
echo
echo "Copying scripts to $DEST_DIR..."
for file in "$SRC_DIR"/*.lua; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        echo "Installing: $filename"
        cp "$file" "$DEST_DIR/"
    fi
done

echo
echo "Installation complete!"
echo
echo "All scripts have been installed to your Aegisub autoload directory."
echo "Please restart Aegisub if it's currently running."
echo

read -p "Press Enter to exit..."
