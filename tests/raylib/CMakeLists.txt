cmake_minimum_required(VERSION 3.11)

project(cunta_raylib_test)
include(cmake/cunta.cmake)
find_or_fetch_package(raylib 3.5.0 REQUIRED)

set(CMAKE_C_STANDARD 11)

add_executable(run run.c)
target_link_libraries(run raylib)
