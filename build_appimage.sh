#!/bin/bash
set -euo pipefail

cd `dirname ${BASH_SOURCE[0]}`
SHELL_FOLDER=$(pwd)

ARCH=$(uname  -m)
echo -e "CPU Archicture: \033[32m$ARCH\033[0m"

# update base image
docker pull quay.io/pypa/manylinux2014_${ARCH}:latest


# Build the AppImage
python3 -m python_appimage build manylinux \
    2014_${ARCH} \
    cp37-cp37m

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
