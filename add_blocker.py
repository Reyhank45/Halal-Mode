#!/usr/bin/env python3
"""
Halal Mode - Hosts Database Manager
Development tool to add domains to the project's hosts blocklist.
Automatically adds both domain.com and www.domain.com variants.
Resolves domains to IPs and adds persistent iptables rules.
"""

import sys
import argparse
import socket
import subprocess
import re
from pathlib import Path


# All ISO 3166-1 alpha-2 country codes
COUNTRY_CODES = [
    'ad', 'ae', 'af', 'ag', 'ai', 'al', 'am', 'ao', 'aq', 'ar', 'as', 'at', 'au', 'aw', 'ax', 'az',
    'ba', 'bb', 'bd', 'be', 'bf', 'bg', 'bh', 'bi', 'bj', 'bl', 'bm', 'bn', 'bo', 'bq', 'br', 'bs', 'bt', 'bv', 'bw', 'by', 'bz',
    'ca', 'cc', 'cd', 'cf', 'cg', 'ch', 'ci', 'ck', 'cl', 'cm', 'cn', 'co', 'cr', 'cu', 'cv', 'cw', 'cx', 'cy', 'cz',
    'de', 'dj', 'dk', 'dm', 'do', 'dz',
    'ec', 'ee', 'eg', 'eh', 'er', 'es', 'et',
    'fi', 'fj', 'fk', 'fm', 'fo', 'fr',
    'ga', 'gb', 'gd', 'ge', 'gf', 'gg', 'gh', 'gi', 'gl', 'gm', 'gn', 'gp', 'gq', 'gr', 'gs', 'gt', 'gu', 'gw', 'gy',
    'hk', 'hm', 'hn', 'hr', 'ht', 'hu',
    'id', 'ie', 'il', 'im', 'in', 'io', 'iq', 'ir', 'is', 'it',
    'je', 'jm', 'jo', 'jp',
    'ke', 'kg', 'kh', 'ki', 'km', 'kn', 'kp', 'kr', 'kw', 'ky', 'kz',
    'la', 'lb', 'lc', 'li', 'lk', 'lr', 'ls', 'lt', 'lu', 'lv', 'ly',
    'ma', 'mc', 'md', 'me', 'mf', 'mg', 'mh', 'mk', 'ml', 'mm', 'mn', 'mo', 'mp', 'mq', 'mr', 'ms', 'mt', 'mu', 'mv', 'mw', 'mx', 'my', 'mz',
    'na', 'nc', 'ne', 'nf', 'ng', 'ni', 'nl', 'no', 'np', 'nr', 'nu', 'nz',
    'om',
    'pa', 'pe', 'pf', 'pg', 'ph', 'pk', 'pl', 'pm', 'pn', 'pr', 'ps', 'pt', 'pw', 'py',
    'qa',
    're', 'ro', 'rs', 'ru', 'rw',
    'sa', 'sb', 'sc', 'sd', 'se', 'sg', 'sh', 'si', 'sj', 'sk', 'sl', 'sm', 'sn', 'so', 'sr', 'ss', 'st', 'sv', 'sx', 'sy', 'sz',
    'tc', 'td', 'tf', 'tg', 'th', 'tj', 'tk', 'tl', 'tm', 'tn', 'to', 'tr', 'tt', 'tv', 'tw', 'tz',
    'ua', 'ug', 'um', 'us', 'uy', 'uz',
    'va', 'vc', 've', 'vg', 'vi', 'vn', 'vu',
    'wf', 'ws',
    'ye', 'yt',
    'za', 'zm', 'zw'
]


