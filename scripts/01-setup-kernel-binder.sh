#!/usr/bin/env bash
# scripts/01-setup-kernel-binder.sh
set -euo pipefail

echo "[*] Setting up Android BinderFS on host Linux kernel..."

# Create mountpoint and mount binderfs if not already mounted
if ! mountpoint -q /dev/binderfs; then
    echo "[*] Mounting binderfs to /dev/binderfs..."
    sudo mkdir -p /dev/binderfs
    sudo mount -t binder binder /dev/binderfs
fi

# Ensure standard device nodes exist or symlink to /dev
for dev in binder hwbinder vndbinder; do
    if [[ -c "/dev/binderfs/$dev" ]] && [[ ! -e "/dev/$dev" ]]; then
        echo "[*] Creating symlink /dev/$dev -> /dev/binderfs/$dev..."
        sudo ln -sf "/dev/binderfs/$dev" "/dev/$dev"
    fi
done

# Persist mount in /etc/fstab if not already present
if ! grep -q "/dev/binderfs" /etc/fstab; then
    echo "[*] Adding binderfs mount to /etc/fstab for persistence..."
    echo "binder /dev/binderfs binder default 0 0" | sudo tee -a /etc/fstab
fi

# Ensure read/write access
sudo chmod 666 /dev/binderfs/* /dev/binder* 2>/dev/null || true

echo "[+] BinderFS successfully mounted and configured."
