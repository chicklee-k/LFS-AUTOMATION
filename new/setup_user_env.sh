#!/bin/bash
set -e
LFS=/mnt/lfs

echo "Creating lfs user and setting environment..."
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
chown -v lfs $LFS/{sources,tools}
echo "export LFS=$LFS" >> /home/lfs/.bashrc
