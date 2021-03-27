cmake_minimum_required(VERSION 3.11)

project(cunta_fmt_as_submodule_test)
include(../../cunta.cmake)
find_or_fetch_package(fmt 7.0.1)

add_executable(run run.cpp)
target_link_libraries(run fmt)
