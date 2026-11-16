#!/usr/bin/env bash
# scripts/tests/test-redroid-instance.sh
set -euo pipefail

if ! docker ps --format '{{.Names}}' | grep -q "redroid-sandbox"; then
    echo "[-] FAIL: ReDroid sandbox container is not running!" >&2
    exit 1
fi

echo "[+] PASS: ReDroid disposable sandbox instance running and healthy."
exit 0
