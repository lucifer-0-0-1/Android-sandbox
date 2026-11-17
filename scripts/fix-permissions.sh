#!/usr/bin/env bash
# scripts/fix-permissions.sh
# Fix permissions on binderfs directory and device nodes
set -euo pipefail

echo "[*] Fixing binderfs directory traverse (+x) permissions..."
sudo chmod 0755 /dev/binderfs
sudo chmod 0755 /dev/binderfs/features 2>/dev/null || true

echo "[*] Fixing binder character devices read/write permissions..."
sudo chmod 0666 /dev/binderfs/binder /dev/binderfs/hwbinder /dev/binderfs/vndbinder /dev/binderfs/binder-control 2>/dev/null || true
sudo chmod 0666 /dev/binder /dev/hwbinder /dev/vndbinder 2>/dev/null || true

echo "[+] Done. Verifying access..."
ls -ld /dev/binderfs
ls -l /dev/binderfs/
