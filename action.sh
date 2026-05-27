#!/system/bin/sh

MODPATH=${0%/*}

# Temporary directory for update
TMP_DIR=/data/local/tmp/halal_mode_update

echo "Starting standalone update process..."

# Create tmp dir
rm -rf $TMP_DIR
mkdir -p $TMP_DIR

echo "Downloading latest source from GitHub main branch..."
ZIP_FILE=$TMP_DIR/main.zip
URL="https://github.com/Reyhank45/Halal-Mode/archive/refs/heads/main.zip"

curl -sL "$URL" -o $ZIP_FILE || wget -qO $ZIP_FILE "$URL"

if [ ! -f "$ZIP_FILE" ] || [ ! -s "$ZIP_FILE" ]; then
    echo "Failed to download the update."
    rm -rf $TMP_DIR
    exit 1
fi

echo "Extracting update..."
# unzip is standard in Android's toybox/busybox
unzip -qo $ZIP_FILE -d $TMP_DIR

if [ ! -d "$TMP_DIR/Halal-Mode-main" ]; then
    echo "Failed to extract or unexpected directory structure."
    rm -rf $TMP_DIR
    exit 1
fi

echo "Installing update..."
cd $TMP_DIR/Halal-Mode-main

# Copy relevant module files directly to MODPATH
cp -rf system common META-INF module.prop config.sh action.sh $MODPATH/

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
