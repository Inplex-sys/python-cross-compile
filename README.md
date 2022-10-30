# Python Cross Compile

## Getting Started
 - You need to have docker installed
 - You need an internet connection

```sh
wget https://raw.githubusercontent.com/Inplex-sys/python-cross-compile/main/main.sh; chmod +x ./main.sh
```

Let's see what is archs are usable with the script `bash ./main.sh --config`.
```sh
$ bash ./main.sh --archs
Supported architectures: armv7, aarch64, i386, x86_64, ppc64le, mips64l
```

```sh
$ bash ./main.sh --archs
Supported architectures: armv7, aarch64, i386, x86_64, ppc64le, mips64l
```

How it work
```sh
$ bash ./main.sh --help
Usage: ./main.sh <arch> <pastebin/other> [--archs --help]
```
