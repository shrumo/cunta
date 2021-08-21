#!/bin/bash

set -e # Exit if any command is non zero return value

PROJECT_SOURCE_DIR="$(pwd)/${0%/*}/.."
cd ${PROJECT_SOURCE_DIR}

cd build
echo "def foo (x y) x+foo(y, 4.0);" | ./run