class HostsManager:
    """Manages the hosts file database for Halal Mode module"""
    
    HOSTS_FILE = "system/etc/hosts"
    HOSTS_REDIRECT_IP = "127.0.0.1"
    
    def __init__(self):
        """Initialize the hosts manager"""
        self.script_dir = Path(__file__).parent
        self.hosts_path = self.script_dir / self.HOSTS_FILE
        
        if not self.hosts_path.exists():
            print(f"Error: Hosts file not found at {self.hosts_path}", file=sys.stderr)
            sys.exit(1)
    
    def is_valid_domain(self, domain):
        """Check if string looks like a valid domain"""
        # Basic domain validation
        if not domain or len(domain) < 3:
            return False
        if domain.startswith('.') or domain.endswith('.'):
            return False
        # Valid if it's www.something or has a dot
        if domain.startswith('www.'):
            return True
        if '.' in domain:
            return True
        return False
    
    def get_domain_variants(self, domain, country_id=None, all_countries=False):
        """
        Get domain variants to add (domain and www.domain, optionally with country prefix)
        
        Args:
            domain: Base domain name
            country_id: Optional alpha2 country code (e.g., 'id', 'us', 'uk')
            all_countries: If True, add variants for all available country codes
            
        Returns:
            List of domain variants to add
        """
        variants = []
        
        # Remove www. prefix if present to get clean domain
        clean_domain = domain.lstrip('www.')
        
        # If all_countries is requested, add variants for every country code
        if all_countries:
            for country in COUNTRY_CODES:
                variants.append(f"{country}.{clean_domain}")
                variants.append(f"www.{country}.{clean_domain}")
        # If single country_id is provided, add variants with that prefix
        elif country_id:
            country_id = country_id.lower()
            # Add prefixed base domain
            variants.append(f"{country_id}.{clean_domain}")
            # Add prefixed www variant
            variants.append(f"www.{country_id}.{clean_domain}")
        else:
            # Add base domain
            variants.append(clean_domain)
            # Add www variant if not already included
            if not domain.startswith('www.'):
                variants.append(f"www.{clean_domain}")
        
        return variants
    
    def is_entry_in_hosts(self, entry):
        """
        Check if exact entry exists in hosts file
        
        Args:
            entry: Domain/entry to check
            
        Returns:
            True if entry exists, False otherwise
        """
        try:
            # Read file once and cache entries
            if not hasattr(self, '_hosts_cache'):
                with open(self.hosts_path, 'r') as f:
                    self._hosts_cache = set()
                    for line in f:
                        line = line.strip()
                        # Skip comments and empty lines
                        if not line or line.startswith('#'):
                            continue
                        # Extract domain from "IP domain" format
                        parts = line.split()
                        if len(parts) >= 2:
                            self._hosts_cache.add(parts[1])
            
            return entry in self._hosts_cache
        except Exception:
            return False
    
    def add_to_hosts(self, domain, country_id=None, all_countries=False):
        """
        Add domain to hosts file (both domain and www variant, optionally with country prefix)
        
        Args:
            domain: Domain name to block
            country_id: Optional alpha2 country code (e.g., 'id', 'us')
            all_countries: If True, add for all available country codes
            
        Returns:
            Number of entries added
        """
        if not self.is_valid_domain(domain):
            print(f"✗ Error: '{domain}' is not a valid domain", file=sys.stderr)
            return 0
        
        # Get domain variants
        variants = self.get_domain_variants(domain, country_id, all_countries)
        
        # Pre-check which variants need to be added (optimization)
        to_add = []
        for variant in variants:
            if not self.is_entry_in_hosts(variant):
                to_add.append(variant)
            else:
                print(f"ℹ  '{variant}' already in hosts file")
        
        if not to_add:
            return 0
        
        # Write all new entries at once
        try:
            with open(self.hosts_path, 'a') as f:
                for variant in to_add:
                    f.write(f"{self.HOSTS_REDIRECT_IP} {variant}\n")
                    print(f"✓ Added '{variant}' to hosts file")
            
            # Invalidate cache for next check
            if hasattr(self, '_hosts_cache'):
                del self._hosts_cache
            
            return len(to_add)
        
        except PermissionError:
            print(f"✗ Error: Permission denied writing to {self.hosts_path}", file=sys.stderr)
            return 0
        except Exception as e:
            print(f"✗ Error writing to hosts file: {e}", file=sys.stderr)
            return 0

    def is_ip_address(self, s):
        """Check if string is a valid IPv4 address"""
        try:
            socket.inet_aton(s)
            return True
        except (socket.error, TypeError):
            return False

    def add_iptables_rule(self, domain):
        """
        Resolve domain to IP (or use directly if already an IP) and add rule to service.sh
        """
        try:
            # Check if input is already an IP
            if self.is_ip_address(domain):
                ips = {domain}
            else:
                # Resolve IPs (IPv4 only)
                ips = set()
                try:
                    addr_info = socket.getaddrinfo(domain, None, socket.AF_INET)
                    for info in addr_info:
                        ip = info[4][0]
                        # Filter out loopback and null IPs
                        if ip not in ('0.0.0.0', '127.0.0.1'):
                            ips.add(ip)
                except socket.gaierror:
                    return 0
            
            if not ips:
                return 0

            service_sh_path = self.script_dir / "common" / "service.sh"
            if not service_sh_path.exists():
                print(f"⚠️  Warning: service.sh not found at {service_sh_path}")
                return 0

            with open(service_sh_path, 'r') as f:
                content = f.read()

            new_rules = []
            for ip in ips:
                # Define rules for comprehensive blocking
                # OUTPUT: blocks outgoing to site
                # INPUT: blocks incoming from site
                # FORWARD: blocks tethered devices from/to site
                rules = [
                    f"iptables -A OUTPUT -d {ip} -j REJECT # Block {domain}",
                    f"iptables -A INPUT -s {ip} -j REJECT # Block {domain}",
                    f"iptables -A FORWARD -d {ip} -j REJECT # Block {domain}",
                    f"iptables -A FORWARD -s {ip} -j REJECT # Block {domain}"
                ]
                
                for rule in rules:
                    if rule not in content:
                        new_rules.append(rule)
                    else:
                        rule_type = rule.split()[2]  # Get chain name
                        print(f"ℹ  Firewall rule ({rule_type}) for {ip} already in service.sh")

            if not new_rules:
                return 0

            # Insert before marker
            marker = "# --- Persistent iptables Rules End ---"
            if marker in content:
                updated_content = content.replace(marker, "\n".join(new_rules) + "\n" + marker)
                with open(service_sh_path, 'w') as f:
                    f.write(updated_content)
                for rule in new_rules:
                    print(f"✓ Added firewall rule for {domain} ({rule.split()[4]})")
                return len(new_rules)
            else:
                print(f"⚠️  Warning: Marker '{marker}' not found in service.sh")
                return 0

        except Exception as e:
            print(f"✗ Error adding firewall rules for {domain}: {e}", file=sys.stderr)
            return 0
    
    def list_recent_entries(self, count=10):
        """
        Show last N entries in hosts file
        
        Args:
            count: Number of entries to show (default 10)
        """
        try:
            with open(self.hosts_path, 'r') as f:
                lines = f.readlines()

            # Filter out comments and empty lines
            entries = [line.strip() for line in lines if line.strip() and not line.startswith('#')]

            if not entries:
                print("No entries in hosts file yet (except comments)")
                return

            print(f"\nLast {min(count, len(entries))} entries in hosts file:")
            print("=" * 50)
            for entry in entries[-count:]:
                print(entry)
            print(f"\nTotal entries: {len(entries)}")

        except Exception as e:
            print(f"Error reading hosts file: {e}", file=sys.stderr)


