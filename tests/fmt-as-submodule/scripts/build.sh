#!/bin/bash


PROJECT_SOURCE_DIR="$(pwd)/${0%/*}/.."

# Cleanup after previous
rm -rf ${PROJECT_SOURCE_DIR}/.git
rm -f ${PROJECT_SOURCE_DIR}/.gitmodules

set -e # Exit if any command is non zero return value
rm -rf ${PROJECT_SOURCE_DIR}/extern/fmt
rm -rf build

# This handles all the git stuff separately
cd ${PROJECT_SOURCE_DIR}
git init

# Setup the submodule
cd ${PROJECT_SOURCE_DIR}/extern
git submodule add https://github.com/fmtlib/fmt.git

# Build the thing
cd ${PROJECT_SOURCE_DIR}
mkdir build
cd build
cmake ..
make -j4

# Erase everything connected to git
rm -rf ${PROJECT_SOURCE_DIR}/.git
rm -f ${PROJECT_SOURCE_DIR}/.gitmodules
rm -rf ${PROJECT_SOURCE_DIR}/extern/fmt
