#!/bin/bash
  
set -e # Exit if any command is non zero return value

PROJECT_SOURCE_DIR="$(pwd)/${0%/*}/.."
cd ${PROJECT_SOURCE_DIR}

cd build
./run
