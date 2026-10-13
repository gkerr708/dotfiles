# Arch Linux Cheatsheet

## USB
* `lsblk` — list block devices
* `udisksctl mount -b /dev/sda1`
* `udisksctl unmount -b /dev/sda1`
* `udisksctl power-off -b /dev/sda`
* `format-usb` — wipe the old Arch installer USB (`/dev/sdb`) and reformat it as exFAT

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
  802-1x.identity "YOUR_NETID@dal.ca" \
  802-1x.password "PASTE_PASSWORD_HERE"

sudo nmcli connection up "Dalhousie"
```
* `802-1x.identity` — school email/username
* If auth fails, try adding `802-1x.anonymous-identity "@dal.ca"`, or `802-1x.eap ttls` instead of `peap` (depends what the campus RADIUS server expects)
* `nmcli connection delete "Dalhousie"` — remove the profile

### Wifi dropping out (Dalhousie, Oct 2026)
**Don't** set `802-11-wireless.band a` on the main `Dalhousie` profile — NetworkManager has no "prefer 5 GHz", that forces 5 GHz only, and wifi went down when the Intel 8260 couldn't find a 5 GHz AP. Undo: `nmcli connection modify Dalhousie 802-11-wireless.band ""` then `nmcli connection up Dalhousie`

1. **Check whether it was a real drop**
    * `journalctl -b -u NetworkManager | grep -iE "ssid-not-found|association took|failed|radio-control"`
    * `journalctl -b -k | grep wlp4s0`
    * `radio-control wireless-enabled:off` / `deauthenticating ... by local choice` — wifi was turned off on this laptop (nmcli/applet), not a real drop
    * `ssid-not-found` / `association took too long` — scan never found the AP; radio problem, not password
    * `authentication with ... timed out` — AP didn't answer; usually a crowded channel
2. **Rescan, then reconnect** (untested whether this helps it pick 5 GHz)
    * `nmcli device wifi rescan`
    * wait a few seconds; `nmcli -f BSSID,CHAN,SIGNAL dev wifi list | grep -i dalhousie` should list 5 GHz channels (36+)
    * `nmcli connection up Dalhousie`
3. **Still dropping: try `eduroam`** — same APs broadcast it
4. **Check which band you're on**
    * `nmcli -f IN-USE,BSSID,CHAN,SIGNAL dev wifi list | grep '^\*'` (channel 1-13 = 2.4 GHz, 36+ = 5 GHz)
    * It usually ends up on the 2.4 GHz AP on channel 6 (crowded), even with a strong 5 GHz AP on channel 165
5. **Dig into 5 GHz (optional)**
    * `sudo pacman -S iw`, then `iw reg get` — `CA` is right; world `00` would explain 5 GHz APs being missed (untested guess)
    * Safe 5 GHz test with a separate profile (`Dalhousie-5G` already exists, autoconnect off) that falls back to the normal one:
```
nmcli connection clone Dalhousie Dalhousie-5G
nmcli connection modify Dalhousie-5G 802-11-wireless.band a connection.autoconnect no
nmcli connection up Dalhousie-5G || nmcli connection up Dalhousie
```
    * Oct 2026: `Dalhousie-5G` didn't connect; the fallback put it back on 2.4 GHz. Remove with `nmcli connection delete Dalhousie-5G`

Not the battery: wifi powersave is already off (`/etc/NetworkManager/conf.d/wifi-powersave.conf`, `wifi.powersave = 2`; `cat /sys/module/iwlwifi/parameters/power_save` is `N`)

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
* **SUPER + /** — searchable list of all keybinds
* **SUPER + SHIFT + M** — animations on/off (resets on `hyprctl reload`)

## Screenshot
* `grimblast save area path/to/image.png`

