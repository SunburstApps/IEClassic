set(SOURCE
	wine/registrar.h
	wine/registrar.cpp
	wine/stubs.h
)

add_library(wine_support STATIC ${SOURCE})
target_include_directories(wine_support PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
set_target_properties(wine_support PROPERTIES FOLDER "Support Libraries")
