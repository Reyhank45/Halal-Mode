#!/system/bin/sh

MODPATH=${0%/*}

# Temporary directory for update
TMP_DIR=/data/local/tmp/halal_mode_update

echo "Starting standalone update process..."

# Create tmp dir
rm -rf $TMP_DIR
mkdir -p $TMP_DIR

echo "Downloading updated files from GitHub main branch..."
HOSTS_URL="https://raw.githubusercontent.com/Reyhank45/Halal-Mode/main/system/etc/hosts?t=$RANDOM"
SERVICE_URL="https://raw.githubusercontent.com/Reyhank45/Halal-Mode/main/common/service.sh?t=$RANDOM"

curl -sL "$HOSTS_URL" -o $TMP_DIR/hosts || wget -qO $TMP_DIR/hosts "$HOSTS_URL"
curl -sL "$SERVICE_URL" -o $TMP_DIR/service.sh || wget -qO $TMP_DIR/service.sh "$SERVICE_URL"

if [ ! -s "$TMP_DIR/hosts" ] || [ ! -s "$TMP_DIR/service.sh" ]; then
    echo "Failed to download the update."
    rm -rf $TMP_DIR
    exit 1
fi

echo "Installing update..."
mkdir -p $MODPATH/system/etc
mkdir -p $MODPATH/common

cp -f $TMP_DIR/hosts $MODPATH/system/etc/hosts
cp -f $TMP_DIR/service.sh $MODPATH/common/service.sh

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
