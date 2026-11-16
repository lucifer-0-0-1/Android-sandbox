#!/usr/bin/env bash
# scripts/09-emulate-hardware-sensors.sh
set -euo pipefail

echo "[*] Injecting realistic battery and telephony sensor states..."

# 1. Emulate realistic battery state (discharging at 85% instead of constant AC power)
sudo waydroid shell dumpsys battery unplug 2>/dev/null || true
sudo waydroid shell dumpsys battery set level 85 2>/dev/null || true
sudo waydroid shell dumpsys battery set status 3 2>/dev/null || true  # BATTERY_STATUS_DISCHARGING
sudo waydroid shell dumpsys battery set health 2 2>/dev/null || true  # BATTERY_HEALTH_GOOD
sudo waydroid shell dumpsys battery set temp 280 2>/dev/null || true   # 28.0 C

# 2. Inject realistic telephony / carrier metadata
sudo waydroid prop set gsm.sim.state "READY" 2>/dev/null || true
sudo waydroid prop set gsm.operator.numeric "310260" 2>/dev/null || true
sudo waydroid prop set gsm.operator.alpha "T-Mobile" 2>/dev/null || true
sudo waydroid prop set gsm.network.type "LTE" 2>/dev/null || true

# 3. Enable mock location provider for GPS spoofing
sudo waydroid shell settings put secure mock_location 1 2>/dev/null || true

echo "[+] Hardware stubs active: Realistic battery (85% discharging) and LTE carrier injected."
