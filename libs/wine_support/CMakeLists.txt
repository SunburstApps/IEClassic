set(SOURCE
	wine/debug.h
	wine/debug.c
	wine/registrar.h
	wine/registrar.cpp
	wine/stubs.h
)

add_library(wine_support STATIC ${SOURCE})
target_include_directories(wine_support PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_compile_definitions(wine_support PRIVATE _CRT_SECURE_NO_WARNINGS)
set_target_properties(wine_support PROPERTIES FOLDER "Support Libraries")
