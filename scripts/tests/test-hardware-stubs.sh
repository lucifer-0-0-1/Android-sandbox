#!/usr/bin/env bash
# scripts/tests/test-hardware-stubs.sh
set -euo pipefail

BATTERY_STATUS=$(sudo waydroid shell dumpsys battery 2>/dev/null | grep "status:" | awk '{print $2}' || true)
SIM_STATE=$(sudo waydroid shell getprop gsm.sim.state 2>/dev/null | tr -d '\r\n' || true)

echo "[*] Battery Status: $BATTERY_STATUS, SIM State: $SIM_STATE"
if [[ "$BATTERY_STATUS" != "3" ]] || [[ "$SIM_STATE" != "READY" ]]; then
    echo "[-] FAIL: Hardware stubs not applied (Battery: $BATTERY_STATUS, SIM: $SIM_STATE)." >&2
    exit 1
fi

echo "[+] PASS: Battery reports realistic discharge state and SIM reports READY."
exit 0
