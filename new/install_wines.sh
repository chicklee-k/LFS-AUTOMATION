#!/bin/bash
set -e
WINE_VERSION="8.0.2"
BUILD_DIR="/tmp/wine"

echo "Installing WINE $WINE_VERSION..."
wget -q https://dl.winehq.org/wine/source/8.x/wine-${WINE_VERSION}.tar.xz -O /tmp/wine.tar.xz
mkdir -pv $BUILD_DIR
tar -xf /tmp/wine.tar.xz -C $BUILD_DIR
cd $BUILD_DIR/wine-${WINE_VERSION}

./configure --prefix=/usr
make -j$(nproc)
make install

cd /
rm -rf $BUILD_DIR
