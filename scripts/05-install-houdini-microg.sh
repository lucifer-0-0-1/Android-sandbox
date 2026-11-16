#!/usr/bin/env bash
# scripts/05-install-houdini-microg.sh
set -euo pipefail

echo "[*] Installing ARM translation (libhoudini), microG, and Widevine L3 via waydroid_script..."

SCRIPT_DIR="/opt/waydroid_script"
if [[ ! -d "$SCRIPT_DIR" ]]; then
    sudo git clone --depth=1 https://github.com/casualsnek/waydroid_script "$SCRIPT_DIR"
    sudo python3 -m venv "$SCRIPT_DIR/venv"
    sudo "$SCRIPT_DIR/venv/bin/pip" install -r "$SCRIPT_DIR/requirements.txt"
fi

echo "[*] Stopping Waydroid container before injection..."
sudo systemctl stop waydroid-container.service || true

echo "[*] Injecting libhoudini (Intel ARM64->x86_64 translator)..."
sudo "$SCRIPT_DIR/venv/bin/python3" "$SCRIPT_DIR/main.py" install libhoudini

echo "[*] Injecting microG GmsCore & Services..."
sudo "$SCRIPT_DIR/venv/bin/python3" "$SCRIPT_DIR/main.py" install microg

echo "[*] Injecting Widevine L3 DRM support..."
sudo "$SCRIPT_DIR/venv/bin/python3" "$SCRIPT_DIR/main.py" install widevine || true

echo "[*] Restarting Waydroid container..."
sudo systemctl restart waydroid-container.service
sleep 3

echo "[+] ARM translation (libhoudini), microG, and Widevine L3 installed successfully."
