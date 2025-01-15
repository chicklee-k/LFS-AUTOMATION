#!/bin/bash

# 에러 시 스크립트 종료
set -e
set -u

# 사용자 설정
DISK="/dev/sdX"  # 설치할 디스크 (수동으로 수정 필요)
LFS_PARTITION="${DISK}1"
LFS=/mnt/lfs
SOURCE_DIR="$LFS/sources"
TOOLS_DIR="$LFS/tools"
LFS_VERSION="11.3"

# 루트 권한 확인
if [ "$(id -u)" -ne 0 ]; then
  echo "이 스크립트는 root 권한으로 실행해야 합니다."
  exit 1
fi

# 1. 디스크 파티션 및 파일 시스템 설정
echo "1. 디스크 파티션 생성 중..."
parted --script $DISK mklabel gpt
parted --script $DISK mkpart primary ext4 1MiB 100%
mkfs.ext4 -F $LFS_PARTITION
mkdir $LFS
mount $LFS_PARTITION $LFS

# 2. 디렉터리 및 권한 설정
echo "2. 디렉터리 생성 및 권한 설정 중..."
mkdir -pv $SOURCE_DIR $TOOLS_DIR
chmod -v a+wt $SOURCE_DIR
groupadd lfs || true
useradd -s /bin/bash -g lfs -m -k /dev/null lfs || true
chown -v lfs:lfs $LFS/{sources,tools}
chown -v lfs:lfs $LFS

# 3. 환경 변수 설정
echo "3. 환경 변수 설정 중..."
cat > /home/lfs/.bashrc << EOF
export LFS=/mnt/lfs
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export PATH=\$LFS/tools/bin:\$PATH
EOF

# 4. 소스 파일 다운로드
echo "4. 소스 파일 다운로드 중..."
sudo -u lfs wget -P $SOURCE_DIR https://www.linuxfromscratch.org/lfs/downloads/stable/wget-list
sudo -u lfs wget -P $SOURCE_DIR https://www.linuxfromscratch.org/lfs/downloads/stable/md5sums
sudo -u lfs wget --input-file=$SOURCE_DIR/wget-list --continue --directory-prefix=$SOURCE_DIR

# 5. 다운로드 파일 검증
echo "5. 파일 무결성 검증 중..."
sudo -u lfs md5sum -c $SOURCE_DIR/md5sums || { echo "파일 검증 실패!"; exit 1; }

# 6. LFS 빌드
echo "6. LFS 빌드 시작..."
sudo -u lfs bash << 'EOF'
source ~/.bashrc
# 여기서부터는 LFS 책의 빌드 명령어를 그대로 추가
# 예시:
tar -xf $LFS/sources/binutils-*.tar.xz
cd binutils-*
mkdir -v build
cd build
../configure --prefix=/tools --with-sysroot=$LFS --target=$LFS_TGT --disable-nls --disable-werror
make
make install
cd ../..
rm -rf binutils-*
EOF

# 7. BLFS 설치 (예: GNOME)
echo "7. BLFS 패키지 설치 중..."
sudo -u lfs bash << 'EOF'
# GNOME 또는 원하는 패키지 설치
tar -xf $LFS/sources/mutter-*.tar.xz
cd mutter-*
meson _build --prefix=/usr
ninja -C _build
ninja -C _build install
cd ..
rm -rf mutter-*
EOF

# 8. 부트로더 설치 및 설정
echo "8. 부트로더 설치 중..."
mount -o bind /dev $LFS/dev
mount -o bind /proc $LFS/proc
mount -o bind /sys $LFS/sys
chroot $LFS /bin/bash << EOF
grub-install $DISK
cat > /boot/grub/grub.cfg << GRUBEOF
menuentry "LinuxPuzzle" {
    set root=(hd0,1)
    linux /boot/vmlinuz-lfs root=/dev/sda1 ro
}
GRUBEOF
EOF

echo "설치 완료! 시스템을 재부팅하세요. 이 외에 다른 사항..."
