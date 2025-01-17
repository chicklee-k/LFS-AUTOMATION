#!/bin/bash
set -e

# LFS 환경 변수
LFS=/mnt/lfs/sources

# 패키지 리스트를 배열로 정의
packages=(
    binutils-2.40.tar.xz
    gcc-12.2.0.tar.xz
    linux-6.1.11.tar.xz
    glibc-2.37.tar.xz
    coreutils-9.1.tar.xz
    make-4.4.tar.gz
    diffutils-3.9.tar.xz
    file-5.44.tar.gz
    findutils-4.9.0.tar.xz
    gawk-5.2.1.tar.xz
    grep-3.8.tar.xz
    sed-4.9.tar.xz
    tar-1.34.tar.xz
    xz-5.4.0.tar.xz
    m4-1.4.19.tar.xz
    ncurses-6.4.tar.gz
    perl-5.36.1.tar.xz
    Python-3.11.2.tar.xz
    texinfo-7.0.2.tar.xz
    zlib-1.2.13.tar.xz
)

echo "Building toolchain..."

# 패키지 빌드 루프
for package in "${packages[@]}"; do
    echo "Processing $package..."
    tar -xf "$LFS/$package" -C /tmp
    cd /tmp/"${package%.tar*}" || exit 1
    ./configure --prefix=/tools
    make
    make install
    cd /
    rm -rf /tmp/"${package%.tar*}"
done

echo "Toolchain build completed."
