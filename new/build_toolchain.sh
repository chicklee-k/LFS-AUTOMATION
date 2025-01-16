#!/bin/bash
set -e
LFS=/mnt/lfs/sources

echo "Building toolchain..."
for package in $(cat packages_list.txt); do
    tar -xf $LFS/$package -C /tmp
    cd /tmp/${package%.tar*}
    ./configure --prefix=/tools
    make
    make install
    cd /
    rm -rf /tmp/${package%.tar*}
done
