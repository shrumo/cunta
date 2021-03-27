cmake_minimum_required(VERSION 3.11)

project(cunta_raylib_glm_fmt_test)
include(cmake/cunta.cmake)

find_or_fetch_package(glm)
find_or_fetch_package(raylib)
find_or_fetch_package(fmt)


add_executable(run run.cpp)
target_link_libraries(run PRIVATE glm::glm fmt raylib)
