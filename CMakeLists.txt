cmake_minimum_required(VERSION 3.8.0)
project(REACTOS_INTERNET_EXPLORER)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
add_subdirectory(tools)
include(tools/tools.cmake)

add_subdirectory(libs)
