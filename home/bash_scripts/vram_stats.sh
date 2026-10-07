#!/bin/bash
# VRAM usage for waybar (JSON), in GiB.
D=/sys/bus/pci/devices/0000:2b:00.0
used=$(cat $D/mem_info_vram_used); total=$(cat $D/mem_info_vram_total)
awk -v u="$used" -v t="$total" 'BEGIN {printf "{\"text\":\"VRAM: %.1fG\",\"tooltip\":\"VRAM %.1f / %.1f GiB\"}\n", u/2^30, u/2^30, t/2^30}'
