#!/usr/bin/env bash
set -e

rm -rf build

cmake -S . -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCPACK_DOCKER_GENERATOR=RPM

cmake --build build --config Release --target install
cpack -C Release -G RPM