def increment_version(version_str):
    """Return incremented version with -qfwb-XXXX suffix."""
    version_str = version_str.strip()

    m = re.match(r'^(v?[0-9]+(?:\.[0-9]+)*)(?:-qfwb-(\d+))?$', version_str)
    if not m:
        # Fallback: just append qfwb-0001
        return f"{version_str}-qfwb-0001"

    base = m.group(1)
    suffix = m.group(2)

    if suffix is None:
        count = 1
    else:
        count = int(suffix) + 1

    return f"{base}-qfwb-{count:04d}"


def bump_project_version():
    """Update version file and module.prop with incremented -qfwb-XXXX version, and bump versionCode."""
    base_dir = Path(__file__).parent
    version_path = base_dir / 'version'
    module_prop_path = base_dir / 'module.prop'

    if not version_path.exists() or not module_prop_path.exists():
        return None

    current_version = version_path.read_text().strip()
    if not current_version:
        return None

    new_version = increment_version(current_version)
    version_path.write_text(new_version + "\n")

    module_prop_data = module_prop_path.read_text()

    # Update version string
    module_prop_data = re.sub(r'^version=.*$', f'version={new_version}', module_prop_data, flags=re.M)

    # Update versionCode integer if present; otherwise, add it after version.
    version_code_match = re.search(r'^versionCode=(\d+)$', module_prop_data, flags=re.M)
    if version_code_match:
        current_code = int(version_code_match.group(1))
        next_code = current_code + 1
        module_prop_data = re.sub(r'^versionCode=\d+$', f'versionCode={next_code}', module_prop_data, flags=re.M)
        print(f"🔧 versionCode updated: {current_code} -> {next_code}")
    else:
        module_prop_data = re.sub(r'(^version=.*$)', r"\1\nversionCode=2", module_prop_data, flags=re.M)
        print("🔧 versionCode added: 2")

    module_prop_path.write_text(module_prop_data)

    print(f"🔧 Version updated: {current_version} -> {new_version}")
    return new_version


