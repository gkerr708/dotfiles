#!/bin/bash
# VRAM usage for waybar (JSON), in GiB.
D=""; best=0
for d in /sys/class/drm/card*/device; do
  [ -r "$d/gpu_busy_percent" ] || continue
  t=$(cat "$d/mem_info_vram_total"); [ "$t" -gt "$best" ] && best=$t && D=$d
done
[ -z "$D" ] && exit 0
used=$(cat $D/mem_info_vram_used); total=$(cat $D/mem_info_vram_total)
awk -v u="$used" -v t="$total" 'BEGIN {printf "{\"text\":\"VRAM: %4.1fG\",\"tooltip\":\"VRAM %.1f / %.1f GiB\"}\n", u/2^30, u/2^30, t/2^30}'
