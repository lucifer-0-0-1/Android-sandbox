#!/usr/bin/env bash
# scripts/tests/test-packages.sh
set -euo pipefail

MISSING=0
for bin in waydroid lxc-attach iptables dnsmasq adb scrcpy; do
    if ! command -v "$bin" &>/dev/null; then
        echo "[-] MISSING: Required binary '$bin' is not installed."
        MISSING=$((MISSING + 1))
    else
        echo "[+] FOUND: $bin ($(command -v "$bin"))"
    fi
done

if [[ $MISSING -gt 0 ]]; then
    echo "[-] FAIL: $MISSING required package(s) missing!" >&2
    exit 1
fi

echo "[+] PASS: All core package dependencies installed."
exit 0
