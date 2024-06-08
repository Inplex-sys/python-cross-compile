# Python Multi-Architecture Docker Build Script

This script is designed to facilitate the building of Docker images across multiple architectures, including but not limited to armv7l, aarch64, i386, x86_64, ppc64le, and mips64. It leverages the power of Docker and QEMU to emulate different architectures, allowing developers to compile and package applications for architectures different from the host machine. This is particularly useful for creating cross-platform applications that need to run on a variety of hardware configurations.

## How It Works

The script operates by using Docker's ability to run containers with different CPU architectures than the host machine, thanks to QEMU user static binaries. This is achieved through the `multiarch/qemu-user-static` Docker image, which sets up the necessary emulation environment.

## Help
```sh
Usage: builder.sh <arch> <entrypoint> [--list] [--imports import1,import2,...]

Supported architectures:
  • armv7l - Mostly used in IoT devices
  • aarch64 - Most used in SBCs and phones
  • i386 - Most common 32-bit architecture
  • x86_64 - Most common 64-bit architecture
  • ppc64le - Used in IBM Power Systems
  • mips64 - Used in routers and IoT devices
```

### Step-by-Step Operation

The script is designed for cross-compiling Python projects for different architectures using Docker and QEMU. Here's a breakdown of how it works:

1. **Help Function**: Displays usage information and lists supported architectures. It's called if the user inputs incorrect arguments or requests it.

2. **Argument Validation**: Checks if the correct number of arguments is provided. If not, it displays the help message and exits.
The script allows for cross-compiling Python projects for different architectures using Docker and QEMU. A key feature is the ability to specify additional Python imports to include in the compilation process through the --imports option. This option takes a comma-separated list of Python modules that should be included as hidden imports by PyInstaller, enhancing the flexibility of the script for various project dependencies.

3. **Set Architecture Variable**: Stores the first argument, which specifies the target architecture, in the `ARCH` variable.

4. **Run Docker Function (`run_docker`)**: This is the core function that performs the cross-compilation:
   - **QEMU Setup**: Uses the `multiarch/qemu-user-static` Docker image to enable emulation for the specified architecture. This allows running binaries for that architecture on the host machine.
   - **Docker Container Setup**: Runs a Docker container with the specified architecture. It mounts the current directory to the container, allowing access to the Python project files.
   - **Build Environment Setup**: Inside the container, updates package lists, installs necessary build dependencies (like `gcc` and `zlib1g-dev`), and sets up Python with required packages (`psutil`, `colored`, `py-cpuinfo`, `requests`, `pyinstaller`).
   - **Cross-Compilation**: Uses PyInstaller to compile the Python project (`/root/src/main.py`) into a standalone executable. The `--hidden-import` options ensure that PyInstaller includes these modules in the executable. The output executable is named according to the target architecture.
   - **Error Handling**: Checks if the build process was successful. If not, it prints an error message and exits.

5. **Architecture-Specific Docker Image Selection**: Based on the specified architecture, selects the appropriate Docker image for the Python environment. This ensures that the build environment matches the target architecture.

6. **Cleanup**: Removes any residual cache files after a successful build.

7. **Architecture Handling**: Uses a case statement to handle different architectures. For each architecture, it calls `run_docker` with the appropriate Docker image and platform arguments.

This script automates the process of setting up a cross-compilation environment using Docker and QEMU, compiling a Python project into a standalone executable for different architectures. It abstracts away the complexities of cross-compilation, making it accessible for developers to build their Python applications for various hardware platforms.
