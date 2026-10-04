#!/bin/bash
# Sets up a low-latency guitar rig: Carla (plugin host) + NAM amp/cab loader (Ratatouille)
# + AIDA-X + Guitarix, and a PipeWire low-latency buffer.
# Run as your normal user (not sudo): ./setup-guitar.sh — it calls sudo/yay itself.
# Safe to re-run.
set -euo pipefail

if [ "$EUID" -eq 0 ]; then
  echo "Run as your normal user, not root: $0" >&2
  exit 1
fi

QUANTUM=128   # samples @ 48 kHz: 128 ≈ 2.7 ms. If audio crackles, raise to 256.

echo "[1/4] Installing repo packages"
sudo pacman -S --needed --noconfirm \
  carla guitarix aida-x-lv2 lsp-plugins-lv2 qpwgraph pipewire-jack realtime-privileges

echo "[2/4] Installing Ratatouille (NAM + cabinet IR loader) from the AUR"
yay -S --needed --noconfirm ratatouille-lv2

echo "[3/4] Realtime scheduling group"
if id -nG "$USER" | grep -qw realtime; then
  echo "  already in 'realtime' group"
else
  sudo usermod -aG realtime "$USER"
  echo "  added to 'realtime' group (log out and back in to apply)"
fi

echo "[4/4] PipeWire low-latency buffer ($QUANTUM samples)"
mkdir -p ~/.config/pipewire/pipewire.conf.d
cat > ~/.config/pipewire/pipewire.conf.d/10-guitar-latency.conf <<EOF
context.properties = {
    default.clock.rate        = 48000
    default.clock.quantum     = $QUANTUM
    default.clock.min-quantum = 64
}
EOF
systemctl --user restart pipewire pipewire-pulse wireplumber

echo
echo "Done. Current buffer:"
pw-metadata -n settings 0 clock.force-quantum 2>/dev/null | grep -o "value:'[0-9]*'" || true
pw-metadata -n settings 0 clock.quantum 2>/dev/null | grep -o "value:'[0-9]*'" || true
echo
echo "Next: plug guitar into Scarlett input 1, press INST, run 'carla',"
echo "add Ratatouille, load a .nam model and a cabinet IR."
