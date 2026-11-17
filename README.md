# Native Android Sandbox on Linux

A lightweight, containerized native Android runtime environment for Linux. Runs Android applications directly on top of the host Linux kernel using namespaces, BinderFS, and Mesa Direct Rendering Infrastructure (DRI)—consuming under **500 MB idle RAM** with **near-zero virtualization overhead** (a modern, open-source alternative to heavy 4–8 GB BlueStacks/QEMU VMs).

---

## 🌟 Key Features

- **Near-Zero Virtualization Penalty**: Runs directly on the host Linux kernel via unprivileged LXC containers; zero CPU trap-and-emulate emulation.
- **Hardware GPU Acceleration**: Direct DRI/Mesa hardware rendering mapped to integrated or discrete GPUs (configured to bypass proprietary hybrid GPU black-screen issues).
- **ARM64 / ARM32 Binary Translation**: Native execution of ARM APKs (like *Clash of Clans*, *Supercell* titles, and 3D games) on x86_64 CPUs using Intel `libhoudini`.
- **Chameleon Anti-Detection Stack**:
  - Spoofs retail device fingerprints (Google Pixel 7 `panther`).
  - Hides emulator flags (`qemu`, `goldfish`, container namespaces).
  - Injects realistic battery states (85% discharging) and telephony/LTE metadata.
- **Dual Runtime Architecture**:
  1. **Waydroid Desktop Engine**: Daily driver with seamless Wayland multi-window integration (apps float like native desktop windows) or full tablet launcher UI.
  2. **ReDroid Disposable Engine**: On-demand, isolated Docker containers mirrored with low-latency `scrcpy` for testing untrusted APKs.

---

## 📋 Prerequisites

- **OS**: Linux (Arch, Garuda, Fedora, Debian/Ubuntu)
- **Kernel**: Linux 5.10+ with `CONFIG_ANDROID_BINDERFS=y`
- **Display**: Wayland session (KDE Plasma, GNOME, Sway, Hyprland)
- **Packages**: `waydroid`, `lxc`, `dnsmasq`, `iptables` / `nftables`, `scrcpy`, `android-tools`

---

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/lucifer-0-0-1/Android-sandbox.git
cd Android-sandbox
```

### 2. Run Automated Setup
The unified orchestrator CLI automatically mounts BinderFS, auto-detects GPU render nodes, installs dependencies, downloads system images, and configures ARM translation:
```bash
./bin/asandbox setup
```

### 3. Start the Sandbox & Launch the UI
```bash
# Start background container and session
./bin/asandbox start

# Open the full Android tablet launcher UI
./bin/asandbox ui
```

---

## 📦 Managing Applications

### Installing Aurora Store (Google Play Store Frontend)
On Vanilla / microG builds, Aurora Store provides direct, anonymous access to the entire Google Play Store catalog without proprietary Google bloat:
```bash
./bin/asandbox install-store
```
Open **Aurora Store** inside the Android UI, select **Anonymous**, and download apps like YouTube, Netflix, Clash of Clans, Spotify, etc.

### Sideloading APKs
You can install any downloaded `.apk` directly from your host terminal:
```bash
./bin/asandbox app install /path/to/application.apk
```

### Launching Apps as Native Desktop Windows
In seamless multi-window mode, Android apps run as independent floating desktop windows:
```bash
# List installed packages
./bin/asandbox app list

