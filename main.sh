if [ $# -eq 0 ]; then
    echo "Usage: $0 <arch> <pastebin/other> [--archs]"
    exit 1
fi

if [ "$1" = "--archs" ]; then
    echo "Supported architectures: armv7, aarch64, i386, x86_64, ppc64le, mips64le"
    exit 0
fi

if [ $# -ne 2 ]; then
    echo "Usage: $0 <arch> <pastebin/other>"
    exit 1
fi

ARCH=$1
PASTEBIN=$2

if [ $ARCH == "x86_64" ]; then
    docker run --platform linux/amd64 --rm -t amd64/python:3.6-jessie /bin/bash -c "apt update;apt install curl gcc zlib1g-dev -y;cd /root/;curl '$PASTEBIN' > ./\$(uname -m).py;pip3 install --upgrade pip; pip3 install psutil py-cpuinfo requests pyinstaller; pyinstaller /root/\$(uname -m).py --onefile --clean --hidden-import py-cpuinfo --hidden-import psutil --hidden-import requests; ls -al ./; curl -k -F file=@/root/dist/\$(uname -m) https://api.megaupload.nz/upload"
elif [ $ARCH == "i386" ]; then
    docker run --platform linux/i386 --rm -t i386/python:3.6-jessie /bin/bash -c "apt update;apt install curl gcc zlib1g-dev -y;cd /root/;curl '$PASTEBIN' > ./\$(uname -m).py;pip3 install --upgrade pip; pip3 install psutil py-cpuinfo requests pyinstaller; pyinstaller /root/\$(uname -m).py --onefile --clean --hidden-import py-cpuinfo --hidden-import psutil --hidden-import requests; ls -al ./; curl -k -F file=@/root/dist/\$(uname -m) https://api.megaupload.nz/upload"
elif [ $ARCH == "armv7l" ]; then
    docker run --platform linux/arm --rm -t arm32v7/python:3.6-jessie /bin/bash -c "apt update;apt install curl gcc zlib1g-dev -y;cd /root/;curl '$PASTEBIN' > ./\$(uname -m).py;pip3 install --upgrade pip; pip3 install psutil py-cpuinfo requests pyinstaller; pyinstaller /root/\$(uname -m).py --onefile --clean --hidden-import py-cpuinfo --hidden-import psutil --hidden-import requests; ls -al ./; curl -k -F file=@/root/dist/\$(uname -m) https://api.megaupload.nz/upload"
elif [ $ARCH == "aarch64" ]; then
    docker run --platform linux/arm64 --rm -t arm64v8/python:3.6-jessie /bin/bash -c "apt update;apt install curl gcc zlib1g-dev -y;cd /root/;curl '$PASTEBIN' > ./\$(uname -m).py;pip3 install --upgrade pip; pip3 install psutil py-cpuinfo requests pyinstaller; pyinstaller /root/\$(uname -m).py --onefile --clean --hidden-import py-cpuinfo --hidden-import psutil --hidden-import requests; ls -al ./; curl -k -F file=@/root/dist/\$(uname -m) https://api.megaupload.nz/upload"
elif [ $ARCH == "ppc64le" ]; then
    docker run --platform linux/ppc64le --rm -t ppc64le/python:3.6-jessie /bin/bash -c "apt update;apt install curl gcc zlib1g-dev -y;cd /root/;curl '$PASTEBIN' > ./\$(uname -m).py;pip3 install --upgrade pip; pip3 install psutil py-cpuinfo requests pyinstaller; pyinstaller /root/\$(uname -m).py --onefile --clean --hidden-import py-cpuinfo --hidden-import psutil --hidden-import requests; ls -al ./; curl -k -F file=@/root/dist/\$(uname -m) https://api.megaupload.nz/upload"
elif [ $ARCH == "mips64" ]; then
    docker run --platform linux/mips64le --rm -t mips64le/python:3.9.0a5-buster /bin/bash -c "apt update;apt install curl gcc zlib1g-dev -y;cd /root/;curl '$PASTEBIN' > ./\$(uname -m).py;pip3 install --upgrade pip; pip3 install psutil py-cpuinfo requests pyinstaller; pyinstaller /root/\$(uname -m).py --onefile --clean --hidden-import py-cpuinfo --hidden-import psutil --hidden-import requests; ls -al ./; curl -k -F file=@/root/dist/\$(uname -m) https://api.megaupload.nz/upload"
else
    echo "Invalid architecture"
    exit 1
fi