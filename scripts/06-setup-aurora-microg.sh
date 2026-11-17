#!/usr/bin/env bash
# scripts/06-setup-aurora-microg.sh
set -euo pipefail

echo "[*] Setting up Aurora Store (open-source Google Play client)..."

AURORA_APK="/tmp/AuroraStore.apk"
if [[ ! -f "$AURORA_APK" ]]; then
    echo "[*] Downloading latest stable Aurora Store APK..."
    curl -sSL "https://auroraoss.com/downloads/AuroraStore/Release/AuroraStore-4.6.4.apk" -o "$AURORA_APK" || \
    curl -sSL "https://f-droid.org/repo/com.aurora.store_61.apk" -o "$AURORA_APK" || true
fi

if [[ -f "$AURORA_APK" ]]; then
    echo "[*] Installing Aurora Store into Android container..."
    if waydroid status 2>/dev/null | grep -q "RUNNING"; then
        waydroid app install "$AURORA_APK" || sudo waydroid shell pm install -r "$AURORA_APK"
    else
        echo "[!] Waydroid session not active. Starting session..."
        sudo systemctl start waydroid-container 2>/dev/null || true
        sudo waydroid shell pm install -r "$AURORA_APK" || true
    fi
fi

echo "[*] Granting microG permissions..."
sudo waydroid shell pm grant com.google.android.gms android.permission.ACCESS_FINE_LOCATION 2>/dev/null || true
sudo waydroid shell pm grant com.google.android.gms android.permission.ACCESS_COARSE_LOCATION 2>/dev/null || true

echo "[+] Aurora Store ready. You can now install Play Store apps."
