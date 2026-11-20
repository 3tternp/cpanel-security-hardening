# cPanel Security Hardening Toolkit

For authorized cPanel/WHM security assessment and baseline hardening.

## Files
- `scripts/cpanel-audit.sh` - assessment script
- `scripts/cpanel-harden.sh` - conservative baseline hardening
- `scripts/cpanel-rollback.sh` - rollback helper
- `config/hardening.conf` - reference settings
- `docs/terminal-checks.txt` - one-by-one commands for restricted/JailShell access

## Recommended workflow
Audit -> Review -> Snapshot/Backup -> Harden -> Re-audit -> Verify

The hardening script intentionally does not automatically alter firewall rules,
disable root/password SSH access, or change MySQL bind settings, because these
can cause lockout or service disruption.

Use only on systems you are authorized to administer.
