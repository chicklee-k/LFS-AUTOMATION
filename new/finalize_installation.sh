#!/bin/bash
set -e
LFS=/mnt/lfs

echo "Finalizing installation..."
chroot $LFS /tools/bin/env -i \
    HOME=/root TERM="$TERM" PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login
