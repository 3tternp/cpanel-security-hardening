# 🛡️ cPanel Security Hardening Toolkit

A security assessment and baseline hardening toolkit for **cPanel & WHM servers**.

The toolkit helps system administrators, security engineers, auditors, and hosting administrators review common security controls, identify potentially insecure configurations, and apply selected baseline hardening measures.

> ⚠️ **Important:** This toolkit is intended only for systems you own or are explicitly authorized to administer.

---

## 📌 Overview

cPanel/WHM servers expose several administrative, web, mail, database, and remote-access services. Misconfigured services, outdated packages, weak SSH configurations, unnecessary exposed ports, or insufficient brute-force protection can increase the attack surface of a hosting server.

This toolkit provides two approaches:

### 🔍 Security Assessment

Review the current server security posture without intentionally modifying the configuration.

### 🔐 Baseline Hardening

Apply selected security controls while deliberately avoiding high-risk automatic changes that could lock administrators out of the server.

The recommended approach is:

```text
🔍 Audit
   ↓
📋 Review Findings
   ↓
💾 Snapshot / Backup
   ↓
🔐 Apply Hardening
   ↓
🔄 Re-Audit
   ↓
✅ Verify Services
   ↓
📊 Continuous Monitoring
```

---

# ✨ Features

The toolkit can assist with reviewing or hardening the following areas:

- 🖥️ Operating system and kernel information
- ⚙️ cPanel/WHM version information
- 🔄 cPanel update configuration
- 🛡️ cPHulk brute-force protection
- 🔑 SSH security configuration
- 🔥 Firewall status
- 🌐 Listening network ports
- 🧱 ModSecurity status
- 🛡️ OWASP ModSecurity Core Rule Set
- 💾 cPanel backup configuration
- 👤 Privileged and UID 0 accounts
- 🔐 Interactive login accounts
- 🧑‍💻 Compiler availability
- 📁 Temporary directory security
- 🗄️ MySQL network exposure
- 🐘 Installed PHP versions
- 🔓 World-writable files
- ⚠️ SUID/SGID binaries
- 📜 Recent authentication activity
- ⏰ Cron jobs
- ⚙️ Running services
- 🔒 WHM TLS certificate information
- 💽 Disk and inode utilization
- 📦 Available package/security updates
- 🛡️ SELinux status

---

# 📂 Repository Structure

```text
cpanel-security-hardening/
│
├── 📄 README.md
├── 📄 LICENSE
│
├── scripts/
│   ├── 🔍 cpanel-audit.sh
│   ├── 🔐 cpanel-harden.sh
│   └── 🔄 cpanel-rollback.sh
│
├── config/
│   └── ⚙️ hardening.conf
│
└── docs/
    └── 📋 terminal-checks.txt
```

---

# 📑 File Description

### 🔍 `scripts/cpanel-audit.sh`

Performs a security-oriented assessment of the cPanel/WHM server.

The script reviews areas such as:

- Operating system information
- cPanel version
- Update configuration
- cPHulk status
- SSH configuration
- Firewall status
- Listening ports
- ModSecurity
- OWASP CRS
- Backup configuration
- Privileged accounts
- MySQL exposure
- PHP versions
- Recent authentication activity

The audit script is intended primarily for **information gathering and security assessment**.

---

### 🔐 `scripts/cpanel-harden.sh`

Applies selected baseline hardening controls.

The script is intentionally conservative and does **not** automatically make certain high-risk changes.

It may configure controls such as:

- cPanel update policy
- Security update frequency
- cPHulk activation
- Selected safe baseline configuration

High-impact configuration changes are intentionally left for manual administrator review.

---

### 🔄 `scripts/cpanel-rollback.sh`

Provides a basic rollback mechanism for configuration files backed up before hardening.

Example:

```bash
sudo ./scripts/cpanel-rollback.sh \
/root/cpanel-hardening-backup-YYYYMMDD_HHMMSS
```

Always verify the backup directory before initiating rollback.

---

### ⚙️ `config/hardening.conf`

Contains reference hardening settings.

Example:

```bash
ENABLE_CPHULK=true
ENABLE_OWASP_CRS=true
RESTRICT_COMPILERS=true

SSH_MAX_AUTH_TRIES=4
SSH_LOGIN_GRACE_TIME=60
SSH_DISABLE_X11=true

DISABLE_ROOT_SSH=false
DISABLE_PASSWORD_AUTH=false
MANAGE_FIREWALL=false
```

High-risk settings are disabled by default.

---

### 📋 `docs/terminal-checks.txt`

Contains individual terminal commands for administrators who:

- Cannot create files
- Cannot execute custom scripts
- Have restricted SSH access
- Are operating through cPanel Terminal
- Are using JailShell
- Only need to perform manual security verification

Commands can be copied and executed **one at a time**.

---

# 🚀 Installation

