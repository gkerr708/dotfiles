#!/bin/bash

# Check arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <template_name> <new_file_name>"
    echo "Available templates: assignment, paper, slides"
    exit 1
fi

TEMPLATE_DIR="$HOME/latex_templates"

TEMPLATE_NAME="$1"
NEW_FILE_NAME="$2"
DEST_DIR="$(dirname "$NEW_FILE_NAME")"

case "$TEMPLATE_NAME" in
    assignment)
        TEMPLATE_FILE="$TEMPLATE_DIR/assignment.tex"
        CONFIG_FILE="$TEMPLATE_DIR/custom_config.sty"
        ;;
    paper)
        TEMPLATE_FILE="$TEMPLATE_DIR/paper.tex"
        CONFIG_FILE="$TEMPLATE_DIR/custom_config.sty"
        ;;
    slides)
        TEMPLATE_FILE="$TEMPLATE_DIR/slides.tex"
        CONFIG_FILE="$TEMPLATE_DIR/custom_config_slides.sty"
        ;;
    *)
        echo "Error: Invalid template name. Use: assignment, paper, slides."
        exit 1
        ;;
esac

# Checks
for f in "$TEMPLATE_FILE" "$CONFIG_FILE"; do
    if [ ! -f "$f" ]; then
        echo "Error: Missing file $f"
        exit 1
    fi
done

# Create destination directory if needed
mkdir -p "$DEST_DIR"

# Copy files
cp "$TEMPLATE_FILE" "$NEW_FILE_NAME"
cp "$CONFIG_FILE" "$DEST_DIR/$(basename "$CONFIG_FILE")"

if [ $? -eq 0 ]; then
    echo "Created $NEW_FILE_NAME"
    echo "Copied $(basename "$CONFIG_FILE") to $DEST_DIR"
else
    echo "Error: File creation failed"
    exit 1
fi
