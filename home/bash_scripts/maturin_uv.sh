#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <project-name>"
  exit 1
fi

PROJECT_NAME="$1"

# Create maturin project
maturin new "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Set up uv environment and add maturin
uv venv
uv add --dev maturin

# Create python/ with __init__.py and main.py
mkdir -p python
touch python/__init__.py

# Write scaffold for main.py
cat > python/main.py <<EOF
import $PROJECT_NAME

if __name__ == "__main__":
    result = $PROJECT_NAME.sum_as_string(2, 3)
    print("Rust function output:", result)
EOF

echo "Project '$PROJECT_NAME' initialized with uv + maturin and Python scaffold."
