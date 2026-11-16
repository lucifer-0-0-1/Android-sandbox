#!/usr/bin/env bash
# scripts/tests/test-desktop-integration.sh
set -euo pipefail

MULTI_WINDOW=$(sudo waydroid prop get persist.waydroid.multi_windows 2>/dev/null | tr -d '\r\n' || true)
if [[ "$MULTI_WINDOW" != "true" ]]; then
    echo "[-] FAIL: Multi-window desktop integration is not enabled!" >&2
    exit 1
fi

echo "[+] PASS: Seamless multi-window mode enabled."
exit 0
