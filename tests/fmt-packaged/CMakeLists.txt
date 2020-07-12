cmake_minimum_required(VERSION 3.14)

project(cunta_fmt_packaged_test)
include(../../cunta.cmake)
find_or_fetch_package(fmt 6.1.2)

add_executable(test test.cpp)
target_link_libraries(test fmt)
