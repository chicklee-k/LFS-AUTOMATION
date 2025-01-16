#!/bin/bash
set -e
LFS=/mnt/lfs/sources

echo "Downloading packages..."
wget -P $LFS http://www.linuxfromscratch.org/lfs/view/stable/wget-list
wget -P $LFS http://www.linuxfromscratch.org/lfs/view/stable/md5sums
wget --input-file=$LFS/wget-list --continue --directory-prefix=$LFS
