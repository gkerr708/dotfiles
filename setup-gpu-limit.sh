#!/bin/bash
# Sets up persistent GPU power/clock limits for an RX 6800-series card on a small PSU.
# Run with: sudo ./setup-gpu-limit.sh
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Run with sudo: sudo $0" >&2
  exit 1
fi

# 1. Enable overdrive interface via kernel parameter (GRUB)
if grep -q 'amdgpu.ppfeaturemask' /etc/default/grub; then
  echo "[1/4] ppfeaturemask already in GRUB config, skipping"
else
  echo "[1/4] Adding amdgpu.ppfeaturemask to GRUB"
  sed -i 's/^\(GRUB_CMDLINE_LINUX_DEFAULT="[^"]*\)"/\1 amdgpu.ppfeaturemask=0xffffffff"/' /etc/default/grub
  grep GRUB_CMDLINE_LINUX_DEFAULT /etc/default/grub
  grub-mkconfig -o /boot/grub/grub.cfg
fi

# 2. Limiter script
echo "[2/4] Writing /usr/local/bin/gpu-limit.sh"
cat > /usr/local/bin/gpu-limit.sh <<'EOF'
#!/bin/bash
D=/sys/bus/pci/devices/0000:2b:00.0
# At boot this can run before amdgpu has created its sysfs files, so wait for them
for _ in $(seq 60); do
  compgen -G "$D/hwmon/hwmon*/power1_cap" >/dev/null && [ -w $D/pp_od_clk_voltage ] && break
  sleep 1
done
echo 197000000 > $D/hwmon/hwmon*/power1_cap
if [ -w $D/pp_od_clk_voltage ]; then
  echo "s 1 2000" > $D/pp_od_clk_voltage
  echo "vo -50"   > $D/pp_od_clk_voltage
  echo "c"        > $D/pp_od_clk_voltage
fi
EOF
chmod +x /usr/local/bin/gpu-limit.sh

# 3. systemd service
echo "[3/4] Installing and enabling gpu-limit.service"
cat > /etc/systemd/system/gpu-limit.service <<'EOF'
[Unit]
Description=Limit GPU power and clocks (small PSU)
After=multi-user.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/gpu-limit.sh

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now gpu-limit.service

# 4. Report
echo "[4/4] Current state:"
cat /sys/bus/pci/devices/0000:2b:00.0/hwmon/hwmon*/power1_cap
echo
echo "Done."
echo "Verify with: cat /sys/bus/pci/devices/0000:2b:00.0/pp_od_clk_voltage"
