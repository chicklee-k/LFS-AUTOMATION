#!/bin/bash
set -e
CHROMIUM_VERSION="116.0.5845.140"
BUILD_DIR="/tmp/chromium"

echo "Installing Google Chrome $CHROMIUM_VERSION..."
wget -q https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${CHROMIUM_VERSION}.tar.xz -O /tmp/chromium.tar.xz
mkdir -pv $BUILD_DIR
tar -xf /tmp/chromium.tar.xz -C $BUILD_DIR
cd $BUILD_DIR/chromium-${CHROMIUM_VERSION}

mkdir -pv out/Default
gn gen out/Default --args="is_debug=false enable_nacl=false enable_swiftshader=false is_component_build=false symbol_level=0"
ninja -C out/Default chrome

# Install binary
cp -v out/Default/chrome /usr/bin/google-chrome

cd /
rm -rf $BUILD_DIR
