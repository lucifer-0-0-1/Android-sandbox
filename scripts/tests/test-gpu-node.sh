#!/usr/bin/env bash
# scripts/tests/test-gpu-node.sh
set -euo pipefail

CONFIG_FILE="${1:-config/gpu.conf}"
if [[ ! -f "$CONFIG_FILE" ]] && [[ -f "/etc/android-sandbox/gpu.conf" ]]; then
    CONFIG_FILE="/etc/android-sandbox/gpu.conf"
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "[-] FAIL: GPU configuration file $CONFIG_FILE does not exist!" >&2
    exit 1
fi

source "$CONFIG_FILE"
if [[ -z "${TARGET_RENDER_NODE:-}" ]] || [[ ! -c "$TARGET_RENDER_NODE" ]]; then
    echo "[-] FAIL: Target render node '$TARGET_RENDER_NODE' is invalid or not a character device!" >&2
    exit 1
fi

echo "[+] PASS: Target GPU node verified: $TARGET_RENDER_NODE (Driver: $DRIVER_TYPE)"
exit 0
