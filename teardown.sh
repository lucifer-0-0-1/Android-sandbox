#!/usr/bin/env bash
# teardown.sh - Completely clean up Waydroid, images, and local project storage
set -euo pipefail

echo "[*] 1. Stopping Waydroid sessions and container services..."
waydroid session stop 2>/dev/null || true
sudo systemctl stop waydroid-container 2>/dev/null || true
sudo systemctl disable waydroid-container 2>/dev/null || true

echo "[*] 2. Removing waydroid packages..."
sudo pacman -Rns --noconfirm waydroid 2>/dev/null || true

echo "[*] 3. Removing all container images, rootfs, caches and overlays (~5.3 GB)..."
sudo rm -rf /var/lib/waydroid
sudo rm -rf /var/log/waydroid.log
sudo rm -rf "$HOME/.cache/waydroid-script"
rm -rf "$HOME/.local/share/waydroid"
rm -f "$HOME/.local/share/applications/*waydroid*" 2>/dev/null || true
rm -f /tmp/AuroraStore.apk 2>/dev/null || true

echo "[*] 4. Removing service overrides and rules..."
sudo rm -rf /etc/systemd/system/waydroid-container.service.d
sudo rm -f /etc/udev/rules.d/99-android-binder.rules
sudo rm -f /etc/sysctl.d/30-waydroid-forward.conf
sudo systemctl daemon-reload

echo "[+] Waydroid and all Android storage (~5.3 GB) completely wiped!"
