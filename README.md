# Halal Mode - DNS & Firewall Protector

A Magisk module that blocks adult/haram content using DNS hosts file and network firewall rules.

Features:
- **Pre-configured blocklist**: StevenBlack hosts with adult, gambling, fakenews, and social extensions
- **Dynamic blocking**: Add or block domains at runtime on device
- **Persistent rules**: Auto-load on boot
- **Dual-layer blocking**: DNS-level and network-level for maximum coverage

---

## Quick Start

### Development: Add Domains to Blocklist
```bash
python3 add_blocker.py -d instagram.com tiktok.com
python3 add_blocker.py -d badsite.com -id id              # With country code
python3 add_blocker.py -d blocked.com --all-countries     # All 249 countries
python3 add_blocker.py --show 20                           # View entries
```

### On Device: Block Additional Domains
```bash
su -c /magisk/halal_mode_haram_blocker/common/scripts/add_block.sh example.com
```

---

## Installation

1. **Build module**: `make` (creates `build/halal_mode_haram_blocker-v1.0.zip`)  
2. **Flash in Magisk Manager** or use ADB to push files
3. **Reboot** - Rules load automatically

---

## Module Information

- **ID**: `halal_mode_haram_blocker`
- **Version**: v1.0
- **Type**: System blocklist + Network firewall
- **Blocklist size**: 169K+ domains
- **System files modified**: `/system/etc/hosts`

---

## Documentation

- **[USAGE.md](USAGE.md)** - Complete usage guide for all tools
- **[config.sh](config.sh)** - Magisk configuration
- **[Makefile](Makefile)** - Build script

---

## Tools Included

| Tool | Purpose | Runs on |
|------|---------|---------|
| `add_blocker.py` | Add domains to project blocklist | PC/Development |
| `add_block.sh` | Add domains on device at runtime | Android device |
| `service.sh` | Load rules at boot | Android device |

---

## The Blocklist

**Source**: [StevenBlack/hosts](https://github.com/StevenBlack/hosts)  
**Extensions**: fakenews, gambling, porn, social  
**Size**: ~4.6MB with 169K+ domains  
**Last updated**: March 2026

---

## Advanced Features

### Country-Specific Blocking
```bash
python3 add_blocker.py -d example.com -id id    # Indonesia
python3 add_blocker.py -d example.com -id sg    # Singapore
python3 add_blocker.py -d example.com -id my    # Malaysia
```

### Global Blocking (All Countries)
```bash
# Adds.country code variant for all 249 countries
python3 add_blocker.py -d malicious.com --all-countries
# Creates 498 entries: ad.malicious.com, ae.malicious.com, ..., zw.malicious.com + www variants
```

---

## Project Structure

```
halal-mode/
├── add_blocker.py              # Development tool (add domains)
├── config.sh                   # Magisk configuration
├── module.prop                 # Module metadata
├── Makefile                    # Build script
├── USAGE.md                    # Usage guide
├── common/
│   ├── service.sh              # Boot-time service
│   ├── post-fs-data.sh         # Post FS-data hook
│   ├── system.prop             # System properties
│   └── scripts/
│       └── add_block.sh        # Runtime blocking script
├── system/
│   └── etc/
│       └── hosts               # Blocklist database (4.6MB)
└── META-INF/
    └── com/google/android/     # Magisk installation files
```

---

## Key Operations

### Add Single Domain
```bash
python3 add_blocker.py -d instagram.com
# Adds: instagram.com, www.instagram.com
```

### Add Multiple Domains
```bash
python3 add_blocker.py -d tiktok.com facebook.com youtube.com
# Adds: 6 entries (each + www variant)
```

### View Current Blocklist
```bash
python3 add_blocker.py --show          # Last 10 entries
python3 add_blocker.py --show 50       # Last 50 entries
```

### Emergency Block on Device
```bash
# Default (Both hosts + iptables):
su -c /magisk/halal_mode_haram_blocker/common/scripts/add_block.sh urgent-block.com

# Firewall only:
su -c /magisk/halal_mode_haram_blocker/common/scripts/add_block.sh --ip urgent-block.com
```

---

## How It Works

1. **Hosts file blocking**: Redirects DNS requests to 127.0.0.1 (localhost)
2. **Firewall blocking**: iptables REJECT rules for additional network protection
3. **Rule persistence**: service.sh loads rules automatically at boot

---

## Performance

- `add_blocker.py`: Optimized for bulk operations (batch writes + caching)
- `add_block.sh`: Lightweight shell script with minimal system load
- Large blocklists: Efficiently handled with ~4.6MB for 169K+ domains

---

## Notes

- ⚠️ Module requires Magisk or KSU
- ⚠️ Device must support iptables
- ✅ Module structure allows easy updates to blocklist
- ✅ Both development and runtime tools included

---

## License

- **Hosts file**: [StevenBlack/hosts](https://github.com/StevenBlack/hosts) (MIT License)
- **Module structure**: [Magisk Module Template](https://github.com/topjohnwu/Magisk)

