#!/bin/bash
# ==============================================================================
# Script Name:  security_audit.sh
# Description:  Automated System & Network Security Compliance Audit
# Author:       Your Name
# Target OS:    RHEL / CentOS / Ubuntu Linux
# ==============================================================================

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "[-] ERROR: This script must be run as root/sudo to audit system files."
  exit 1
fi

LOG_FILE="/var/log/system_security_audit.log"
echo "==================================================================" > "$LOG_FILE"
echo " SYSTEM & NETWORK SECURITY COMPLIANCE REPORT " >> "$LOG_FILE"
echo " Generated on: $(date)" >> "$LOG_FILE"
echo "==================================================================" >> "$LOG_FILE"

echo "[*] Starting security audit. Output target: $LOG_FILE"

# 1. AUDIT: SSH Configuration Security
echo -e "\n[1] AUDITING SSH SERVICE CONFIGURATION..." >> "$LOG_FILE"
SSH_CONFIG="/etc/ssh/sshd_config"

if [ -f "$SSH_CONFIG" ]; then
    # Check for Root Login status
    ROOT_LOGIN=$(grep -i "^PermitRootLogin" "$SSH_CONFIG" || echo "PermitRootLogin not explicitly set")
    echo "    -> SSH Root Login Status: $ROOT_LOGIN" >> "$LOG_FILE"
    
    # Check Password Authentication status
    PASSWORD_AUTH=$(grep -i "^PasswordAuthentication" "$SSH_CONFIG" || echo "PasswordAuthentication not explicitly set")
    echo "    -> SSH Password Auth Status: $PASSWORD_AUTH" >> "$LOG_FILE"
else
    echo "    [-] WARNING: SSH configuration file not found at standard path." >> "$LOG_FILE"
fi

# 2. AUDIT: Network Ports & Listening Services
echo -e "\n[2] AUDITING NETWORK NETWORK PERIMETER (LISTENING PORTS)..." >> "$LOG_FILE"
if command -v ss &> /dev/null; then
    echo "    -> Active Listening TCP/UDP Ports:" >> "$LOG_FILE"
    ss -tuln | grep LISTEN >> "$LOG_FILE"
else
    echo "    [-] ERROR: 'ss' command utility not found." >> "$LOG_FILE"
fi

# 3. AUDIT: User Accounts with Empty Passwords
echo -e "\n[3] AUDITING USER ACCOUNT CREDENTIAL INTEGRITY..." >> "$LOG_FILE"
EMPTY_ACCOUNTS=$(awk -F: '($2 == "") {print $1}' /etc/shadow)

if [ -z "$EMPTY_ACCOUNTS" ]; then
    echo "    [+] SUCCESS: No user accounts found with empty passwords." >> "$LOG_FILE"
else
    echo "    [!] CRITICAL: The following accounts have NO PASSWORD set:" >> "$LOG_FILE"
    echo "$EMPTY_ACCOUNTS" >> "$LOG_FILE"
fi

# 4. AUDIT: World-Writable Files (Potential Privilege Escalation Vectors)
echo -e "\n[4] SYSTEM INTEGRITY: SCANNING FOR WORLD-WRITABLE FILES..." >> "$LOG_FILE"
echo "    -> Reviewing critical directory pathways (/etc, /bin, /sbin)..." >> "$LOG_FILE"
find /etc /bin /sbin -xdev -type f -perm -0002 >> "$LOG_FILE" 2>/dev/null
echo "    [+] Sub-directory scan completed." >> "$LOG_FILE"

echo -e "\n==================================================================" >> "$LOG_FILE"
echo " AUDIT COMPLETE. Please review logs above for hardening remediation. " >> "$LOG_FILE"
echo "==================================================================" >> "$LOG_FILE"

echo "[+] Audit finished successfully. View report using: cat $LOG_FILE"
