#!/usr/bin/env bash
# scripts/tests/test-binder.sh
set -euo pipefail

echo "[*] Checking BinderFS mount..."
if ! mountpoint -q /dev/binderfs; then
    echo "[-] FAIL: /dev/binderfs is not mounted!" >&2
    exit 1
fi

echo "[*] Checking Binder character devices..."
for dev in binder hwbinder vndbinder; do
    if [[ ! -c "/dev/binderfs/$dev" ]] && [[ ! -c "/dev/$dev" ]]; then
        echo "[-] FAIL: Binder device $dev not found!" >&2
        exit 1
    fi
done

echo "[+] PASS: Kernel BinderFS and IPC devices are active and available."
exit 0
