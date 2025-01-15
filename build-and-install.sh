#!/bin/bash

# 에러 발생 시 종료
set -e
set -u

# 기본 설정
LFS=/mnt/lfs
SOURCE_DIR="$LFS/sources"
BUILD_DIR="$LFS/build"
PREFIX="/usr"
MAKEFLAGS="-j$(nproc)"

# 설치 디렉토리 준비
mkdir -pv $SOURCE_DIR $BUILD_DIR
chmod -v a+wt $SOURCE_DIR $BUILD_DIR

# 1. 의존성 설치
echo "1. 필요한 의존성 설치 중..."
apt-get update
apt-get install -y build-essential curl wget git meson ninja-build cmake pkg-config \
    libx11-dev libxext-dev libxi-dev libxrandr-dev libxinerama-dev libxcursor-dev \
    libpng-dev libjpeg-dev libfreetype6-dev libxml2-dev libssl-dev zlib1g-dev \
    libgl1-mesa-dev libglu1-mesa-dev dbus-x11 xorg-dev libwayland-dev \
    libcairo2-dev libgdk-pixbuf2.0-dev libatk1.0-dev libpango1.0-dev libgtk-3-dev \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev yasm

# 2. GNOME 설치
echo "2. GNOME 설치 중..."
GNOME_COMPONENTS=(
    "glib-2.78.0=https://download.gnome.org/sources/glib/2.78/glib-2.78.0.tar.xz"
    "pango-1.50.0=https://download.gnome.org/sources/pango/1.50/pango-1.50.0.tar.xz"
    "gtk+-3.24.38=https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.38.tar.xz"
    "mutter-44.2=https://download.gnome.org/sources/mutter/44/mutter-44.2.tar.xz"
    "gnome-shell-44.2=https://download.gnome.org/sources/gnome-shell/44/gnome-shell-44.2.tar.xz"
)

for component in "${GNOME_COMPONENTS[@]}"; do
    name_version="${component%%=*}"
    url="${component##*=}"
    tarball="${name_version}.tar.xz"
    folder="${name_version%%-*}"

    echo "Downloading and building $name_version..."
    wget -q $url -O $SOURCE_DIR/$tarball
    tar -xf $SOURCE_DIR/$tarball -C $BUILD_DIR
    cd $BUILD_DIR/$folder-*

    meson _build --prefix=$PREFIX
    ninja -C _build
    ninja -C _build install

    cd $LFS
    rm -rf $BUILD_DIR/$folder-*
done

# 3. WINE 설치
echo "3. WINE 설치 중..."
WINE_VERSION="8.0.2"
wget -q https://dl.winehq.org/wine/source/8.x/wine-${WINE_VERSION}.tar.xz -O $SOURCE_DIR/wine-${WINE_VERSION}.tar.xz
tar -xf $SOURCE_DIR/wine-${WINE_VERSION}.tar.xz -C $BUILD_DIR
cd $BUILD_DIR/wine-${WINE_VERSION}

./configure --prefix=$PREFIX
make $MAKEFLAGS
make install

cd $LFS
rm -rf $BUILD_DIR/wine-${WINE_VERSION}

# 4. Google Chrome 설치
echo "4. Google Chrome 소스 다운로드 및 빌드 중..."
CHROMIUM_VERSION="116.0.5845.140"
wget -q https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${CHROMIUM_VERSION}.tar.xz -O $SOURCE_DIR/chromium-${CHROMIUM_VERSION}.tar.xz
tar -xf $SOURCE_DIR/chromium-${CHROMIUM_VERSION}.tar.xz -C $BUILD_DIR
cd $BUILD_DIR/chromium-${CHROMIUM_VERSION}

# Chromium 빌드 설정
mkdir -pv out/Default
gn gen out/Default --args="is_debug=false enable_nacl=false enable_swiftshader=false is_component_build=false symbol_level=0"
ninja -C out/Default chrome

# Chrome 바이너리 설치
cp -v out/Default/chrome /usr/bin/google-chrome

cd $LFS
rm -rf $BUILD_DIR/chromium-${CHROMIUM_VERSION}

# 설치 완료 메시지
echo "설치 완료! 다음 패키지가 성공적으로 설치되었습니다:"
echo "- GNOME"
echo "- WINE"
echo "- Google Chrome"
