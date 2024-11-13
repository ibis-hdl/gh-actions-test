#!/usr/bin/env bash

set -ex

# using docker volumes to store data; fix permissions as it's mounted as
# root on Windows/Docker/WSL
# intentionally not recursive, since volumes are mound-bind by docker
apply_dir() {
    local dir=$1

    echo "[DevContainer] INFO: check for '${dir}'"
    if [ ! -d "${dir}" ]; then
        sudo mkdir ${dir} && chown vscode:vscode "${dir}"
    elif [ $(stat --format '%U' "${dir}") = "root" ]; then
        echo "[DevContainer] INFO: fix 'root' permissions for '${dir}'"
        sudo chown vscode:vscode "${dir}"
    fi
}

# using docker volumes to store data; fix permissions as it's mounted as
# root on Windows/Docker/WSL
# intentionally not recursive, since volumes are mound-bind by docker
fix_volume_permissions() {
    # This script is running as user 'vscode'
    echo "[DevContainer] '${0##*/}' runs as user '${SUDO_USER:-$USER}'"

    if [ $(stat --format '%U' "/workspaces") = "root" ]; then
        echo "[DevContainer] INFO: fix 'root' permissions for workspaces folder"
        sudo chown vscode:vscode /workspaces
    fi

    apply_dir "/home/vscode/.conan2"    # not required, but in case of ...
    apply_dir "/home/vscode/.cache"     # not required, but in case of ...
    apply_dir "/home/vscode/.ssh"
}

fix_volume_permissions
