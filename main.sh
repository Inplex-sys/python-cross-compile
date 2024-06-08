#!/bin/bash

help() {
        echo "Usage: $0 <arch> <entrypoint> [--list] [--imports import1,import2,...]"
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

if [ "$#" -lt 2 ]; then
        help
        exit 1
fi

ARCH=$1
ENTRYPOINT=$2
HIDDEN_IMPORTS=""
IMPORTS=""

# Parse additional arguments
shift 2 # Skip first two arguments
while (( "$#" )); do
    case "$1" in
        --imports)
            IFS=',' read -ra ADDR <<< "$2"
            for i in "${ADDR[@]}"; do
                HIDDEN_IMPORTS+=" --hidden-import $i"
                IMPORTS+=" $i"
            done
            shift 2
            ;;
        --list)
            help
            ;;
        *)
            shift
            ;;
    esac
done

run_docker() {
        echo -e "\e[34mBuilding for $ARCH with entrypoint $ENTRYPOINT and imports $IMPORTS...\e[0m\c"

        docker run --rm --privileged multiarch/qemu-user-static --reset -p yes > /dev/null 2>&1

        ENTRYPOINT_FILE=$(basename $ENTRYPOINT)
        ELF_FILE=$(echo $ENTRYPOINT_FILE | sed 's/.py//g')

        docker run --platform $1 --rm -t -v $(pwd):/root/ $2 /bin/bash -c "apt -qq update 2> /dev/null > /dev/null; \
        apt -qq install gcc zlib1g-dev -y 2> /dev/null > /dev/null; \
        pip3 -q install --upgrade pip; \
        pip3 install pyinstaller $IMPORTS; \
        pyinstaller /root/$ENTRYPOINT --distpath /root/ --onefile --clean $HIDDEN_IMPORTS > /dev/null; \
        mv /root/$ELF_FILE /root/$ENTRYPOINT_FILE-$ARCH"

        if [ $? -ne 0 ]; then
                echo -e "[\e[31mERROR\e[0m] Build failed"
                exit 1
        fi

        echo -e "[\e[32mOK\e[0m] Build completed successfully"
        rm -rf ./.cache
}

case $ARCH in
        "x86_64") run_docker "linux/amd64" "amd64/python:3.6-jessie" ;;
        "i386") run_docker "linux/i386" "i386/python:3.6-jessie" ;;
        "armv7l") run_docker "linux/arm" "arm32v7/python:3.6-jessie" ;;
        "aarch64") run_docker "linux/arm64" "arm64v8/python:3.6-jessie" ;;
        "ppc64le") run_docker "linux/ppc64le" "ppc64le/python:3.6-jessie" ;;
        "mips64") run_docker "linux/mips64le" "mips64le/python:3.9.0a5-buster" ;;
        *) help;;
esac
