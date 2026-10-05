#!/bin/bash
# Disables CPU boost persistently (Ryzen 5 3600 runs too hot while gaming: ~95°C).
# Capped at the 3.6 GHz base clock. acpi-cpufreq can't set an in-between cap (only 3.6/2.8/2.2 GHz).
# Run with: sudo ./setup-cpu-limit.sh      Undo: sudo systemctl disable --now cpu-limit.service; echo 1 | sudo tee /sys/devices/system/cpu/cpufreq/boost
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Run with sudo: sudo $0" >&2
  exit 1
fi

echo "[1/2] Installing and enabling cpu-limit.service"
cat > /etc/systemd/system/cpu-limit.service <<'UNIT'
[Unit]
Description=Disable CPU boost (thermals)
After=multi-user.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/sh -c 'echo 0 > /sys/devices/system/cpu/cpufreq/boost'
ExecStop=/bin/sh -c 'echo 1 > /sys/devices/system/cpu/cpufreq/boost'

[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable --now cpu-limit.service

echo "[2/2] Current state:"
echo "boost = $(cat /sys/devices/system/cpu/cpufreq/boost) (0 = off)"
