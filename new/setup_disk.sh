#!/bin/bash
set -e

# 사용자 정의 설정
LFS_PARTITION="/dev/sdX1"   # LFS 파티션 (사용자 정의)
LFS_MOUNT_POINT="/mnt/lfs" # LFS 마운트 지점

# 경고 메시지
echo "경고: 이 스크립트는 디스크 파티션을 초기화하고 데이터를 삭제합니다."
read -p "진행하려면 'yes'를 입력하세요: " confirm
if [ "$confirm" != "yes" ]; then
    echo "작업이 취소되었습니다."
    exit 1
fi

# 디스크 파티션 생성
echo "디스크 파티션 생성 중..."
parted /dev/sdX --script mklabel gpt
parted /dev/sdX --script mkpart primary ext4 1MiB 100%
parted /dev/sdX --script set 1 boot on

# 파일 시스템 생성
echo "파일 시스템 생성 중..."
mkfs.ext4 -F $LFS_PARTITION

# LFS 디렉터리 마운트
echo "LFS 디렉터리 마운트 중..."
mkdir -pv $LFS_MOUNT_POINT
mount -v $LFS_PARTITION $LFS_MOUNT_POINT

# 마운트 확인
echo "마운트 확인:"
df -h | grep $LFS_MOUNT_POINT

# 성공 메시지
echo "디스크 설정이 완료되었습니다."
echo "LFS 파티션: $LFS_PARTITION"
echo "마운트 지점: $LFS_MOUNT_POINT"
