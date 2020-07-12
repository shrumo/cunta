cmake_minimum_required(VERSION 3.14)

project(cunta_fmt_fetch_test)
include(../../cunta.cmake)
find_or_fetch_package(fmt 7.0.1)

add_executable(test test.cpp)
target_link_libraries(test fmt)
