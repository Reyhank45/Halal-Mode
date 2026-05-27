#!/system/bin/sh

MODPATH=${0%/*}

# Temporary directory for cloning
TMP_DIR=/data/local/tmp/halal_mode_update

echo "Starting update process..."

# Remove old dir if exists
rm -rf $TMP_DIR

# Clone the repository
echo "Cloning repository..."
git clone https://github.com/reyhank45/Halal-Mode.git $TMP_DIR

if [ $? -ne 0 ]; then
    echo "Failed to clone repository!"
    exit 1
fi

# Build the module
echo "Building module..."
cd $TMP_DIR
make

if [ $? -ne 0 ]; then
    echo "Failed to build module!"
    exit 1
fi

# Find the built zip
ZIP_FILE=$(ls build/*.zip | head -n 1)

if [ -f "$ZIP_FILE" ]; then
    # Install the module via magisk
    echo "Installing module..."
    magisk --install-module "$ZIP_FILE"
    
    if [ $? -eq 0 ]; then
        echo "Update complete! Please reboot your device."
    else
        echo "Failed to install module via Magisk!"
        exit 1
    fi
else
    echo "Build failed! Zip file not found."
    exit 1
fi

# Clean up
rm -rf $TMP_DIR
