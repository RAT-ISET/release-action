#!/usr/bin/env bash
set -e

rm -rf build

cmake -S . -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_DOCKER_GENERATOR=RPM \
    -DPROJECT_FULL_VERSION=$FULL_VERSION

cmake --build build --config Release --target install
cd build
cpack -C Release -G RPM
