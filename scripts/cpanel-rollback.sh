#!/usr/bin/env bash
set -euo pipefail
B="${1:-}"; [[ $EUID -ne 0 || -z "$B" || ! -d "$B" ]] && { echo "Usage as root: $0 /root/cpanel-hardening-backup-TIMESTAMP"; exit 1; }
[ -f "$B/cpupdate.conf" ] && cp -a "$B/cpupdate.conf" /etc/cpupdate.conf
[ -f "$B/sshd_config" ] && cp -a "$B/sshd_config" /etc/ssh/sshd_config
sshd -t 2>/dev/null && systemctl reload sshd 2>/dev/null || true
echo "Rollback completed."
