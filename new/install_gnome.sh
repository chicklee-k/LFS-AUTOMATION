#!/bin/bash
set -e
PREFIX="/usr"
BUILD_DIR="/tmp/build"

GNOME_COMPONENTS=(
    "glib-2.78.0=https://download.gnome.org/sources/glib/2.78/glib-2.78.0.tar.xz"
    "pango-1.50.0=https://download.gnome.org/sources/pango/1.50/pango-1.50.0.tar.xz"
    "gtk+-3.24.38=https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.38.tar.xz"
)

mkdir -pv $BUILD_DIR

for component in "${GNOME_COMPONENTS[@]}"; do
    name_version="${component%%=*}"
    url="${component##*=}"
    tarball="${name_version}.tar.xz"
    folder="${name_version%%-*}"

    echo "Downloading and building $name_version..."
    wget -q $url -O /tmp/$tarball
    tar -xf /tmp/$tarball -C $BUILD_DIR
    cd $BUILD_DIR/$folder-*

    meson _build --prefix=$PREFIX
    ninja -C _build
    ninja -C _build install

    cd /
    rm -rf $BUILD_DIR/$folder-*
done
