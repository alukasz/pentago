cmake_minimum_required(VERSION 3.7)
project(pentago)

include_directories(/usr/lib/erlang/erts-8.3/include)

set(CMAKE_C_STANDARD 11)

set(CMAKE_CXX_FLAGS_DEBUG "-O3")
set(CMAKE_C_FLAGS_DEBUG "-O3")

set(SOURCE_FILES board.c board.h nifs.c nifs.h evaluation.c evaluation.h algorithm.c algorithm.h)
add_library(pentago SHARED ${SOURCE_FILES})