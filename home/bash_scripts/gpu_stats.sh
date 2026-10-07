#!/bin/bash
# GPU stats for the RX 6800 via sysfs. Default: waybar JSON. Use -v for a readable summary.
D=/sys/bus/pci/devices/0000:2b:00.0
H=$(echo $D/hwmon/hwmon*)
busy=$(cat $D/gpu_busy_percent)
temp=$(( $(cat $H/temp2_input) / 1000 ))   # junction
watts=$(( $(cat $H/power1_average) / 1000000 ))
cap=$(( $(cat $H/power1_cap) / 1000000 ))
fan=$(cat $H/fan1_input)
sclk=$(( $(cat $H/freq1_input) / 1000000 ))
vram_used=$(cat $D/mem_info_vram_used)
vram_total=$(cat $D/mem_info_vram_total)

if [ "$1" = "-v" ]; then
  echo "GPU  ${busy}%  ${temp}°C (junction)  ${watts}/${cap} W  ${sclk} MHz  fan ${fan} RPM"
  echo "VRAM $(( vram_used / 1048576 ))/$(( vram_total / 1048576 )) MiB"
  echo "CPU  $(sensors k10temp-pci-00c3 2>/dev/null | awk '/Tctl/ {print $2}')  $(grep MHz /proc/cpuinfo | awk '{s+=$4} END {printf "%d MHz avg", s/NR}')  governor $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"
  exit
fi

class=""; [ "$temp" -ge 105 ] && class="critical"
printf '{"text":"GPU: %s%% %sC %sW","tooltip":"GPU %s%%\\nJunction %s°C\\nPower %s/%s W\\nClock %s MHz\\nFan %s RPM\\nVRAM %s/%s MiB","class":"%s"}\n' \
  "$busy" "$temp" "$watts" "$busy" "$temp" "$watts" "$cap" "$sclk" "$fan" \
  "$(( vram_used / 1048576 ))" "$(( vram_total / 1048576 ))" "$class"
