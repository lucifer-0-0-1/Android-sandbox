#!/usr/bin/env bash
# scripts/03-install-dependencies.sh
set -euo pipefail

echo "[*] Installing Waydroid, LXC, and platform tools via pacman..."

# Refresh package databases first to avoid 404 errors on stale package versions
sudo pacman -Sy --needed --noconfirm \
    waydroid \
    lxc \
    dnsmasq \
    iptables-nft \
    android-tools \
    scrcpy \
    python-pip \
    git \
    curl \
    jq

# Enable waydroid container service
sudo systemctl enable waydroid-container.service

echo "[+] Dependencies installed and waydroid-container service enabled."
