cmake_minimum_required(VERSION 3.8.0)
project(IECLASSIC)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
add_subdirectory(tools)
include(tools/tools.cmake)

# Enable the Unicode (WCHAR-based) APIs on all product code.
add_definitions(-DUNICODE)

# Add the architecture-specific #defines that the Windows SDK expects.
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	add_definitions(-D_AMD64_)
else()
	add_definitions(-D_X86_)
endif()

add_subdirectory(libs)
add_subdirectory(app)
