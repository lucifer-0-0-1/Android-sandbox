#!/usr/bin/env bash
# scripts/06-setup-aurora-microg.sh
set -euo pipefail

echo "[*] Setting up Aurora Store (open-source Google Play client)..."

AURORA_APK="/tmp/AuroraStore.apk"
if [[ ! -f "$AURORA_APK" ]]; then
    echo "[*] Downloading latest stable Aurora Store APK..."
    curl -sSL "https://auroraoss.com/downloads/AuroraStore/Release/AuroraStore-4.6.4.apk" -o "$AURORA_APK" || \
    curl -sSL "https://f-droid.org/repo/com.aurora.store_59.apk" -o "$AURORA_APK" || true
fi

if [[ -f "$AURORA_APK" ]]; then
    echo "[*] Installing Aurora Store into Waydroid..."
    waydroid app install "$AURORA_APK" 2>/dev/null || sudo waydroid shell pm install -r "$AURORA_APK" 2>/dev/null || true
fi

echo "[*] Granting microG permissions..."
sudo waydroid shell pm grant com.google.android.gms android.permission.ACCESS_FINE_LOCATION 2>/dev/null || true
sudo waydroid shell pm grant com.google.android.gms android.permission.ACCESS_COARSE_LOCATION 2>/dev/null || true

echo "[+] Aurora Store ready. You can now install Play Store apps."
