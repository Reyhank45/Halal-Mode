#!/system/bin/sh
# Halal Mode - Add Domain Blocking Script
# Resolves domains and adds iptables rules or hosts entries to block them
# Usage: add_block.sh [flags] <domain1> [domain2] ...
# Flags:
#   --ip, --fw      Add iptables rules (firewall)
#   --hosts         Add hosts file entries
#   --all           Add both (default if no flags specified)
#   -h, --help      Show this help message

if [ -z "$1" ]; then
    echo "Usage: $0 [flags] <domain1> [domain2] ..."
    echo "Try '$0 --help' for more information."
    exit 1
fi

SCRIPT_DIR=$(dirname "$0")
COMMON_DIR=$(dirname "$SCRIPT_DIR")
MODDIR=$(dirname "$COMMON_DIR")

SERVICE_SH="$COMMON_DIR/service.sh"
HOSTS_FILE="$MODDIR/system/etc/hosts"

# Default flags
BLOCK_IP=false
BLOCK_HOSTS=false
DEFAULT_BEHAVIOR=true

# Function: Show Help
show_help() {
    echo "Halal Mode - Add Block Script"
    echo "Usage: $0 [flags] <domain1> [domain2] ..."
    echo ""
    echo "Flags:"
    echo "  --ip, --fw    Add iptables rules (firewall)"
    echo "  --hosts       Add hosts file entries"
    echo "  --all         Add both (default)"
    echo "  -h, --help    Show this help message"
    echo ""
    echo "Example: $0 --ip instagram.com"
}

# Parse arguments
DOMAINS=""
for arg in "$@"; do
    case "$arg" in
        --ip|--fw)
            BLOCK_IP=true
            DEFAULT_BEHAVIOR=false
            ;;
        --hosts)
            BLOCK_HOSTS=true
            DEFAULT_BEHAVIOR=false
            ;;
        --all)
            BLOCK_IP=true
            BLOCK_HOSTS=true
            DEFAULT_BEHAVIOR=false
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo "Unknown flag: $arg"
            show_help
            exit 1
            ;;
        *)
            DOMAINS="$DOMAINS $arg"
            ;;
    esac
done

if [ -z "$DOMAINS" ]; then
    show_help
    exit 1
fi

# Apply default behavior if no flags were set
if [ "$DEFAULT_BEHAVIOR" = true ]; then
    BLOCK_IP=true
    BLOCK_HOSTS=true
fi

# Ensure service.sh exists
if [ ! -f "$SERVICE_SH" ]; then
    echo "Error: service.sh not found at $SERVICE_SH"
    exit 1
fi

for domain in $DOMAINS; do
    echo "--- Processing: $domain ---"

    # Check if input is an IP address
    if echo "$domain" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'; then
        IS_IP=true
    else
        IS_IP=false
    fi

    # 1. Hosts Blocking
    if [ "$BLOCK_HOSTS" = true ]; then
        if [ "$IS_IP" = true ]; then
            echo "Skipping hosts entry for static IP: $domain"
        else
            ENTRY="127.0.0.1 $domain"
            WWW_ENTRY="127.0.0.1 www.$domain"
            
            echo "Adding hosts entries for $domain"
            
            # Add to module's persistent hosts file if it exists
            if [ -f "$HOSTS_FILE" ]; then
                if ! grep -Fq " $domain" "$HOSTS_FILE"; then
                    echo "$ENTRY" >> "$HOSTS_FILE"
                    echo "Added $domain to persistent hosts file"
                fi
                if ! grep -Fq " www.$domain" "$HOSTS_FILE"; then
                    echo "$WWW_ENTRY" >> "$HOSTS_FILE"
                    echo "Added www.$domain to persistent hosts file"
                fi
            fi
            
            # Apply immediately to active /system/etc/hosts
            if ! grep -Fq " $domain" "/system/etc/hosts" 2>/dev/null; then
                echo "$ENTRY" >> "/system/etc/hosts" 2>/dev/null || echo "Note: Could not write to /system/etc/hosts directly (expected if not remounted)"
            fi
            if ! grep -Fq " www.$domain" "/system/etc/hosts" 2>/dev/null; then
                echo "$WWW_ENTRY" >> "/system/etc/hosts" 2>/dev/null
            fi
        fi
    fi

    # 2. Firewall Blocking (IP Resolution)
    if [ "$BLOCK_IP" = true ]; then
        if [ "$IS_IP" = true ]; then
            ips="$domain"
        else
            echo "Resolving domain for iptables: $domain"
            ips=$(nslookup "$domain" | grep 'Address' | grep -v '0.0.0.0' | awk '{print $NF}' | grep -E '^[0-9.]+$')
        fi
        
        if [ -z "$ips" ]; then
            echo "Could not resolve domain: $domain"
        else
            for ip in $ips; do
                # Apply rules across multiple chains for comprehensive blocking
                for chain_spec in "OUTPUT:-d" "INPUT:-s" "FORWARD:-d" "FORWARD:-s"; do
                    chain=${chain_spec%:*}
                    flag=${chain_spec#*:}
                    RULE="iptables -A $chain $flag $ip -j REJECT # Block $domain"
                    
                    if grep -Fq "$RULE" "$SERVICE_SH"; then
                        echo "Rule for $ip ($chain) already exists in service.sh"
                    else
                        echo "Adding persistent rule for $ip ($chain) to service.sh"
                        sed -i "/# --- Persistent Rules End ---/i $RULE" "$SERVICE_SH"
                    fi

                    if ! iptables -C $chain $flag "$ip" -j REJECT 2>/dev/null; then
                        echo "Applying iptables rule for $ip ($chain)"
                        iptables -A $chain $flag "$ip" -j REJECT 2>/dev/null || echo "Note: iptables $chain command failed (expected if not root)"
                    fi
                done
            done
        fi
    fi
done

