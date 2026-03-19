#!/system/bin/sh
# Halal Mode - Add Domain Blocking Script
# Resolves domains and adds iptables rules to block them
# Usage: add_block.sh <domain1> [domain2] ...
#
# This script will:
# 1. Resolve domain names to IP addresses
# 2. Add iptables REJECT rules for those IPs
# 3. Persist rules to service.sh for boot-time loading

if [ -z "$1" ]; then
    echo "Usage: $0 <domain1> [domain2] ..."
    exit 1
fi

SCRIPT_DIR=${0%/*}
COMMON_DIR=${SCRIPT_DIR%/*}
SERVICE_SH="$COMMON_DIR/service.sh"

if [ ! -f "$SERVICE_SH" ]; then
    echo "Error: service.sh not found at $SERVICE_SH"
    exit 1
fi

for domain in "$@"; do
    echo "Resolving domain: $domain"
    ips=$(nslookup "$domain" | grep 'Address' | grep -v '0.0.0.0' | awk '{print $NF}' | grep -E '^[0-9.]+$')
    
    if [ -z "$ips" ]; then
        echo "Could not resolve domain: $domain"
        continue
    fi

    for ip in $ips; do
        RULE="iptables -A OUTPUT -d $ip -j REJECT # Block $domain"
        
        # Check if rule already exists in service.sh
        if grep -Fq "$RULE" "$SERVICE_SH"; then
            echo "Rule for $ip ($domain) already exists in service.sh"
        else
            echo "Adding persistent rule for $ip ($domain) to service.sh"
            # Insert rule before the "Persistent Rules End" marker
            sed -i "/# --- Persistent Rules End ---/i $RULE" "$SERVICE_SH"
        fi

        # Apply rule immediately
        echo "Applying rule to current session for $ip"
        if ! iptables -C OUTPUT -d "$ip" -j REJECT 2>/dev/null; then
            iptables -A OUTPUT -d "$ip" -j REJECT
        fi
    done
done
