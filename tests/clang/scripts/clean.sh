#!/bin/bash


PROJECT_SOURCE_DIR="$(pwd)/${0%/*}/.."

# Erase everything connected to git
rm -rf ${PROJECT_SOURCE_DIR}/build
rm -rf ${PROJECT_SOURCE_DIR}/.git
rm -f ${PROJECT_SOURCE_DIR}/.gitmodules
rm -rf ${PROJECT_SOURCE_DIR}/extern
