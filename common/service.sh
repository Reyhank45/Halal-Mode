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
iptables -A OUTPUT -d 66.29.129.161 -j REJECT # Block 66.29.129.161
iptables -A INPUT -s 66.29.129.161 -j REJECT # Block 66.29.129.161
iptables -A FORWARD -d 66.29.129.161 -j REJECT # Block 66.29.129.161
iptables -A OUTPUT -d 51.83.180.8 -j REJECT # Block 51.83.180.8
iptables -A INPUT -s 51.83.180.8 -j REJECT # Block 51.83.180.8
iptables -A FORWARD -d 51.83.180.8 -j REJECT # Block 51.83.180.8
iptables -A FORWARD -s 51.83.180.8 -j REJECT # Block 51.83.180.8
iptables -A FORWARD -s 66.29.129.161 -j REJECT # Block 66.29.129.161
iptables -A OUTPUT -d 168.68.124.125 -j REJECT # Block 168.68.124.125
iptables -A INPUT -s 168.68.124.125 -j REJECT # Block 168.68.124.125
iptables -A FORWARD -d 168.68.124.125 -j REJECT # Block 168.68.124.125
iptables -A FORWARD -s 168.68.124.125 -j REJECT # Block 168.68.124.125
iptables -A OUTPUT -d 164.68.106.43 -j REJECT # Block 164.68.106.43
iptables -A INPUT -s 164.68.106.43 -j REJECT # Block 164.68.106.43
iptables -A FORWARD -d 164.68.106.43 -j REJECT # Block 164.68.106.43
iptables -A FORWARD -s 164.68.106.43 -j REJECT # Block 164.68.106.43
iptables -A OUTPUT -d 152.42.253.112 -j REJECT # Block 152.42.253.112
iptables -A INPUT -s 152.42.253.112 -j REJECT # Block 152.42.253.112
iptables -A FORWARD -d 152.42.253.112 -j REJECT # Block 152.42.253.112
iptables -A FORWARD -s 152.42.253.112 -j REJECT # Block 152.42.253.112
iptables -A OUTPUT -d 75.119.140.110 -j REJECT # Block 75.119.140.110
iptables -A INPUT -s 75.119.140.110 -j REJECT # Block 75.119.140.110
iptables -A FORWARD -d 75.119.140.110 -j REJECT # Block 75.119.140.110
iptables -A FORWARD -s 75.119.140.110 -j REJECT # Block 75.119.140.110
iptables -A OUTPUT -d 185.209.228.214 -j REJECT # Block 185.209.228.214
iptables -A INPUT -s 185.209.228.214 -j REJECT # Block 185.209.228.214
iptables -A FORWARD -d 185.209.228.214 -j REJECT # Block 185.209.228.214
iptables -A FORWARD -s 185.209.228.214 -j REJECT # Block 185.209.228.214
iptables -A OUTPUT -d 161.97.169.170 -j REJECT # Block 161.97.169.170
iptables -A INPUT -s 161.97.169.170 -j REJECT # Block 161.97.169.170
iptables -A FORWARD -d 161.97.169.170 -j REJECT # Block 161.97.169.170
iptables -A FORWARD -s 161.97.169.170 -j REJECT # Block 161.97.169.170
iptables -A OUTPUT -d 164.68.124.125 -j REJECT # Block 164.68.124.125
iptables -A INPUT -s 164.68.124.125 -j REJECT # Block 164.68.124.125
iptables -A FORWARD -d 164.68.124.125 -j REJECT # Block 164.68.124.125
iptables -A FORWARD -s 164.68.124.125 -j REJECT # Block 164.68.124.125
iptables -A OUTPUT -d 149.102.141.62 -j REJECT # Block 149.102.141.62
iptables -A INPUT -s 149.102.141.62 -j REJECT # Block 149.102.141.62
iptables -A FORWARD -d 149.102.141.62 -j REJECT # Block 149.102.141.62
iptables -A FORWARD -s 149.102.141.62 -j REJECT # Block 149.102.141.62
iptables -A OUTPUT -d 91.209.70.164 -j REJECT # Block 91.209.70.164
iptables -A INPUT -s 91.209.70.164 -j REJECT # Block 91.209.70.164
iptables -A FORWARD -d 91.209.70.164 -j REJECT # Block 91.209.70.164
iptables -A FORWARD -s 91.209.70.164 -j REJECT # Block 91.209.70.164
iptables -A OUTPUT -d 194.233.78.131 -j REJECT # Block 194.233.78.131
iptables -A INPUT -s 194.233.78.131 -j REJECT # Block 194.233.78.131
iptables -A FORWARD -d 194.233.78.131 -j REJECT # Block 194.233.78.131
iptables -A FORWARD -s 194.233.78.131 -j REJECT # Block 194.233.78.131
iptables -A OUTPUT -d 213.199.60.147 -j REJECT # Block 213.199.60.147
iptables -A INPUT -s 213.199.60.147 -j REJECT # Block 213.199.60.147
iptables -A FORWARD -d 213.199.60.147 -j REJECT # Block 213.199.60.147
iptables -A FORWARD -s 213.199.60.147 -j REJECT # Block 213.199.60.147
# --- Persistent iptables Rules End ---