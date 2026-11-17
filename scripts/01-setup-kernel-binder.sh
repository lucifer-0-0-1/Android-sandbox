#!/usr/bin/env bash
# scripts/01-setup-kernel-binder.sh
set -euo pipefail

echo "[*] Setting up Android BinderFS on host Linux kernel..."

# Create mountpoint and mount binderfs if not already mounted
if ! mountpoint -q /dev/binderfs; then
    echo "[*] Mounting binderfs to /dev/binderfs..."
    sudo mkdir -p /dev/binderfs
    sudo mount -t binder none /dev/binderfs
fi

# Ensure standard device nodes exist or symlink to /dev
for dev in binder hwbinder vndbinder; do
    if [[ -c "/dev/binderfs/$dev" ]] && [[ ! -e "/dev/$dev" ]]; then
        echo "[*] Creating symlink /dev/$dev -> /dev/binderfs/$dev..."
        sudo ln -sf "/dev/binderfs/$dev" "/dev/$dev"
    fi
done

# Clean up any stale fstab entries (never persist in /etc/fstab as early-boot fstab errors halt system boot)
if grep -q "binderfs" /etc/fstab 2>/dev/null; then
    echo "[*] Removing any unsafe binderfs entries from /etc/fstab..."
    sudo sed -i '/binderfs/d' /etc/fstab
fi

# Ensure read/write access for regular desktop user sessions
sudo chmod 0755 /dev/binderfs /dev/binderfs/features 2>/dev/null || true
sudo chmod 0666 /dev/binderfs/binder /dev/binderfs/hwbinder /dev/binderfs/vndbinder /dev/binderfs/binder-control /dev/binder /dev/hwbinder /dev/vndbinder 2>/dev/null || true

# Setup udev rule for persistent binder permissions
cat << 'EOF' | sudo tee /etc/udev/rules.d/99-android-binder.rules > /dev/null
KERNEL=="binder|hwbinder|vndbinder", MODE="0666", OWNER="root", GROUP="root"
SUBSYSTEM=="binderfs", MODE="0666"
EOF
sudo udevadm control --reload-rules 2>/dev/null || true
sudo udevadm trigger 2>/dev/null || true

echo "[+] BinderFS successfully mounted and configured."
