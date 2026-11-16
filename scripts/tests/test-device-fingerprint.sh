#!/usr/bin/env bash
# scripts/tests/test-device-fingerprint.sh
set -euo pipefail

MODEL=$(sudo waydroid shell getprop ro.product.model 2>/dev/null | tr -d '\r\n' || true)
BRAND=$(sudo waydroid shell getprop ro.product.brand 2>/dev/null | tr -d '\r\n' || true)
FINGERPRINT=$(sudo waydroid shell getprop ro.build.fingerprint 2>/dev/null | tr -d '\r\n' || true)

echo "[*] Detected: Brand=$BRAND, Model=$MODEL"
if [[ -z "$MODEL" ]] || [[ "$MODEL" == *"waydroid"* ]] || [[ "$MODEL" == *"generic"* ]] || [[ "$BRAND" == *"waydroid"* ]]; then
    echo "[-] FAIL: Device is reporting Waydroid/generic emulator identity: '$MODEL'" >&2
    exit 1
fi

echo "[+] PASS: Device spoofing active. Identified as: $BRAND $MODEL ($FINGERPRINT)"
exit 0
