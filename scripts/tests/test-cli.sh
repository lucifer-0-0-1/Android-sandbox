#!/usr/bin/env bash
# scripts/tests/test-cli.sh
set -euo pipefail

CLI="bin/asandbox"
if [[ ! -x "$CLI" ]]; then
    echo "[-] FAIL: CLI binary $CLI is missing or not executable!" >&2
    exit 1
fi

output=$("$CLI" help)
if [[ "$output" != *"Android Sandbox CLI Manager"* ]]; then
    echo "[-] FAIL: CLI output does not match expected help banner!" >&2
    exit 1
fi

status_output=$("$CLI" status)
echo "[*] Status check output:"
echo "$status_output"

echo "[+] PASS: Unified CLI operational."
exit 0
