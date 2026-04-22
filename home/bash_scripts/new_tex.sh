#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
TEMPLATE_DIR="$SCRIPT_DIR/../latex_templates"

usage() {
    echo "Usage: $0 <template> <output>"
    echo ""
    echo "Templates:"
    echo "  simple   <dir>        Single-file document (main.tex only)"
    echo "  complex  <dir>        Multi-file document (main.tex, preamble.sty, refs.bib)"
    echo "  slides   <dir>        Beamer presentation (main.tex, preamble.sty)"
    exit 1
}

[ "$#" -ne 2 ] && usage

TEMPLATE_NAME="$1"
OUTPUT="$2"

case "$TEMPLATE_NAME" in
    simple)
        SRC="$TEMPLATE_DIR/simple.tex"
        [ ! -f "$SRC" ] && { echo "Error: Missing $SRC"; exit 1; }
        mkdir -p "$OUTPUT"
        cp "$SRC" "$OUTPUT/main.tex"
        echo "Created $OUTPUT/main.tex"
        ;;
    complex)
        SRC_DIR="$TEMPLATE_DIR/complex"
        [ ! -d "$SRC_DIR" ] && { echo "Error: Missing $SRC_DIR"; exit 1; }
        mkdir -p "$OUTPUT"
        cp "$SRC_DIR"/* "$OUTPUT/"
        echo "Created $OUTPUT/ with:"
        ls "$OUTPUT/"
        ;;
    slides)
        SRC_DIR="$TEMPLATE_DIR/slides"
        [ ! -d "$SRC_DIR" ] && { echo "Error: Missing $SRC_DIR"; exit 1; }
        mkdir -p "$OUTPUT"
        cp "$SRC_DIR"/* "$OUTPUT/"
        echo "Created $OUTPUT/ with:"
        ls "$OUTPUT/"
        ;;
    *)
        echo "Error: Unknown template '$TEMPLATE_NAME'"
        usage
        ;;
esac
