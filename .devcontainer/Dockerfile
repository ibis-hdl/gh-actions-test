# https://github.com/devcontainers/images/tree/main/src/cpp
ARG VARIANT="ubuntu-24.04"
FROM mcr.microsoft.com/vscode/devcontainers/cpp:${VARIANT}

# [Optional] Install CMake version different from what base image has already installed.
# CMake reinstall choices: none, 3.21.5, 3.22.2, or versions from https://cmake.org/download/
#ARG REINSTALL_CMAKE_VERSION_FROM_SOURCE="3.23.1"

# Optionally install the cmake for vcpkg
COPY ./scripts/reinstall-cmake.sh /tmp/
RUN if [ "${REINSTALL_CMAKE_VERSION_FROM_SOURCE}" != "none" ]; then \
        chmod +x /tmp/reinstall-cmake.sh && /tmp/reinstall-cmake.sh ${REINSTALL_CMAKE_VERSION_FROM_SOURCE}; \
    fi \
    && rm -f /tmp/reinstall-cmake.sh

# [Optional] Uncomment this section to install additional vcpkg ports.
# RUN su vscode -c "${VCPKG_ROOT}/vcpkg install <your-port-name-here>"

# [Optional] Uncomment this section to install additional packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends ccache git g++ clang clang-tools clang-format clang-tidy libc++-dev doxygen python3 python3-venv
