#!/bin/bash
  
PROJECT_SOURCE_DIR="$(pwd)/${0%/*}/.."

set -e
rm -rf ${PROJECT_SOURCE_DIR}/build
rm ${PROJECT_SOURCE_DIR}/*.owl.h
