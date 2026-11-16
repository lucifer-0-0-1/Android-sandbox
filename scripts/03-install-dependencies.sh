#!/usr/bin/env bash
# scripts/03-install-dependencies.sh
set -euo pipefail

echo "[*] Installing Waydroid, LXC, and platform tools via pacman..."

sudo pacman -S --needed --noconfirm \
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
