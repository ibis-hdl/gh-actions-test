#!/usr/bin/env bash

set -ex

# using docker volumes to store data; fix permissions as it's mounted as
# root on Windows/Docker/WSL
fix_container_permissions() {
    # This script is running as user 'vscode'
    echo "[devcontainer] '${0##*/}' runs as user '${SUDO_USER:-$USER}'"

    if [ ! -d "/home/vscode/.conan2" ]; then
        sudo mkdir /home/vscode/.conan2 && chown -R vscode.vscode /home/vscode/.conan2
    elif [ $(stat --format '%U' "/home/vscode/.conan2") = "root" ]; then
        echo "[DevContainer] INFO: fix 'root' permissions for conan2"
        sudo chown -R vscode.vscode /home/vscode/.conan2
    fi

    if [ ! -d "/home/vscode/.cache" ]; then
        sudo mkdir /home/vscode/.cache && chown -R vscode.vscode /home/vscode/.cache
    elif [ $(stat --format '%U' "/home/vscode/.cache") = "root" ]; then
        echo "[DevContainer] INFO: fix 'root' permissions for ccache"
        sudo chown -R vscode.vscode /home/vscode/.cache
    fi

    if [ $(stat --format '%U' "/workspaces") = "root" ]; then
        echo "[DevContainer] INFO: fix 'root' permissions for workspaces folder"
        # intentionally not recursive, since project is mound-bind by docker
        sudo chown vscode.vscode /workspaces
    fi
}

fix_container_permissions

pip3 --disable-pip-version-check --no-cache-dir install conan

# create compiler preset for Conan2
CXX=clang++ conan profile detect --force --name clang
CXX=g++ conan profile detect --force --name gcc
conan profile detect --force --name default

# apply project's Conan2 recipe for Release, Debug build
conan install . --settings=compiler.cppstd=17 -s "&:build_type=Debug" -s build_type=Release --output-folder build/conan --build=missing
