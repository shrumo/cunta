cmake_minimum_required(VERSION 3.11)

project(cunta_fmt_test)
include(cmake/cunta.cmake)
find_or_fetch_package(fmt 7.0.1)

add_executable(run run.cpp)
target_link_libraries(run fmt)
