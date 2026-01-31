# Tell CMake we are cross-compiling
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# Where the host SDK. sysroot lives
set(HOST_SYSROOT
    /../../../../linux-devkit/sysroots/x86_64-arago-linux
)

# Where the TI. target SDK. sysroot lives
set(TI_TARGET_SYSROOT
    /../../../../linux-devkit/sysroots/aarch64-oe-linux
)

# Compilers
set(CMAKE_SYSROOT      ${TI_TARGET_SYSROOT})
set(CMAKE_C_COMPILER   ${HOST_SYSROOT}/usr/bin/aarch64-oe-linux/aarch64-oe-linux-gcc)
set(CMAKE_CXX_COMPILER ${HOST_SYSROOT}/usr/bin/aarch64-oe-linux/aarch64-oe-linux-g++)

# Tell CMake where to search
set(CMAKE_FIND_ROOT_PATH ${TI_TARGET_SYSROOT})

# Never use host headers/libs
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Optional but recommended
set(CMAKE_C_STANDARD 17)
set(CMAKE_CXX_STANDARD 20)
