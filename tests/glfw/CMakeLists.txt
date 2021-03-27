cmake_minimum_required(VERSION 3.11)

project(cunta_glfw3_test)
include(cmake/cunta.cmake)
find_or_fetch_package(glfw3 REQUIRED)

add_executable(run run.cpp)
target_link_libraries(run glfw GLESv2)
