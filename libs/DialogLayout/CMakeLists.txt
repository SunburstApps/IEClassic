set(SOURCE
    DialogItemTemplate.cpp
    DialogTemplate.cpp
    DialogLayout.h

    DialogItemTemplate.h
    DialogTemplate.h
    DialogLayout.h
)

add_library(DialogLayout STATIC ${SOURCE})
target_include_directories(DialogLayout PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
