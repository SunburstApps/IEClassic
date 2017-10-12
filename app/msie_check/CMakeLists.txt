set(SOURCE
	msie_check.h
	msie_check.cpp
)

add_library(msie_check ${SOURCE})
target_include_directories(msie_check PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
set_target_properties(msie_check PROPERTIES FOLDER "Product Code")
