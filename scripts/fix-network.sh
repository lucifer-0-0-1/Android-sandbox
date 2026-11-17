#!/usr/bin/env bash
# scripts/fix-network.sh
# Fix internet connectivity for Waydroid sandbox on Garuda/Arch Linux
set -euo pipefail

echo "=== Fixing Android Sandbox Internet Connectivity ==="

echo "[*] 1. Enabling Linux kernel IPv4 packet forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/30-waydroid-forward.conf > /dev/null

echo "[*] 2. Configuring Firewall rules (firewalld / iptables)..."
if command -v firewall-cmd &>/dev/null && systemctl is-active firewalld &>/dev/null; then
    echo "[*] Adding waydroid0 bridge to firewalld trusted zone..."
    sudo firewall-cmd --zone=trusted --add-interface=waydroid0 --permanent || true
    sudo firewall-cmd --zone=public --add-masquerade --permanent || true
    sudo firewall-cmd --reload || true
fi

echo "[*] 3. Ensuring iptables FORWARD policy is ACCEPT (countering Docker policy)..."
sudo iptables -P FORWARD ACCEPT 2>/dev/null || true
sudo iptables -I FORWARD -i waydroid0 -j ACCEPT 2>/dev/null || true
sudo iptables -I FORWARD -o waydroid0 -j ACCEPT 2>/dev/null || true

echo "[*] 4. Restarting Waydroid container service..."
sudo systemctl restart waydroid-container
sleep 3

echo "[*] 5. Setting fallback DNS (8.8.8.8 and 1.1.1.1) inside Android container..."
sudo waydroid shell setprop net.dns1 8.8.8.8 2>/dev/null || true
sudo waydroid shell setprop net.dns2 1.1.1.1 2>/dev/null || true

echo "[+] Network fix complete!"
echo "[*] Testing connection inside Android container..."
if sudo waydroid shell ping -c 2 8.8.8.8 &>/dev/null; then
    echo "[+] SUCCESS: Internet ping to 8.8.8.8 succeeded inside Android!"
else
    echo "[!] Note: If ping is blocked by ICMP rules, open a browser app inside Android to verify."
fi
