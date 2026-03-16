#!/system/bin/sh
# Halal-Mode Service Script

# Wait for boot to complete to ensure iptables is ready
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 5
done

MODDIR=${0%/*}

# --- Persistent Rules Start ---
# --- Persistent Rules End ---

# Ensure scripts are executable
chmod +x $MODDIR/scripts/add_block.sh