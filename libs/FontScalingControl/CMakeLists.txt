set(SOURCE
	FontScalingControl.h
	FontScalingControl.cpp
)

add_library(FontScalingControl STATIC ${SOURCE})
target_include_directories(FontScalingControl PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
