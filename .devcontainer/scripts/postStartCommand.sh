#!/usr/bin/env bash

set -ex

install_conan() {
    python3 -m pip install --upgrade pip
    pip3 --disable-pip-version-check --no-cache-dir install conan
}

configure_conan() {
    # create compiler preset for Conan2
    CXX=clang++ conan profile detect --force --name clang
    CXX=g++ conan profile detect --force --name gcc
    conan profile detect --force --name default
    # special for libc++
    CXX=clang++ conan profile detect --force --name clang-libc++
    sed -i ~/.conan2/profiles/clang-libc++ -E \
        -e "s|^(compiler\.cppstd\s*)=(.*)$|\1=17|g" \
        -e "s|^(compiler\.libcxx\s*)=(.*)$|\1=libc++|g"

}

conan_install() {
    # apply project's Conan2 recipe for Release, Debug build
    conan install . --settings=compiler.cppstd=17 -s build_type=Release --output-folder build/conan --build=missing
    conan install . --settings=compiler.cppstd=17 -s build_type=Debug   --output-folder build/conan --build=missing
    # special for libc++
    CXX=clang++ conan install . -s compiler.cppstd=17 --output-folder build/conan --build=missing --profile:all=clang-libc++
}

install_conan
configure_conan
conan_install
