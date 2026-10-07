#!/bin/bash
# CPU usage + temperature for waybar (JSON). Samples /proc/stat over 0.5s.
read -r _ u1 n1 s1 i1 w1 q1 sq1 _ < /proc/stat
sleep 0.5
read -r _ u2 n2 s2 i2 w2 q2 sq2 _ < /proc/stat
idle=$(( (i2 + w2) - (i1 + w1) ))
total=$(( (u2+n2+s2+i2+w2+q2+sq2) - (u1+n1+s1+i1+w1+q1+sq1) ))
usage=$(( total > 0 ? 100 * (total - idle) / total : 0 ))
temp=$(( $(cat /sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon*/temp1_input) / 1000 ))
mhz=$(grep MHz /proc/cpuinfo | awk '{s+=$4} END {printf "%d", s/NR}')
class=""; [ "$temp" -ge 92 ] && class="critical"
printf '{"text":"CPU: %s%% %sC","tooltip":"CPU %s%%\\nTctl %s°C\\nAvg clock %s MHz\\nGovernor %s","class":"%s"}\n' \
  "$usage" "$temp" "$usage" "$temp" "$mhz" "$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)" "$class"
