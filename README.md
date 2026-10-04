# Arch Linux Cheatsheet

## USB
* `lsblk` — list block devices
* `udisksctl mount -b /dev/sda1`
* `udisksctl unmount -b /dev/sda1`
* `udisksctl power-off -b /dev/sda`

## Date and Time
* `timedatectl status` 
* `timedatectl list-timezones`
* `timedatectl set-timezone Area/Location`

### Time sync (chrony)
* `chronyc tracking` — check sync status, offset, stratum
* `chronyc sources` — list NTP servers (`^*` = active)
* `chronyc activity` — quick "is it working" check
* `sudo systemctl enable --now chronyd` — start on boot
* `sudo systemctl disable --now systemd-timesyncd` — required, conflicts with chrony
* `sudo chronyc makestep` — force immediate resync

## Audio
* `wiremix`
    * [link](https://github.com/tsowell/wiremix)
    * Requires PipeWire.

## Network (nmcli)
* `nmcli device status` — show all devices
* `nmcli radio wifi on` — enable wifi
* `nmcli device wifi list` — scan for networks
* `nmcli device wifi connect <SSID> password <pw>` — connect
* `nmcli connection show` — list saved connections
* `nmcli connection up <name>` — reconnect to saved network
* `nmcli connection delete <name>` — forget network
* `sudo systemctl restart NetworkManager` - reconnect to wifi

### WPA-Enterprise (e.g. Dalhousie campus wifi)
Regular `nmcli device wifi connect` won't work — enterprise networks need PEAP/MSCHAPv2 with an identity + password:
```
sudo nmcli connection add type wifi ifname "*" con-name "Dalhousie" ssid "Dalhousie" \
  wifi-sec.key-mgmt wpa-eap \
  802-1x.eap peap \
  802-1x.phase2-auth mschapv2 \
  802-1x.identity "gv585095@dal.ca" \
  802-1x.password "PASTE_PASSWORD_HERE"

sudo nmcli connection up "Dalhousie"
```
* `802-1x.identity` — school email/username
* If auth fails, try adding `802-1x.anonymous-identity "@dal.ca"`, or `802-1x.eap ttls` instead of `peap` (depends what the campus RADIUS server expects)
* `nmcli connection delete "Dalhousie"` — remove the profile

## Wifi Speed Test
* `speedtest-cli`

## Bluetooth (bluetoothctl)
* `bluetoothctl` — open interactive shell, or prefix commands below
* `bluetoothctl power on`
* `bluetoothctl scan on` — discover devices
* `bluetoothctl pair <MAC>`
* `bluetoothctl connect <MAC>` -- Use tab if it's already known
* `bluetoothctl trust <MAC>` — auto-connect on boot
* `bluetoothctl devices` — list known devices

## Pacman
* `pacman -Syu` — full system upgrade
* `pacman -S <pkg>` — install
* `pacman -Rs <pkg>` — remove with unused deps
* `pacman -Qs <term>` — search installed
* `pacman -Ss <term>` — search repos
* `pacman -Qdt` — list orphans

## Hyprland
* `hyprctl monitors` — list monitors
* `hyprctl clients` — list open windows
* `hyprctl reload` — reload config

## Screenshot
* `grimblast save area path/to/image.png`


## GPU power limit (RX 6800-series, small PSU)
* `sudo ./setup-gpu-limit.sh` — one-time setup, safe to re-run
    * Adds `amdgpu.ppfeaturemask=0xffffffff` to GRUB (needed for the overdrive interface; reboot once)
    * Writes `/usr/local/bin/gpu-limit.sh` and enables `gpu-limit.service`, which applies at every boot:
        * power cap 197 W (`power1_cap`; stock is 215 W)
        * max core clock 2000 MHz, -50 mV offset (`pp_od_clk_voltage`)
    * The script waits for amdgpu's sysfs files, since the service can otherwise start before they exist
    * GPU is at PCI address `0000:2b:00.0` — check with `lspci | grep VGA` if hardware changes
* Verify (`nvidia-smi` doesn't apply, this is AMD):
    * `cat /sys/bus/pci/devices/0000:2b:00.0/hwmon/hwmon*/power1_cap` — should be `197000000`
    * `cat /sys/bus/pci/devices/0000:2b:00.0/pp_od_clk_voltage` — should show `1: 2000Mhz` and `-50mV`
    * `systemctl status gpu-limit.service`
* Monitor: `watch -n1 'cat /sys/bus/pci/devices/0000:2b:00.0/hwmon/hwmon*/{power1_average,temp1_input}'` (µW / m°C), or `btop`/`nvtop`
* Test under load: run a GPU benchmark (`vkmark`, `glmark2`, or a game) while watching power; `power1_average` should stay ≤ ~197 W and the PC shouldn't shut off

## CPU / GPU monitoring (waybar + shell)
* Waybar right side shows `CPU: 50% 82°C`, `GPU: 15% 56°C 34W`, `VRAM: 1.0`, `RAM: 7.1`, `Vol: 82`, `BT: ...`; clicking CPU/GPU opens btop
    * Scripts live in `home/bash_scripts/` (symlinked to `~/bash_scripts`): `cpu_stats.sh`, `gpu_stats.sh`, `vram_stats.sh` — each prints waybar JSON (text + tooltip + class)
    * `cpu_stats.sh` samples `/proc/stat` over 0.5 s and reads the Ryzen `k10temp` Tctl; tooltip has avg clock + governor
    * `gpu_stats.sh` reads amdgpu sysfs (busy %, junction temp, power vs cap, clock, fan, VRAM); `gpu_stats.sh -v` prints a readable summary incl. CPU
    * Text turns red near the limit: CPU >= 92°C (Ryzen 3600 throttles ~95°C), GPU junction >= 105°C (critical 110°C)
    * Sensor paths are hardcoded (CPU: `/sys/devices/pci0000:00/0000:00:18.3/hwmon`, GPU: `0000:2b:00.0`); hwmon numbers aren't stable across boots, so don't use them
    * Idle inhibitor, clock icons removed; reload bar with `pkill -SIGUSR2 waybar`
* Aliases (`.bashrc`): `gpu` (summary), `gpuwatch` (refresh every 1 s), `temps` (live `sensors` for CPU + GPU)
* Tctl reads hotter than Tccd1 (die sensor) on Zen 2; ~88-94°C Tctl under moderate load suggests a cooler problem
    * Check: dust in cooler/case fans, old paste (repaste: twist cooler before lifting, IPA to clean, pea-sized dot, tighten in an X)
    * Quick test: `echo 0 | sudo tee /sys/devices/system/cpu/cpufreq/boost` disables boost until reboot (`1` to re-enable)
    * Stress test: `stress-ng --cpu 12 --timeout 60s` while watching `temps`

## Game FPS overlay (MangoHud)
* Install: `sudo pacman -S mangohud lib32-mangohud`
* Steam: game, Properties, Launch Options: `mangohud %command%` (if no overlay: `mangohud --dlsym %command%`)
* Toggle in-game with Left Ctrl + Left Shift + M (`toggle_hud` in the config; default was Right Shift + F12); config is `home/.config/MangoHud/MangoHud.conf` (minimal: FPS + frametime graph; CPU/GPU stats are on waybar. Add `cpu_stats`, `gpu_stats`, `gpu_temp`, `vram`, `ram` etc. for more)
* Steam's own counter (Settings, In Game) is the fallback; `stat fps` console in Unreal games isn't reliable in shipping builds

## Local LLM (Ollama, RX 6800 16 GB)
* Install: `sudo pacman -S ollama-rocm` (ROCm supports gfx1030; `ollama-vulkan` is the lighter alternative), then `sudo systemctl enable --now ollama`
* `ollama run qwen3:14b` — ~9 GB, fits fully in VRAM; `/set nothink` turns off the reasoning preamble, `/bye` exits
* Other models for 16 GB: `llama3.1:8b` (~5 GB, faster), `qwen2.5-coder:14b` (code); much over 14B spills into system RAM and gets slow
* Verify GPU use: `ollama ps` should say `100% GPU`; `gpu` / VRAM module should jump to ~9-10 GB
* Only 15 GB system RAM, and the GPU is power-capped to 197 W (see above) — watch CPU/GPU temps during long generations
* Later: Open WebUI for a browser chat UI, `llama.cpp` for lower-level control

## Guitar rig (Focusrite Scarlett Solo)
* `./setup-guitar.sh` — installs Carla, Ratatouille (NAM amp + cab IR), AIDA-X, Guitarix, qpwgraph; sets PipeWire buffer to 128 samples (`~/.config/pipewire/pipewire.conf.d/10-guitar-latency.conf`; use 256 if it crackles). Log out/in once for the `realtime` group.
* Plug guitar into Solo input 1, press **INST**, keep gain just below red.
* `carla` — plugin host. Add Ratatouille, load a `.nam` model (e.g. from ToneHunt) and a cabinet IR.
* `qpwgraph` — visual routing if the guitar isn't reaching Carla/output.
* Latency check: `pw-metadata -n settings 0 clock.quantum`
* Alternatives: Guitarix (classic DSP amps, no downloads needed), Reaper/Ardour if you want to record.

## Corne keyboard (QMK)
* Keymaps live in `~/qmk_firmware/keyboards/crkbd/keymaps/` (`gkerr708-gaming`, `gkerr708-work`); RP2040 via `CONVERT_TO=blok`
* `corne-flash` — builds the keymap, then flashes each half as you put it in bootloader mode (unplug, replug holding BOOT + tapping RESET). It mounts the `RPI-RP2` drive and copies the `.uf2` for you.
    * `corne-flash -1` — only one half
    * `corne-flash -s` — skip the build, flash the existing `.uf2`
    * `corne-flash -k gkerr708-work` — different keymap
* Script is `home/.local/bin/corne-flash` (symlinked to `~/.local/bin`; stow does this on a fresh install)
* Needs: `qmk` (pacman), `qmk_firmware` submodules (`git submodule update --init --recursive`)