Clone the repository:

```bash
git clone <repository-url>
```

Enter the directory:

```bash
cd cpanel-security-hardening
```

Review the repository before executing anything:

```bash
ls -lah
```

Review the scripts:

```bash
less scripts/cpanel-audit.sh
```

```bash
less scripts/cpanel-harden.sh
```

```bash
less scripts/cpanel-rollback.sh
```

---

# 🔍 Usage — Security Audit

Make the audit script executable:

```bash
chmod +x scripts/cpanel-audit.sh
```

Run it:

```bash
sudo ./scripts/cpanel-audit.sh
```

If already logged in as `root`:

```bash
./scripts/cpanel-audit.sh
```

Review all findings carefully before making configuration changes.

---

# 🔐 Usage — Apply Baseline Hardening

## ⚠️ Before Hardening

Before executing the hardening script:

1. 💾 Take a VM/server snapshot.
2. 📦 Verify that recent backups exist.
3. 🖥️ Confirm console or out-of-band access.
4. 🔑 Verify administrative SSH access.
5. 📋 Run the audit first.
6. 👀 Review the hardening script.
7. 🧪 Test changes in staging where possible.
8. 📢 Follow your organization's change-management procedure.

Make the script executable:

```bash
chmod +x scripts/cpanel-harden.sh
```

Execute:

```bash
sudo ./scripts/cpanel-harden.sh
```

Do **not** close your existing SSH session until you have confirmed that a second administrative session can connect successfully.

---

# 🔄 Re-Audit After Hardening

After applying the baseline, run:

```bash
sudo ./scripts/cpanel-audit.sh
```

Compare the results with the previous assessment.

Verify that critical services are still functioning correctly.

Examples include:

```bash
systemctl status sshd
```

```bash
systemctl status firewalld
```

```bash
/usr/local/cpanel/scripts/restartsrv_cpsrvd --check
```

```bash
/usr/local/cpanel/scripts/restartsrv_httpd --check
```

```bash
/usr/local/cpanel/scripts/restartsrv_exim --check
```

```bash
/usr/local/cpanel/scripts/restartsrv_mysql --check
```

---

# 🖥️ Restricted Terminal / JailShell Usage

If you do not have permission to create files or execute scripts, use:

```text
docs/terminal-checks.txt
```

The commands can be executed individually.

For example:

### Check kernel

```bash
uname -r
```

### Check operating system

```bash
cat /etc/os-release
```

Alternative commands for restricted environments:

```bash
cat /etc/redhat-release
```

```bash
cat /etc/cloudlinux-release
```

### Check cPanel version

```bash
/usr/local/cpanel/cpanel -V
```

### Check listening ports

```bash
ss -lntup
```

### Check SSH configuration

```bash
sshd -T | grep -E \
'permitrootlogin|passwordauthentication|pubkeyauthentication|permitemptypasswords|maxauthtries|x11forwarding'
```

### Check ModSecurity

```bash
/usr/local/apache/bin/httpd -M 2>/dev/null | grep -i security
```

### Check OWASP CRS

```bash
rpm -q ea-modsec2-rules-owasp-crs
```

### Check privileged accounts

```bash
awk -F: '$3 == 0 {print $1,$3,$6,$7}' /etc/passwd
```

> ℹ️ In a restricted cPanel/JailShell environment, some commands may return **Permission denied**, **Command not found**, or **No such file or directory**. This does not automatically indicate a security problem. Record the control as **Not Assessable with Current Privileges** and verify it using root/WHM access.

---

# 🔥 Firewall Safety

The toolkit intentionally avoids automatically changing firewall rules.

cPanel servers may require several ports depending on enabled services, including:

```text
22      SSH
25      SMTP
53      DNS
80      HTTP
443     HTTPS
465     SMTPS
587     SMTP Submission
993     IMAPS
995     POP3S
2083    cPanel SSL
2087    WHM SSL
2096    Webmail SSL
```

Additional services may require additional ports.

Never apply a generic firewall policy without first identifying which services are required.

---

# 🔑 SSH Safety

The toolkit intentionally does **not** automatically enforce:

```text
PermitRootLogin no
PasswordAuthentication no
```

These are strong security controls but can cause administrative lockout.

Before disabling password authentication:

1. Configure SSH public-key authentication.
2. Test the key from another terminal.
3. Verify an administrative account can use `sudo`.
4. Keep the existing SSH session open.
5. Ensure console/out-of-band access is available.

Validate SSH configuration before restarting or reloading SSH:

```bash
sshd -t
```

A typical hardened target may include:

```text
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
PermitEmptyPasswords no
MaxAuthTries 4
X11Forwarding no
```

Apply these controls only after validating the environment.

---

# 🗄️ Database Exposure

Check whether MySQL/MariaDB is listening on TCP port `3306`:

```bash
ss -lntp | grep ':3306'
```

