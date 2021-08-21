#!/bin/bash

PROJECT_SOURCE_DIR="$(pwd)/${0%/*}/.."

# This handles all the git stuff separately
cd ${PROJECT_SOURCE_DIR}
git init

# Build the thing
cd ${PROJECT_SOURCE_DIR}
mkdir -p build
cd build
cmake ..
make -j4
