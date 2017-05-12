cmake_minimum_required(VERSION 3.7)
project(bit_board)

include_directories(/usr/lib/erlang/erts-8.3/include)

set(CMAKE_C_STANDARD 11)

set(CMAKE_CXX_FLAGS_DEBUG "-O3")
set(CMAKE_C_FLAGS_DEBUG "-O3")

set(SOURCE_FILES nifs.c nifs.h board.c board.h algorithm.c algorithm.h)
add_library(bit_board SHARED ${SOURCE_FILES})