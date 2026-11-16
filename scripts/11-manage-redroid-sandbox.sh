#!/usr/bin/env bash
# scripts/11-manage-redroid-sandbox.sh
set -euo pipefail

ACTION="${1:-start}"

case "$ACTION" in
    start)
        echo "[*] Starting disposable ReDroid container..."
        docker compose -f docker/docker-compose.redroid.yml up -d
        echo "[*] Connecting ADB to sandbox..."
        sleep 5
        adb connect localhost:5555 || true
        echo "[+] Sandbox started. Launching scrcpy view..."
        scrcpy -s localhost:5555 --window-title "Disposable Android Sandbox" &
        ;;
    stop)
        echo "[*] Stopping disposable ReDroid container..."
        docker compose -f docker/docker-compose.redroid.yml down
        echo "[+] Sandbox stopped."
        ;;
    reset)
        echo "[*] Destroying and wiping sandbox data..."
        docker compose -f docker/docker-compose.redroid.yml down -v
        sudo rm -rf docker/data
        echo "[+] Sandbox reset to pristine factory state."
        ;;
    *)
        echo "Usage: $0 {start|stop|reset}"
        exit 1
        ;;
esac
