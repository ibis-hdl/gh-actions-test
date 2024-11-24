#!/usr/bin/env bash

set -ex

install_conan() {
    # cope with python3's pip error: externally-managed-environment on creating venv
    pipx install conan
}

# helper to adjust concrete compiler to be used
conan_buildenv_conf()
{
    local CC=$1
    local CXX=$2
    cat << EOF

[buildenv]
CC=$CC
CXX=$CXX

[conf]
tools.build:compiler_executables={ "c": "$(which $CC)", "cpp": "$(which $CXX)" }
EOF
}

configure_conan_profile() {
    # create default compiler preset for Conan2
    local conan_profile=default
    conan profile detect --force --name ${conan_profile}

    # create GCC compiler preset for Conan2
    local conan_profile=gcc
    CXX=g++ conan profile detect --force --name ${conan_profile}
    cat << EOF  >> ~/.conan2/profiles/${conan_profile}
$(conan_buildenv_conf 'gcc' 'g++')
EOF
    cat ~/.conan2/profiles/${conan_profile}

    # create Clang compiler preset for Conan2
    local conan_profile=clang
    CXX=clang++ conan profile detect --force --name ${conan_profile}
    cat << EOF  >> ~/.conan2/profiles/${conan_profile}
$(conan_buildenv_conf 'clang' 'clang++')
EOF
    cat ~/.conan2/profiles/${conan_profile}

    # create Clang-libc++ compiler preset for Conan2
    local conan_profile=clang-libc++
    CXX=clang++ conan profile detect --force --name ${conan_profile}
    sed -i ~/.conan2/profiles/${conan_profile} -E \
        -e "s|^(compiler\.libcxx\s*)=(.*)$|\1=libc++|g"
    cat << EOF  >> ~/.conan2/profiles/${conan_profile}
$(conan_buildenv_conf 'clang' 'clang++')
EOF
    cat ~/.conan2/profiles/${conan_profile}
}

# Fixme: use conan presets
# - https://docs.conan.io/2/examples/tools/cmake/cmake_toolchain/extend_own_cmake_presets.html
# - https://docs.conan.io/2/examples/tools/cmake/cmake_toolchain/build_project_cmake_presets.html
# => conan_install
# Linux
# conan install .
# conan install . -s build_type=Debug
# cmake --preset release
# cmake --build --preset release
# cmake --preset debug
# cmake --build --preset debug
#
# Windows
# conan install .
# conan install . -s build_type=Debug
# cmake --preset default"
# cmake --build --preset multi-release"
# cmake --build --preset multi-debug"
#
conan_install()
{
    local conan_profile=$1
    local cmake_presets=$2

    conan install . -s build_type=Release --output-folder build/${cmake_presets} --build=missing --profile:all=${conan_profile}
    conan install . -s build_type=Debug   --output-folder build/${cmake_presets} --build=missing --profile:all=${conan_profile}
}

conan_install2() {
    local build_type=release

    local conan_profile=default
    local cmake_presets=default

    local conan_profile=gcc
    local cmake_presets=linux-gcc-${build_type}

    local conan_profile=clang
    local cmake_presets=linux-clang-${build_type}

    local conan_profile=clang-libc++
    local cmake_presets=linux-clang-libc++-${build_type}

    conan_install ${conan_profile} ${cmake_presets}


    # apply project's Conan2 recipe for Release, Debug build
    #conan install . -s build_type=Release --output-folder build/conan --build=missing --profile:all=default
    #conan install . -s build_type=Debug   --output-folder build/conan --build=missing --profile:all=default
    # special for libc++
    #conan install . -s build_type=Release --output-folder build/conan --build=missing --profile:all=clang-libc++
}

install_conan
configure_conan_profile
