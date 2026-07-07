#!/usr/bin/env bash
set -e

make -S . -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_DOCKER_GENERATOR=RPM

cmake --build build --config Release --target install
cpack -C Release -G RPM
echo "$GPG_KEY" | gpg --import
KEY_ID=$(gpg --list-secret-keys --keyid-format LONG | awk '/sec/{print $2}' | cut -d'/' -f2)
rpm --addsign --define "_gpg_name $KEY_ID" $OUT_PATH/*.rpm
