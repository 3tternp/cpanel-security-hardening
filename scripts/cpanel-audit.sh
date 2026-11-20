#!/usr/bin/env bash
set -uo pipefail
echo "=== SYSTEM ==="
uname -a
cat /etc/os-release 2>/dev/null || cat /etc/redhat-release 2>/dev/null || cat /etc/cloudlinux-release 2>/dev/null || true
/usr/local/cpanel/cpanel -V 2>/dev/null || true
echo "=== UPDATES ==="
cat /etc/cpupdate.conf 2>/dev/null || true
echo "=== CPHULK ==="
whmapi1 cphulk_status 2>/dev/null || true
echo "=== SSH ==="
sshd -T 2>/dev/null | grep -E 'permitrootlogin|passwordauthentication|pubkeyauthentication|permitemptypasswords|maxauthtries|logingracetime|x11forwarding' || true
echo "=== FIREWALL / PORTS ==="
systemctl is-active firewalld 2>/dev/null || true
command -v csf >/dev/null && csf -v || true
ss -lntup 2>/dev/null || true
echo "=== MODSECURITY / CRS ==="
/usr/local/apache/bin/httpd -M 2>/dev/null | grep -i security || true
rpm -q ea-modsec2-rules-owasp-crs 2>/dev/null || true
echo "=== BACKUPS ==="
grep -E '^(BACKUPENABLE|BACKUPTYPE|BACKUPRET|BACKUPACCTS|BACKUPDIR|BACKUPDAYS)' /var/cpanel/backups/config 2>/dev/null || true
echo "=== ACCOUNTS ==="
awk -F: '$3 == 0 {print $1,$3,$6,$7}' /etc/passwd 2>/dev/null
echo "=== MYSQL ==="
ss -lntp 2>/dev/null | grep ':3306' || true
echo "=== PHP ==="
for php in /opt/cpanel/ea-php*/root/usr/bin/php; do [ -x "$php" ] && "$php" -v | head -1; done
echo "=== RECENT LOGINS ==="
last -a 2>/dev/null | head -30 || true
