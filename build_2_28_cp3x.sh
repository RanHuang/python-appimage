#!/bin/bash
##
# https://github.com/niess/python-appimage/blob/master/.github/workflows/appimage.yml
## 
set -euo pipefail

cd `dirname ${BASH_SOURCE[0]}`
SHELL_FOLDER=$(pwd)

# set version
if [ $# -gt 0 ]; then
    version=$1
else
    version=37
fi
if [ $version -gt 37 ]; then
    version=cp${version}-cp${version}
else
    version=cp${version}-cp${version}m
fi
echo -e "Python Version: \033[32m$version\033[0m"

ARCH=$(uname  -m)
echo -e "CPU Archicture: \033[32m$ARCH\033[0m"

# update base image
docker pull quay.io/pypa/manylinux_2_28_${ARCH}:latest

rm -f python*.AppImage

# Build the AppImage
python3 -m python_appimage build manylinux \
    2_28_${ARCH} \
    $version

# Export the AppImage name and the Python version
appimage=$(ls python*.AppImage)
SCRIPT=$(cat <<-END
version = '${appimage}'[6:].split('.', 2)
print('{:}.{:}'.format(*version[:2]))
END
)
version=$(python -c "${SCRIPT}")

echo "::set-env name=PYTHON_APPIMAGE::${appimage}"
echo "::set-env name=PYTHON_VERSION::${version}"
