#!/bin/bash

PROJECT_SOURCE_DIR="$(pwd)/${0%/*}/.."

# This handles all the git stuff separately
cd ${PROJECT_SOURCE_DIR}
git init

# Setup the submodule
mkdir -p ${PROJECT_SOURCE_DIR}/extern
cd ${PROJECT_SOURCE_DIR}/extern
git submodule add https://github.com/fmtlib/fmt.git

# Build the thing
cd ${PROJECT_SOURCE_DIR}
mkdir -p build
cd build
cmake ..
make -j4
