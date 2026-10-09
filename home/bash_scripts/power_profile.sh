#!/bin/bash
# Power profile for waybar (JSON). Shown only on battery; "next" cycles profiles.
# On AC it forces performance (covers boot; udev from setup-power-profiles.sh handles plug events).
command -v powerprofilesctl >/dev/null || exit 0
ac=""
for p in /sys/class/power_supply/*; do
  [ "$(cat "$p/type" 2>/dev/null)" = Mains ] && ac=$(cat "$p/online") && break
done
[ -z "$ac" ] && exit 0   # no AC adapter: desktop
cur=$(powerprofilesctl get)
profiles=$(powerprofilesctl list | sed -nE 's/^[* ] *([a-z-]+):$/\1/p' | tac)   # power-saver balanced performance

if [ "$ac" = 1 ]; then
  echo "$profiles" | grep -qx performance && [ "$cur" != performance ] && powerprofilesctl set performance
  exit 0
fi

if [ "$1" = next ]; then
  next=$(echo "$profiles" | grep -A1 -x "$cur" | sed -n 2p)
  powerprofilesctl set "${next:-$(echo "$profiles" | head -1)}"
  exit 0
fi

case $cur in power-saver) short=save ;; balanced) short=bal ;; *) short=perf ;; esac
printf '{"text":"Pwr: %-4s","tooltip":"Power profile: %s\\nClick to cycle","class":"%s"}\n' "$short" "$cur" "$cur"
