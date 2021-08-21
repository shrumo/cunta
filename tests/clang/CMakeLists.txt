cmake_minimum_required(VERSION 3.13.4)
project(clang_test)
include(../../cunta.cmake)

find_package(Clang)

add_executable(run run.cpp)

target_include_directories(run PRIVATE ${CLANG_INCLUDE_DIRS})
target_link_libraries(run libclang)
