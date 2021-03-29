cmake_minimum_required(VERSION 3.11.4)
  
project(face-grammar)
include(cmake/cunta.cmake)

find_or_fetch_package(owl)

owl_generate_header(face.owl)

add_executable(run run.c face.owl.h)
