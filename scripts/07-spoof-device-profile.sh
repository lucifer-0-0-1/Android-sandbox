#!/usr/bin/env bash
# scripts/07-spoof-device-profile.sh
set -euo pipefail

PROFILE="${1:-config/device-profiles/pixel7.prop}"
echo "[*] Injecting device fingerprint profile from $PROFILE..."

if [[ ! -f "$PROFILE" ]]; then
    echo "[-] Profile $PROFILE not found!" >&2
    exit 1
fi

while IFS='=' read -r key val; do
    [[ -z "$key" || "$key" =~ ^# ]] && continue
    sudo waydroid prop set "$key" "$val"
done < "$PROFILE"

# Clean up container emulator flags
sudo waydroid prop set ro.kernel.qemu 0
sudo waydroid prop set ro.boot.qemu 0
sudo waydroid prop set ro.hardware.virtual_device 0

sudo systemctl restart waydroid-container.service
sleep 3
echo "[+] Device profile injected and container reloaded."
