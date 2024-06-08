#!/bin/bash

help() {
    echo "Usage: $0 <arch> [--list]"
    echo ""
    echo "Supported architectures:" 
    echo "  • armv7l - Mostly used in IoT devices"
    echo "  • aarch64 - Most used in SBCs and phones"
    echo "  • i386 - Most common 32-bit architecture"
    echo "  • x86_64 - Most common 64-bit architecture"
    echo "  • ppc64le - Used in IBM Power Systems"
    echo "  • mips64 - Used in routers and IoT devices"
    exit 0
}

if [ "$#" -ne 1 ]; then
    help
    exit 1
fi

ARCH=$1

run_docker() {
    echo -e "\e[34mBuilding for $ARCH...\e[0m\c"

    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes > /dev/null 2>&1

    docker run --platform $1 --rm -t -v $(pwd):/root/ $2 /bin/bash -c "apt -qq update; \
    apt -qq install gcc zlib1g-dev -y; \
    pip3 -q install --upgrade pip; \
    pip3 install psutil colored py-cpuinfo requests pyinstaller; \
    pyinstaller /root/src/main.py --distpath /root/ --onefile --clean --hidden-import py-cpuinfo --hidden-import colored --hidden-import psutil --hidden-import requests > /dev/null; \
    mv /root/main /root/main-$ARCH"

    if [ $? -ne 0 ]; then
        echo -e "[\e[31mERROR\e[0m] Build failed"
        exit 1
    fi

    echo -e "[\e[32mOK\e[0m] Build completed successfully"
    rm -rf ./.cache
}

if [ "$1" = "--list" ]; then
    help
fi

case $ARCH in
    "x86_64") run_docker "linux/amd64" "amd64/python:3.6-jessie" ;;
    "i386") run_docker "linux/i386" "i386/python:3.6-jessie" ;;
    "armv7l") run_docker "linux/arm" "arm32v7/python:3.6-jessie" ;;
    "aarch64") run_docker "linux/arm64" "arm64v8/python:3.6-jessie" ;;
    "ppc64le") run_docker "linux/ppc64le" "ppc64le/python:3.6-jessie" ;;
    "mips64") run_docker "linux/mips64le" "mips64le/python:3.9.0a5-buster" ;;
    *) help;;
esac
