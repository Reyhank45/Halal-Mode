#!/system/bin/sh

MODPATH=${0%/*}

# Temporary directory for update
TMP_DIR=/data/local/tmp/halal_mode_update

echo "Starting standalone update process..."

# Create tmp dir
rm -rf $TMP_DIR
mkdir -p $TMP_DIR

echo "Downloading updated files from GitHub main branch..."

FILES="
system/etc/hosts
common/service.sh
common/scripts/add_block.sh
version
module.prop
update.json
action.sh
add_blocker.py
"

BASE_URL="https://raw.githubusercontent.com/Reyhank45/Halal-Mode/main"
SUCCESS=true

for file in $FILES; do
    echo "Downloading $file..."
    mkdir -p "$TMP_DIR/$(dirname "$file")"
    URL="$BASE_URL/$file?t=$RANDOM"
    curl -sL "$URL" -o "$TMP_DIR/$file" || wget -qO "$TMP_DIR/$file" "$URL"
    
    if [ ! -s "$TMP_DIR/$file" ]; then
        echo "Failed to download $file"
        SUCCESS=false
    fi
done

if [ "$SUCCESS" != true ]; then
    echo "Failed to download some update files."
    rm -rf $TMP_DIR
    exit 1
fi

echo "Installing update..."
for file in $FILES; do
    mkdir -p "$MODPATH/$(dirname "$file")"
    cp -f "$TMP_DIR/$file" "$MODPATH/$file"
done

# Fix permissions
chown -R 0:0 $MODPATH
find $MODPATH -type f -exec chmod 644 {} +
find $MODPATH -type d -exec chmod 755 {} +
chmod 755 $MODPATH/action.sh
chmod 755 $MODPATH/common/service.sh
chmod 755 $MODPATH/common/scripts/add_block.sh 2>/dev/null

echo "Update complete! Please reboot your device."

# Clean up
rm -rf $TMP_DIR
