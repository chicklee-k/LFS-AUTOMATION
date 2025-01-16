#!/bin/bash
set -e
LFS=/mnt/lfs

echo "Setting up directories..."
mkdir -pv $LFS/{sources,tools}
chmod -v a+wt $LFS/sources
ln -sv $LFS/tools /
