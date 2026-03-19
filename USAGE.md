# Halal Mode - Usage Guide

Two essential tools for managing the Halal Mode Magisk module:

---

## `add_blocker.py` - Project Management Tool

**Purpose**: Add domains to the project's blocklist during development.
**Runs on**: Your development machine (PC/Linux/Mac)
**Task**: Updates `system/etc/hosts` with new blocked domains

### Features
- **Auto www variant**: Adding `instagram.com` also adds `www.instagram.com`
- **Country codes**: Add domains with country prefix: `-id id` → `id.instagram.com`
- **All countries**: Add all 249 country codes: `--all-countries` → 498 variants per domain
- **Batch optimized**: Efficient for adding thousands of domains
- **Duplicate detection**: Won't re-add existing entries

### Usage

```bash
# Add single domain
python3 add_blocker.py -d instagram.com

# Add multiple domains
python3 add_blocker.py -d tiktok.com facebook.com youtube.com

# Add with country code
python3 add_blocker.py -d example.com -id id

# Add with ALL country codes (498 entries)
python3 add_blocker.py -d badsite.com --all-countries

# View recent additions
python3 add_blocker.py --show 20
```

---

## `common/scripts/add_block.sh` - Runtime Tool

**Purpose**: Apply blocking rules on the Android device at runtime.
**Runs on**: Android device with Magisk module installed (requires root)
**Task**: Adds DNS and firewall rules for immediate blocking

### Features
- **DNS blocking**: Adds entries to `/system/etc/hosts`
- **Firewall blocking**: Adds iptables REJECT rules  
- **Auto persistence**: Rules saved for boot-time loading
- **Domain resolution**: Resolves domains to IPs automatically
- **No extra dependencies**: Uses standard Android tools

### Usage on Device

```bash
# Run on rooted Android:
su -c /magisk/halal_mode_haram_blocker/common/scripts/add_block.sh example.com

# Block multiple domains:
su -c /magisk/halal_mode_haram_blocker/common/scripts/add_block.sh site1.com site2.com
```

---

## Complete Workflow

### 1. Build Blocklist (Development)
```bash
cd ~/Halal-Mode
python3 add_blocker.py -d adult-site.com gambling.net
python3 add_blocker.py -d social-media.com -id id
python3 add_blocker.py -d badsite.com --all-countries
```

### 2. Verify Changes
```bash
python3 add_blocker.py --show 10
```

### 3. Build Module
```bash
make
# Creates: build/halal_mode_haram_blocker-v1.0.zip
```

### 4. Deploy to Device
```bash
# Via Magisk Manager: Flash the .zip
# Or manually: Push files via ADB
```

### 5. Apply Runtime Rules (Optional)
```bash
# On device, for emergency blocking:
su -c /magisk/halal_mode_haram_blocker/common/scripts/add_block.sh urgent-block.com
```

---

## How Blocking Works

### At Project Level (add_blocker.py)
```
domains added → system/etc/hosts (project database)
    ↓
make → build Magisk module
    ↓
Module installed on device
```

### On Device (add_block.sh)
```
Domain added → Resolve to IP
    ↓
Add to /system/etc/hosts (DNS block)
Add iptables rule (Network block)
    ↓
Both active immediately
Rules persisted to service.sh (survive reboot)
```

---

## File Locations

### Development
```
~/Halal-Mode/
├── add_blocker.py                  ← Development tool
├── system/etc/hosts                ← Project blocklist (4.6MB)
└── common/
    └── scripts/
        └── add_block.sh            ← Runtime script
```

### On Device
```
/magisk/halal_mode_haram_blocker/
├── common/service.sh               ← Boot-time rules
├── common/scripts/add_block.sh     ← Dynamic blocking
└── system/etc/hosts                ← Active blocklist
```

---

## Performance

- **add_blocker.py**: Optimized for large domain lists (caching + batch writes)
- **add_block.sh**: Lightweight shell script with minimal overhead
- **Blocklist**: 169K+ domains at 4.6MB (~25KB per 1000 domains)

---

## Troubleshooting

**Device: "Permission denied"**
- Use `su -c` to run with root privileges

**Device: "add_block.sh not found"**
- Verify module is installed: `ls /magisk/halal_mode_haram_blocker/`

**Development: "Domain already in hosts"**
- This is normal - script prevents duplicates

**Check if blocking works**
```bash
# Device: Test DNS blocking
nslookup blocked-domain.com          # Should fail
cat /system/etc/hosts | grep domain  # Should show entry

# Device: Check iptables rules
iptables -L OUTPUT -n | grep REJECT
```

---

## Tips

- Use `add_blocker.py` for bulk additions during development
- Use `add_block.sh` on device for emergency/temporary blocks
- Country codes useful for region-specific blocking: `id`, `sg`, `my`
- Check `python3 add_blocker.py -h` for all options

