#!/usr/bin/env bash
set -euo pipefail
[[ $EUID -ne 0 ]] && { echo "ERROR: root required"; exit 1; }
DATE=$(date +%Y%m%d_%H%M%S); BACKUP="/root/cpanel-hardening-backup-$DATE"; mkdir -p "$BACKUP"
cp -a /etc/cpupdate.conf "$BACKUP/" 2>/dev/null || true
cp -a /etc/ssh/sshd_config "$BACKUP/" 2>/dev/null || true
setval(){ grep -q "^$1=" /etc/cpupdate.conf && sed -i "s/^$1=.*/$1=$2/" /etc/cpupdate.conf || echo "$1=$2" >> /etc/cpupdate.conf; }
setval RPMUP daily; setval UPDATES daily; setval SARULESUP daily; setval SECURITY_UPDATES hourly
command -v whmapi1 >/dev/null && whmapi1 enable_cphulk >/dev/null || true
echo "Baseline applied. Firewall, PermitRootLogin, PasswordAuthentication and MySQL bind address were intentionally NOT changed."
echo "Backup: $BACKUP"
