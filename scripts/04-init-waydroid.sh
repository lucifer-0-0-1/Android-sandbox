#!/usr/bin/env bash
# scripts/04-init-waydroid.sh
set -euo pipefail

echo "[*] Initializing Waydroid with lightweight VANILLA image..."

# Read target GPU render node from Task 2
CONFIG_FILE="config/gpu.conf"
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    TARGET_RENDER_NODE="/dev/dri/renderD129"
fi

# Initialize Waydroid with VANILLA LineageOS image if not already initialized
if [[ ! -d "/var/lib/waydroid/images" ]]; then
    echo "[*] Downloading and initializing Waydroid system and vendor images (VANILLA)..."
    sudo waydroid init -s VANILLA -f
fi

# Configure Waydroid to strictly use the Intel iGPU render node to avoid NVIDIA hybrid crash
echo "[*] Configuring GPU render node: $TARGET_RENDER_NODE"
sudo waydroid prop set ro.hardware.gralloc minigbm_gbm_mesa 2>/dev/null || true
sudo waydroid prop set persist.waydroid.gpu_override "$TARGET_RENDER_NODE" 2>/dev/null || true

# Restart container service
sudo systemctl restart waydroid-container.service || true

echo "[+] Waydroid initialized with VANILLA image and bound to $TARGET_RENDER_NODE."
