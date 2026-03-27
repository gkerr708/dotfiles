#!/usr/bin/env bash
set -euo pipefail

dir="${1:-$PWD}"
cd "$dir" || exit 0

# Find pyproject.toml upward
find_pyproject() {
  local d="$PWD"
  while [ "$d" != "/" ]; do
    [ -f "$d/pyproject.toml" ] && { echo "$d/pyproject.toml"; return; }
    d=$(dirname "$d")
  done
}

# Show active venv / conda name (from this shell)
find_venv() {
  if [ -n "${VIRTUAL_ENV:-}" ]; then
    echo "($(basename "$VIRTUAL_ENV"))"
  elif [ -n "${CONDA_DEFAULT_ENV:-}" ]; then
    echo "(conda:${CONDA_DEFAULT_ENV})"
  fi
}

# Prefer a local .python-version file (e.g., uv/pyenv/poetry-plugin)
find_python_version() {
  local name=".python-version"
  if [ -f "$name" ]; then
    local pyver
    pyver=$(head -n1 "$name")
    [ -n "$pyver" ] && echo "$pyver"
  fi
}

pyproj="$(find_pyproject || true)"
venv="$(find_venv || true)"
req="$(find_python_version || true)"

# If no .python-version, parse pyproject.toml
if [ -z "${req}" ] && [ -n "${pyproj}" ]; then
  # PEP 621: project.requires-python
  req=$(awk -F= '
    /^[[:space:]]*requires-python[[:space:]]*=/ {gsub(/[ "]/,"",$2); print $2; exit}
  ' "$pyproj" || true)

  # Poetry fallback: [tool.poetry.dependencies] python = ...
  if [ -z "$req" ]; then
    req=$(awk -F= '
      /^\[tool\.poetry\.dependencies\]/ {in_deps=1; next}
      /^\[/ {in_deps=0}
      in_deps && $1 ~ /^[[:space:]]*python[[:space:]]*$/ {gsub(/[ "]/,"",$2); print $2; exit}
    ' "$pyproj" || true)
  fi
fi

# Print nothing if neither requirement nor env is present
if [ -z "${req}${venv}" ]; then
  exit 0
fi

# Output
printf " 🐍 %s %s " "${req}" "${venv}"
