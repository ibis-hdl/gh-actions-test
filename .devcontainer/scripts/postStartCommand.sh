#!/usr/bin/env bash

set -ex

install_conan() {
    python3 -m pip install --upgrade pip
    pip3 --disable-pip-version-check --no-cache-dir install conan
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

configure_conan() {
    # create default compiler preset for Conan2
    conan profile detect --force --name default

    # create compiler preset for Conan2
    local profile=gcc
    CXX=g++ conan profile detect --force --name ${profile}
    cat << EOF  >> ~/.conan2/profiles/${profile}
$(conan_buildenv_conf 'gcc' 'g++')
EOF
    cat ~/.conan2/profiles/${profile}

    # create compiler preset for Conan2
    local profile=clang
    CXX=clang++ conan profile detect --force --name ${profile}
    cat << EOF  >> ~/.conan2/profiles/${profile}
$(conan_buildenv_conf 'clang' 'clang++')
EOF
    cat ~/.conan2/profiles/${profile}

    # # create compiler preset for Conan2 with special for libc++
    local profile=clang-libc++
    CXX=clang++ conan profile detect --force --name ${profile}
    sed -i ~/.conan2/profiles/${profile} -E \
        -e "s|^(compiler\.libcxx\s*)=(.*)$|\1=libc++|g"
    cat << EOF  >> ~/.conan2/profiles/${profile}
$(conan_buildenv_conf 'clang' 'clang++')
EOF
    cat ~/.conan2/profiles/${profile}
}

conan_install() {
    # apply project's Conan2 recipe for Release, Debug build
    conan install . -s build_type=Release --output-folder build/conan --build=missing --profile:all=default
    conan install . -s build_type=Debug   --output-folder build/conan --build=missing --profile:all=default
    # special for libc++
    conan install . -s build_type=Release --output-folder build/conan --build=missing --profile:all=clang-libc++
}

install_conan
configure_conan
conan_install
