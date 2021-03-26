cmake_minimum_required(VERSION 3.11.4)

project(cunta_protobuf_packaged_test)
include(cmake/cunta.cmake)
find_or_fetch_package(Protobuf REQUIRED)

protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS greeting.proto)

# We need to search for pb.h objects in binary dir
include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_executable(run run.cpp ${PROTO_SRCS} ${PROTO_HDRS})
target_link_libraries(run protobuf::libprotobuf)
