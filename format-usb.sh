#!/usr/bin/env bash
# Wipe the Arch installer USB and reformat it as a single exFAT partition.
set -euo pipefail

DEV=/dev/sdb

# Safety check: make sure /dev/sdb is still the USB flash drive, not some other disk.
model=$(lsblk -dno MODEL "$DEV" | xargs)
tran=$(lsblk -dno TRAN "$DEV" | xargs)
if [[ "$tran" != "usb" || "$model" != "USB Flash Drive" ]]; then
    echo "Refusing: $DEV is '$model' ($tran), not the expected USB Flash Drive." >&2
    exit 1
fi

lsblk -o NAME,SIZE,FSTYPE,LABEL,MODEL "$DEV"
read -rp "Erase EVERYTHING on $DEV shown above? Type YES to continue: " ans
[[ "$ans" == "YES" ]] || { echo "Aborted."; exit 1; }

sudo pacman -S --needed --noconfirm exfatprogs

# Unmount any mounted partitions on the drive
for p in $(lsblk -lno NAME "$DEV" | tail -n +2); do
    sudo umount "/dev/$p" 2>/dev/null || true
done

sudo wipefs -a "$DEV"
echo 'type=7' | sudo sfdisk --label dos "$DEV"
sudo partprobe "$DEV" 2>/dev/null || sleep 2
# The old installer's vfat signature can survive at the new partition's offset
sudo wipefs -a "${DEV}1"
sudo mkfs.exfat -L USB "${DEV}1"

echo
lsblk -o NAME,SIZE,FSTYPE,LABEL "$DEV"
echo "Done. Unplug and replug the USB."