Pay particular attention to listeners such as:

```text
0.0.0.0:3306
```

or:

```text
[::]:3306
```

These indicate broad interface binding.

This does **not necessarily mean the database is publicly reachable**, because firewall and upstream network controls may still restrict access.

Review firewall rules and MySQL/MariaDB configuration before making changes.

---

# 🧱 Web Application Security

For public hosting environments, consider enabling and maintaining:

- ModSecurity
- OWASP ModSecurity CRS
- HTTPS/TLS
- Supported PHP versions
- Secure application permissions
- Regular CMS/plugin updates
- Malware scanning
- File integrity monitoring
- Application and access logging

Check ModSecurity:

```bash
/usr/local/apache/bin/httpd -M | grep -i security
```

Check OWASP CRS:

```bash
rpm -q ea-modsec2-rules-owasp-crs
```

---

# 📊 Suggested Assessment Status

When using the toolkit for an audit, classify controls as:

| Status | Meaning |
|---|---|
| ✅ **PASS** | Control is appropriately configured |
| ❌ **FAIL** | Control is missing or insecure |
| ⚠️ **WARNING** | Requires review or improvement |
| ℹ️ **INFO** | Informational observation |
| ➖ **N/A** | Control does not apply |
| 🔒 **NOT ASSESSABLE** | Current privileges do not permit verification |

This makes the output easier to use for security assessment and compliance reporting.

---

# 🛡️ Recommended Security Baseline

A well-maintained cPanel/WHM server should generally consider:

- ✅ Automatic security updates
- ✅ Supported operating system
- ✅ Supported cPanel/WHM version
- ✅ cPHulk enabled
- ✅ Firewall enabled
- ✅ Only required ports exposed
- ✅ SSH key authentication
- ✅ Restricted privileged access
- ✅ ModSecurity enabled where appropriate
- ✅ OWASP CRS or equivalent WAF rules
- ✅ Supported PHP versions
- ✅ Secure temporary directories
- ✅ Restricted database exposure
- ✅ Regular backups
- ✅ Off-server backup copies
- ✅ Authentication monitoring
- ✅ File integrity monitoring
- ✅ Centralized security logging
- ✅ Regular vulnerability assessment

---

# 📡 SIEM Monitoring Recommendations

For production cPanel servers, consider forwarding security-relevant logs to a SIEM.

Useful monitoring sources include:

- SSH authentication
- cPanel/WHM authentication
- cPHulk events
- Apache/Nginx access and error logs
- ModSecurity/WAF events
- Exim/mail security events
- MySQL/MariaDB audit events
- Privilege escalation
- User/account creation
- Cron modifications
- File integrity events
- Malware detections
- Firewall events
- Service failures

Potential detection use cases include:

```text
Multiple Failed SSH Authentication
Successful Login After Multiple Failures
cPanel/WHM Brute Force Attempt
Unauthorized Root Login
Suspicious Privilege Escalation
Unexpected Administrative Account Creation
ModSecurity Attack Detected
Suspicious Web Shell Activity
Unexpected Cron Job Creation
Critical Configuration File Modified
Malware Detected in Hosting Directory
Unusual Outbound Network Connection
Security Service Stopped
```

---

# ⚠️ Important Safety Notes

Never blindly execute hardening scripts against a production server.

Configuration changes involving the following require particular care:

- 🔥 Firewall rules
- 🔑 SSH authentication
- 👑 Root access
- 🌐 cPanel/WHM ports
- 🗄️ MySQL/MariaDB networking
- 📧 Mail services
- 🌍 DNS services
- 🧱 Apache/Nginx configuration
- 🛡️ ModSecurity rules
- 📁 File permissions

A configuration that is secure for one hosting environment may break another.

---

# 🔒 Authorization

Use this toolkit only on:

- Systems you own
- Systems you administer
- Systems for which you have explicit authorization to perform security assessment or hardening

Do not use the toolkit to access, modify, assess, or interfere with systems without authorization.

---

# 🤝 Contributing

Contributions are welcome.

Useful contributions may include:

- Additional read-only security checks
- CloudLinux-specific checks
- cPanel-specific security checks
- Improved PASS/FAIL classification
- JSON/CSV report generation
- CIS-aligned checks
- Backup validation
- Malware detection checks
- SIEM integration examples
- Documentation improvements

Before submitting changes, ensure that new hardening actions do not introduce unnecessary service-disruption or administrator-lockout risks.

---

# 📜 License

This project is distributed under the **MIT License**.

See:

```text
LICENSE
```

for details.

---

## ⭐ Final Note

Security hardening is not a one-time activity.

A secure cPanel environment requires continuous:

```text
Patch → Monitor → Audit → Harden → Verify → Repeat
```

Use this toolkit as a starting point for a broader server security, vulnerability-management, and monitoring program.
