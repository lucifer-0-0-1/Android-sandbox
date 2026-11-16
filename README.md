# Native Android Sandbox on Linux

A lightweight, containerized native Android runtime environment for Linux (Garuda/Arch). Runs Android applications natively using Linux kernel namespaces, BinderFS, and Intel Mesa DRI GPU passthrough—consuming under **500 MB RAM** with near-zero virtualization overhead (replacing heavy 4–8 GB BlueStacks VMs).

---

## Architecture Overview

1. **Waydroid Core Engine**:
   - Runs AOSP/LineageOS 20 natively inside an unprivileged LXC container.
   - Direct Wayland compositor integration: apps float as individual desktop windows or inside a full tablet frame.
   - Direct audio routing through host PipeWire.
   - Hardware acceleration via Mesa Iris driver mapped to Intel Alder Lake UHD (`/dev/dri/renderD129`) to prevent NVIDIA hybrid driver crashes.
2. **Compatibility & Chameleon Anti-Detection Stack**:
   - **Intel `libhoudini`**: Dynamic binary translation layer to run ARM64 (`arm64-v8a`) and ARM32 (`armeabi-v7a`) APKs (like Clash of Clans) on an x86_64 CPU.
   - **microG GmsCore**: Lightweight open-source Google Play Services with Google Account authentication.
   - **Widevine L3**: Software DRM module for streaming services (Netflix, etc.).
   - **Retail Device Fingerprint**: Spoofed Google Pixel 7 (`panther`) build properties to disguise the container as a genuine smartphone.
   - **Hardware Stubs**: Fake battery discharging state (85%) and LTE carrier state to defeat emulator detection routines.
3. **ReDroid Disposable Engine (Docker)**:
   - On-demand, disposable Android sandboxes for testing untrusted APKs or running multi-instance tasks with low-latency `scrcpy` display mirroring.

---

## Quick Start

### 1. Verification & Status
Inspect the current status of all sandbox subsystems:
```bash
./bin/asandbox status
```

### 2. Full Setup
Run the end-to-end automated installation (mounts binderfs, configures GPU, installs packages, downloads Vanilla Android image, injects libhoudini/microG/Widevine, and configures device spoofing):
```bash
./bin/asandbox setup
```

### 3. Running Android Apps
Start the Waydroid session and launch the UI:
```bash
# Start background container & session
./bin/asandbox start

# Open full tablet/phone launcher UI
./bin/asandbox ui
```

### 4. Installing and Launching Apps
```bash
# Install an APK (e.g. Clash of Clans, YouTube ReVanced, Aurora Store)
./bin/asandbox app install /path/to/app.apk

# Launch any installed app as a floating desktop window
./bin/asandbox app launch com.supercell.clashofclans
```

### 5. Disposable Sandbox (for untrusted APKs)
```bash
# Spin up an isolated Docker container mirrored via scrcpy
./bin/asandbox disposable start

# Reset/wipe sandbox back to clean state
./bin/asandbox disposable reset
```

---

## Directory Structure
- `bin/asandbox`: Unified CLI orchestrator.
- `config/gpu.conf`: Auto-detected GPU render node configuration.
- `config/device-profiles/`: Certified retail device fingerprint profiles (Pixel 7).
- `config/waydroid-keymapper.json`: Keyboard/mouse touch mapping configurations for gaming.
- `docker/`: ReDroid container definitions.
- `scripts/`: Modular setup and lifecycle scripts.
- `scripts/tests/`: Automated TDD verification tests for all components.
- `docs/plans/`: Comprehensive implementation plan and architectural documentation.