# Launch an app directly onto your Linux desktop
./bin/asandbox app launch com.aurora.store
```

---

## 🛠️ Unified CLI Reference (`bin/asandbox`)

| Command | Description |
| :--- | :--- |
| `./bin/asandbox status` | Inspect status of BinderFS, GPU node, and Waydroid container |
| `./bin/asandbox setup` | Full end-to-end automated installation |
| `./bin/asandbox start` | Safely mount BinderFS and start Waydroid container session |
| `./bin/asandbox stop` | Stop Waydroid session and container daemon |
| `./bin/asandbox ui` | Launch full-screen or windowed Android launcher |
| `./bin/asandbox app install <apk>` | Install an APK into the container |
| `./bin/asandbox app launch <pkg>` | Launch an Android app as an independent desktop window |
| `./bin/asandbox install-store` | Download and install Aurora Store |
| `./bin/asandbox fix-network` | Repair internet forwarding and DNS routing |
| `./bin/asandbox spoof <file.prop>` | Inject retail device fingerprint (e.g. Pixel 7) |
| `./bin/asandbox sensors` | Re-inject realistic battery (85% discharging) and LTE carrier |
| `./bin/asandbox disposable start` | Launch an isolated disposable ReDroid container via Docker |
| `./bin/asandbox disposable reset` | Wipe disposable container data back to pristine state |
| `./bin/asandbox shared` | Open host-container shared folder (`/sdcard/HostShared`) |

---

## 🔧 Troubleshooting & Known Solutions

### 1. `[gbinder] ERROR: Can't open /dev/binder: Permission denied`
**Cause:** `/dev/binderfs` was mounted with root-only traversal permissions (missing `+x` bit).
**Fix:**
```bash
sudo chmod 0755 /dev/binderfs /dev/binderfs/features 2>/dev/null || true
sudo chmod 0666 /dev/binderfs/binder /dev/binderfs/hwbinder /dev/binderfs/vndbinder /dev/binder /dev/hwbinder /dev/vndbinder 2>/dev/null || true
./scripts/setup-service-override.sh
```

### 2. No Internet Access Inside Android
**Cause:** Host kernel has IPv4 packet forwarding disabled (`net.ipv4.ip_forward = 0`), or host firewall (`firewalld`/`ufw`) blocks the `waydroid0` virtual bridge.
**Fix:**
```bash
./bin/asandbox fix-network
```
*(Note: Inside Android Settings, the Wi-Fi icon will always show as "Off/Disconnected". This is normal; Waydroid routes traffic through a virtual Ethernet adapter `eth0` under the hood).*

### 3. Netflix Sign-in Loop (Redirects back to "Get Started")
**Cause:** The Netflix app relies on an embedded WebView / Chrome Custom Tab for login redirects, and checks device attestation.
**Fix:**
1. Open Aurora Store inside the sandbox and install **Google Chrome** or update **Android System WebView**.
2. Go to Android **Settings > Apps > Netflix > Storage & cache** and tap **Clear Storage**.
3. Re-open Netflix and sign in.
4. *(Alternative)*: For 1080p Full HD playback, use desktop Firefox/Chrome directly on Linux, as containerized Android is limited to Widevine L3 (SD 480p-540p).

---

## 🧹 Complete Uninstallation & Storage Cleanup

If you ever wish to completely remove Waydroid and all Android images to reclaim 100% of your disk space:

```bash
# 1. Stop all Waydroid sessions and services
waydroid session stop 2>/dev/null || true
sudo systemctl stop waydroid-container 2>/dev/null || true
sudo systemctl disable waydroid-container 2>/dev/null || true

# 2. Remove Waydroid packages
sudo pacman -Rns waydroid lxc  # On Arch / Garuda
# Or on Ubuntu/Debian: sudo apt purge waydroid lxc

# 3. Delete all container images, rootfs, overlays, and user data (frees ~3-5 GB)
sudo rm -rf /var/lib/waydroid
sudo rm -rf /var/log/waydroid.log
rm -rf ~/.local/share/waydroid
rm -rf ~/.cache/waydroid-script
rm -rf ~/.local/share/applications/*waydroid*

# 4. Remove systemd service overrides and udev rules
sudo rm -rf /etc/systemd/system/waydroid-container.service.d
sudo rm -f /etc/udev/rules.d/99-android-binder.rules
sudo systemctl daemon-reload
```

---

## 📄 License
MIT License. Open-source and free for all developers.
