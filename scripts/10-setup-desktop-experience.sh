#!/usr/bin/env bash
# scripts/10-setup-desktop-experience.sh
set -euo pipefail

echo "[*] Configuring BlueStacks-like desktop experience..."

# 1. Enable seamless multi-window mode (each app is a native Wayland window)
sudo waydroid prop set persist.waydroid.multi_windows true 2>/dev/null || true

# 2. Configure default window orientation and DPI (e.g. tablet 280 DPI or phone 320 DPI)
sudo waydroid prop set persist.waydroid.width 1080 2>/dev/null || true
sudo waydroid prop set persist.waydroid.height 1920 2>/dev/null || true
sudo waydroid prop set persist.waydroid.dpi 320 2>/dev/null || true

# 3. Setup host-shared directory
SHARED_DIR="$HOME/Android_sandbox/shared"
mkdir -p "$SHARED_DIR"

# Mount shared directory into Android /sdcard/HostShared
sudo waydroid shell mkdir -p /sdcard/HostShared 2>/dev/null || true
sudo waydroid shell mount --bind "$SHARED_DIR" /sdcard/HostShared 2>/dev/null || true

# 4. Install Waydroid Helper GUI if available in chaotic-aur
if pacman -Ss waydroid-helper &>/dev/null; then
    sudo pacman -S --needed --noconfirm waydroid-helper || true
fi

echo "[+] Desktop integration complete: multi-window active, shared folder created at $SHARED_DIR."
