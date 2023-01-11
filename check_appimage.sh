#!/bin/bash
set -euo pipefail

cd `dirname ${BASH_SOURCE[0]}`
SHELL_FOLDER=$(pwd)

app_image=$(ls python*.AppImage)
if [ ! -f $app_image ]; then
    echo "python3.AppImage does not exist"
    exit 1
else
  echo -e "python3.AppImage: \033[32m$app_image\033[0m"
fi

rm -rf squashfs-root

echo "run: AppImage --appimage-extract"
./$app_image --appimage-extract &> /dev/null

echo "-------------Show Python Version------------------------"

export PATH="$(pwd)/squashfs-root/usr/bin:$PATH"
which python3

python3 -V