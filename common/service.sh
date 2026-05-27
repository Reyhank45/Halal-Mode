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
iptables -A OUTPUT -d 185.185.83.34 -j REJECT # Block 185.185.83.34
iptables -A INPUT -s 185.185.83.34 -j REJECT # Block 185.185.83.34
iptables -A FORWARD -d 185.185.83.34 -j REJECT # Block 185.185.83.34
iptables -A FORWARD -s 185.185.83.34 -j REJECT # Block 185.185.83.34
iptables -A OUTPUT -d 194.163.154.194 -j REJECT # Block 194.163.154.194
iptables -A INPUT -s 194.163.154.194 -j REJECT # Block 194.163.154.194
iptables -A FORWARD -d 194.163.154.194 -j REJECT # Block 194.163.154.194
iptables -A FORWARD -s 194.163.154.194 -j REJECT # Block 194.163.154.194
iptables -A OUTPUT -d 178.18.250.38 -j REJECT # Block 178.18.250.38
iptables -A INPUT -s 178.18.250.38 -j REJECT # Block 178.18.250.38
iptables -A FORWARD -d 178.18.250.38 -j REJECT # Block 178.18.250.38
iptables -A FORWARD -s 178.18.250.38 -j REJECT # Block 178.18.250.38
iptables -A OUTPUT -d 51.75.156.74 -j REJECT # Block 51.75.156.74
iptables -A INPUT -s 51.75.156.74 -j REJECT # Block 51.75.156.74
iptables -A FORWARD -d 51.75.156.74 -j REJECT # Block 51.75.156.74
iptables -A FORWARD -s 51.75.156.74 -j REJECT # Block 51.75.156.74
iptables -A OUTPUT -d 62.171.189.214 -j REJECT # Block 62.171.189.214
iptables -A INPUT -s 62.171.189.214 -j REJECT # Block 62.171.189.214
iptables -A FORWARD -d 62.171.189.214 -j REJECT # Block 62.171.189.214
iptables -A FORWARD -s 62.171.189.214 -j REJECT # Block 62.171.189.214
iptables -A OUTPUT -d 194.60.201.109 -j REJECT # Block 194.60.201.109
iptables -A INPUT -s 194.60.201.109 -j REJECT # Block 194.60.201.109
iptables -A FORWARD -d 194.60.201.109 -j REJECT # Block 194.60.201.109
iptables -A FORWARD -s 194.60.201.109 -j REJECT # Block 194.60.201.109
iptables -A OUTPUT -d 172.67.218.180 -j REJECT # Block 2026bokep.it.com
iptables -A INPUT -s 172.67.218.180 -j REJECT # Block 2026bokep.it.com
iptables -A FORWARD -d 172.67.218.180 -j REJECT # Block 2026bokep.it.com
iptables -A FORWARD -s 172.67.218.180 -j REJECT # Block 2026bokep.it.com
iptables -A OUTPUT -d 104.21.53.207 -j REJECT # Block 2026bokep.it.com
iptables -A INPUT -s 104.21.53.207 -j REJECT # Block 2026bokep.it.com
iptables -A FORWARD -d 104.21.53.207 -j REJECT # Block 2026bokep.it.com
iptables -A FORWARD -s 104.21.53.207 -j REJECT # Block 2026bokep.it.com
iptables -A OUTPUT -d 104.21.53.207 -j REJECT # Block www.2026bokep.it.com
iptables -A INPUT -s 104.21.53.207 -j REJECT # Block www.2026bokep.it.com
iptables -A FORWARD -d 104.21.53.207 -j REJECT # Block www.2026bokep.it.com
iptables -A FORWARD -s 104.21.53.207 -j REJECT # Block www.2026bokep.it.com
iptables -A OUTPUT -d 172.67.218.180 -j REJECT # Block www.2026bokep.it.com
iptables -A INPUT -s 172.67.218.180 -j REJECT # Block www.2026bokep.it.com
iptables -A FORWARD -d 172.67.218.180 -j REJECT # Block www.2026bokep.it.com
iptables -A FORWARD -s 172.67.218.180 -j REJECT # Block www.2026bokep.it.com
iptables -A OUTPUT -d 84.247.161.245 -j REJECT # Block 84.247.161.245
iptables -A INPUT -s 84.247.161.245 -j REJECT # Block 84.247.161.245
iptables -A FORWARD -d 84.247.161.245 -j REJECT # Block 84.247.161.245
iptables -A FORWARD -s 84.247.161.245 -j REJECT # Block 84.247.161.245
iptables -A OUTPUT -d 152.42.198.224 -j REJECT # Block 152.42.198.224
iptables -A INPUT -s 152.42.198.224 -j REJECT # Block 152.42.198.224
iptables -A FORWARD -d 152.42.198.224 -j REJECT # Block 152.42.198.224
iptables -A FORWARD -s 152.42.198.224 -j REJECT # Block 152.42.198.224
iptables -A OUTPUT -d 158.220.126.21 -j REJECT # Block 158.220.126.21
iptables -A INPUT -s 158.220.126.21 -j REJECT # Block 158.220.126.21
iptables -A FORWARD -d 158.220.126.21 -j REJECT # Block 158.220.126.21
iptables -A FORWARD -s 158.220.126.21 -j REJECT # Block 158.220.126.21
iptables -A OUTPUT -d 51.68.185.83 -j REJECT # Block 51.68.185.83
iptables -A INPUT -s 51.68.185.83 -j REJECT # Block 51.68.185.83
iptables -A FORWARD -d 51.68.185.83 -j REJECT # Block 51.68.185.83
iptables -A FORWARD -s 51.68.185.83 -j REJECT # Block 51.68.185.83
iptables -A OUTPUT -d 51.75.48.27 -j REJECT # Block 51.75.48.27
iptables -A INPUT -s 51.75.48.27 -j REJECT # Block 51.75.48.27
iptables -A FORWARD -d 51.75.48.27 -j REJECT # Block 51.75.48.27
iptables -A FORWARD -s 51.75.48.27 -j REJECT # Block 51.75.48.27
iptables -A OUTPUT -d 167.86.127.222 -j REJECT # Block 167.86.127.222
iptables -A INPUT -s 167.86.127.222 -j REJECT # Block 167.86.127.222
iptables -A FORWARD -d 167.86.127.222 -j REJECT # Block 167.86.127.222
iptables -A FORWARD -s 167.86.127.222 -j REJECT # Block 167.86.127.222
iptables -A OUTPUT -d 164.92.247.92 -j REJECT # Block 164.92.247.92
iptables -A INPUT -s 164.92.247.92 -j REJECT # Block 164.92.247.92
iptables -A FORWARD -d 164.92.247.92 -j REJECT # Block 164.92.247.92
iptables -A FORWARD -s 164.92.247.92 -j REJECT # Block 164.92.247.92
iptables -A OUTPUT -d 51.75.156.66 -j REJECT # Block 51.75.156.66
iptables -A INPUT -s 51.75.156.66 -j REJECT # Block 51.75.156.66
iptables -A FORWARD -d 51.75.156.66 -j REJECT # Block 51.75.156.66
iptables -A FORWARD -s 51.75.156.66 -j REJECT # Block 51.75.156.66
iptables -A OUTPUT -d 2.58.80.21 -j REJECT # Block 2.58.80.21
iptables -A INPUT -s 2.58.80.21 -j REJECT # Block 2.58.80.21
iptables -A FORWARD -d 2.58.80.21 -j REJECT # Block 2.58.80.21
iptables -A FORWARD -s 2.58.80.21 -j REJECT # Block 2.58.80.21
iptables -A OUTPUT -d 185.2.100.235 -j REJECT # Block 185.2.100.235
iptables -A INPUT -s 185.2.100.235 -j REJECT # Block 185.2.100.235
iptables -A FORWARD -d 185.2.100.235 -j REJECT # Block 185.2.100.235
iptables -A FORWARD -s 185.2.100.235 -j REJECT # Block 185.2.100.235
# --- Persistent iptables Rules End ---