def main():
    parser = argparse.ArgumentParser(
        description='Halal Mode - Add domains to hosts blocklist',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Add a single domain or IP (adds both example.com and www.example.com)
  python3 add_blocker.py example.com

  # Add multiple domains/IPs
  python3 add_blocker.py instagram.com tiktok.com 1.2.3.4

  # Add domain with country code prefix (adds id.example.com and www.id.example.com)
  python3 add_blocker.py example.com -id id

  # Add domain with firewall rules (resolves to IPs and adds to service.sh)
  python3 add_blocker.py example.com --ip

  # Block a static IP directly via firewall
  python3 add_blocker.py 66.29.129.161 --fw

  # Show last 20 entries in blocklist
  python3 add_blocker.py --show 20
        """
    )
    
    parser.add_argument('-d', '--domain', nargs='+', help='Domain(s) to add to blocklist')
    parser.add_argument('pos_domain', nargs='*', help='Domain(s) or IP(s) to add to blocklist')
    parser.add_argument('-id', '--country-id', type=str, metavar='ID',
                        help='Alpha2 country code to prepend (e.g., id, us, uk)')
    parser.add_argument('--all-countries', action='store_true',
                        help='Add domain with ALL country codes (each domain = 498 entries)')
    parser.add_argument('--ip', '--fw', action='store_true',
                        help='Also add iptables firewall rules for these domains')
    parser.add_argument('--show', type=int, nargs='?', const=10, metavar='N',
                        help='Show last N entries from hosts file (default: 10)')
    
    args = parser.parse_args()
    
    # Merge flagged and positional domains
    domains = (args.domain or []) + args.pos_domain
    
    # Validate arguments
    if not domains and args.show is None:
        parser.print_help()
        sys.exit(1)
    
    # Initialize manager
    manager = HostsManager()
    
    # Show recent entries if requested
    if args.show is not None:
        manager.list_recent_entries(args.show)
        if domains:
            print("\n" + "=" * 50)
    
    # Add domains
    if domains:
        print("Adding domains to hosts blocklist...")
        print("=" * 50)
        
        # Warn about --all-countries
        if args.all_countries:
            total_variants = len(domains) * 498  # 249 countries * 2 (domain + www)
            print(f"⚠️  WARNING: Adding ALL country codes for {len(domains)} domain(s)")
            print(f"⚠️  This will add {total_variants} entries total")
            print()
        
        total_added = 0
        total_fw_added = 0
        for domain in domains:
            # Add to hosts file
            count = manager.add_to_hosts(domain, args.country_id, args.all_countries)
            total_added += count
            
            # Add firewall rules if requested
            if args.ip:
                variants = manager.get_domain_variants(domain, args.country_id, args.all_countries)
                for variant in variants:
                    fw_count = manager.add_iptables_rule(variant)
                    total_fw_added += fw_count
        
        if total_added > 0 or total_fw_added > 0:
            print("\n" + "=" * 50)
            if total_added > 0:
                print(f"✓ Successfully added {total_added} entries to hosts file")
            if total_fw_added > 0:
                print(f"✓ Successfully added {total_fw_added} firewall rules to service.sh")
        else:
            print("\n" + "=" * 50)
            print("ℹ  No new entries were added (all duplicates or resolution failed)")

        # Bump version on each add_blocker invocation with domain arguments
        bumped_version = bump_project_version()
        if bumped_version:
            print(f"✅ New module version: {bumped_version}")


if __name__ == '__main__':
    main()
