cmake_minimum_required(VERSION 3.8.0)
set(CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION 10.0.15063.0)
project(REACTOS_INTERNET_EXPLORER)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
add_subdirectory(tools)
include(tools/tools.cmake)

# Enable the Unicode (WCHAR-based) APIs on all product code.
add_definitions(-DUNICODE)

add_subdirectory(libs)
