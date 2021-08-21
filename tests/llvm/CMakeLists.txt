cmake_minimum_required(VERSION 3.13.4)
project(llvm_test)
include(../../cunta.cmake)

find_or_fetch_package(LLVM)

add_executable(run run.cpp)

# Find the libraries that correspond to the LLVM components
# that we wish to use
llvm_map_components_to_libnames(llvm_libs support core irreader)

# Link against LLVM libraries
target_link_libraries(run ${llvm_libs})
