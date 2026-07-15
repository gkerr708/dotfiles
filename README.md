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

