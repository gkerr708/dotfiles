#!/bin/bash
# Toggle low-latency PipeWire quantum for guitar (Carla/NAM). Usage: guitar_mode.sh [on|off]
Q=64
cur=$(pw-metadata -n settings 0 clock.force-quantum 2>/dev/null | grep -oP "value:'\K[0-9]+")
mode=${1:-$([ "$cur" = "$Q" ] && echo off || echo on)}

if [ "$mode" = "on" ]; then
  pw-metadata -n settings 0 clock.force-quantum $Q >/dev/null
  echo "Guitar mode ON (quantum $Q, $(awk -v q=$Q 'BEGIN {printf "%.2f", q/48}') ms)"
else
  pw-metadata -n settings 0 clock.force-quantum 0 >/dev/null
  echo "Guitar mode OFF (quantum back to default)"
fi
