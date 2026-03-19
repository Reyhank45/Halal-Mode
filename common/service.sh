#!/system/bin/sh
# Halal Mode DNS & Firewall Protector - Service Script
# Runs at late_start service stage with root privileges

MODDIR=${0%/*}

# Wait for boot to complete to ensure iptables is ready
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 1
done

# Ensure helper scripts are executable
chmod +x "$MODDIR"/scripts/*.sh

# --- Persistent iptables Rules Start ---
# Add persistent firewall rules here (injected by add_block.sh)
# --- Persistent iptables Rules End ---