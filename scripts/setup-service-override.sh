#!/usr/bin/env bash
# scripts/setup-service-override.sh
# Permanently configure waydroid-container to fix binder permissions on every startup
set -euo pipefail

echo "[*] Creating systemd drop-in override for waydroid-container..."
sudo mkdir -p /etc/systemd/system/waydroid-container.service.d/

cat << 'EOF' | sudo tee /etc/systemd/system/waydroid-container.service.d/override.conf > /dev/null
[Service]
ExecStartPost=/usr/bin/bash -c "chmod 0755 /dev/binderfs && chmod 0755 /dev/binderfs/features 2>/dev/null; chmod 0666 /dev/binderfs/binder /dev/binderfs/hwbinder /dev/binderfs/vndbinder /dev/binder /dev/hwbinder /dev/vndbinder 2>/dev/null || true"
EOF

sudo systemctl daemon-reload
echo "[+] Systemd drop-in override active. Permissions will now be set automatically on every start."
