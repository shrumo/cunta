cmake_minimum_required(VERSION 3.11)

project(cunta_bgfx_test)
include(cmake/cunta.cmake)
find_or_fetch_package(bgfx)
find_or_fetch_package(glfw3)

add_executable(run run.cpp)
target_link_libraries(run bgfx glfw)
