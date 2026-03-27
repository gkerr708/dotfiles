#!/usr/bin/env bash
dir="${1:-$PWD}"
cd "$dir" || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

b=$(git -c color.ui=false rev-parse --abbrev-ref HEAD 2>/dev/null \
    || git -c color.ui=false describe --tags --always 2>/dev/null)
m=$(git -c color.status=false status --porcelain 2>/dev/null | wc -l | tr -d ' ')
u=$(git -c color.ui=false rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "")
a=0; z=0
if [ -n "$u" ]; then
  a=$(git -c color.ui=false rev-list --count "${u}..HEAD" 2>/dev/null || echo 0)
  z=$(git -c color.ui=false rev-list --count "HEAD..${u}" 2>/dev/null || echo 0)
fi

out=" $b"
[ "$m" -gt 0 ] && out="$out*"
[ "$a" -gt 0 ] && out="$out ↑$a"
[ "$z" -gt 0 ] && out="$out ↓$z"
printf " %s " "$out"
