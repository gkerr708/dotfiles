#!/bin/bash
# Laptop power profiles: performance while plugged in, balanced on battery.
# Installs power-profiles-daemon and a udev rule that switches profile on AC plug/unplug.
# Run with: sudo ./setup-power-profiles.sh
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Run with sudo: sudo $0" >&2
  exit 1
fi

echo "[1/3] Installing and enabling power-profiles-daemon"
pacman -S --needed --noconfirm power-profiles-daemon
systemctl enable --now power-profiles-daemon.service

echo "[2/3] Installing AC plug/unplug switcher"
cat > /usr/local/bin/power-profile-ac <<'SCRIPT'
#!/bin/sh
# $1 = 1 (plugged in) or 0 (on battery). Falls back to balanced if performance isn't supported.
if [ "$1" = 1 ]; then
  powerprofilesctl set performance 2>/dev/null || powerprofilesctl set balanced
else
  powerprofilesctl set balanced
fi
SCRIPT
chmod 755 /usr/local/bin/power-profile-ac

cat > /etc/udev/rules.d/99-power-profile.rules <<'RULES'
SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", RUN+="/usr/local/bin/power-profile-ac 1"
SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", RUN+="/usr/local/bin/power-profile-ac 0"
RULES
udevadm control --reload

echo "[3/3] Applying for current AC state"
online=$(cat /sys/class/power_supply/A*/online 2>/dev/null | head -1)
/usr/local/bin/power-profile-ac "${online:-1}"
powerprofilesctl list
