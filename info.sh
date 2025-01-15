#!/bin/bash

sudo apt-get update

# 필수 빌드 도구 및 유틸리티
sudo apt-get install -y \
    build-essential       \ # 컴파일 도구 (gcc, g++, make 등)
    wget                  \ # 파일 다운로드
    curl                  \ # HTTP 요청
    git                   \ # 소스 제어 도구
    tar                   \ # 압축 해제 도구
    xz-utils              \ # .xz 파일 처리

# 빌드 시스템 관련 패키지
sudo apt-get install -y \
    meson                \ # 빌드 시스템 (GNOME 관련)
    ninja-build          \ # 빌드 가속 도구
    cmake                \ # CMake 빌드 시스템
    pkg-config           \ # 빌드 시 패키지 정보 제공

# X11 및 Wayland 지원 라이브러리
sudo apt-get install -y \
    libx11-dev           \ # X11 기본 라이브러리
    libxext-dev          \ # X11 확장 라이브러리
    libxi-dev            \ # X Input Extension
    libxrandr-dev        \ # X RandR Extension
    libxinerama-dev      \ # Xinerama Extension
    libxcursor-dev       \ # X Cursor Extension
    libwayland-dev       \ # Wayland 개발 라이브러리

# 그래픽 및 GUI 관련 라이브러리
sudo apt-get install -y \
    libgl1-mesa-dev      \ # OpenGL
    libglu1-mesa-dev     \ # OpenGL 유틸리티
    libcairo2-dev        \ # Cairo 벡터 그래픽 라이브러리
    libgdk-pixbuf2.0-dev \ # GDK 픽셀 버퍼
    libatk1.0-dev        \ # ATK 접근성 도구
    libpango1.0-dev      \ # Pango 텍스트 렌더링
    libgtk-3-dev         \ # GTK+ 3 개발 도구
    libgstreamer1.0-dev  \ # GStreamer 미디어 프레임워크
    libgstreamer-plugins-base1.0-dev # GStreamer 기본 플러그인

# 네트워크 및 압축 라이브러리
sudo apt-get install -y \
    libssl-dev           \ # OpenSSL 개발 라이브러리
    zlib1g-dev           \ # Zlib 압축 라이브러리
    libxml2-dev          \ # XML 파싱 라이브러리
    libfreetype6-dev     \ # TrueType 폰트 렌더링
    libpng-dev           \ # PNG 이미지 처리
    libjpeg-dev          \ # JPEG 이미지 처리

# 추가 유틸리티
sudo apt-get install -y \
    dbus-x11            \ # D-Bus 메시징 시스템
    yasm                \ # 어셈블러 (WINE에 필요)
    xorg-dev            \ # X.Org 개발 헤더
