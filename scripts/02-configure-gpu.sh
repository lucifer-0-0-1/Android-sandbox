#!/usr/bin/env bash
# scripts/02-configure-gpu.sh
set -euo pipefail

echo "[*] Detecting GPU architecture for Android container acceleration..."

INTEL_NODE=$(ls -l /dev/dri/by-path/*00:02.0-render 2>/dev/null | awk '{print $NF}' | sed 's|../|/dev/dri/|' || true)
NVIDIA_NODE=$(ls -l /dev/dri/by-path/*01:00.0-render 2>/dev/null | awk '{print $NF}' | sed 's|../|/dev/dri/|' || true)

mkdir -p config

# On hybrid laptops, proprietary NVIDIA drivers fail with Waydroid container EGL/GBM contexts.
# The Intel Iris/Mesa node MUST be selected for direct hardware acceleration.
if [[ -n "$INTEL_NODE" ]] && [[ -c "$INTEL_NODE" ]]; then
    SELECTED_NODE="$INTEL_NODE"
    DRIVER="iris"
    echo "[+] Detected Intel Integrated GPU at $INTEL_NODE. Setting as primary render node."
elif [[ -n "$NVIDIA_NODE" ]] && [[ -c "$NVIDIA_NODE" ]]; then
    SELECTED_NODE="$NVIDIA_NODE"
    DRIVER="nvidia"
    echo "[!] Warning: Only NVIDIA GPU found at $NVIDIA_NODE."
else
    SELECTED_NODE="/dev/dri/renderD128"
    DRIVER="generic"
fi

cat <<EOF > config/gpu.conf
# Android Sandbox GPU configuration
TARGET_RENDER_NODE=$SELECTED_NODE
DRIVER_TYPE=$DRIVER
WAYDROID_GPU_OVERRIDE=$SELECTED_NODE
EOF

# Also try copying to /etc/android-sandbox/gpu.conf if root permissions exist
if [[ $EUID -eq 0 ]] || sudo -n true 2>/dev/null; then
    sudo mkdir -p /etc/android-sandbox
    sudo cp config/gpu.conf /etc/android-sandbox/gpu.conf
fi

echo "[+] Saved GPU configuration to config/gpu.conf"
