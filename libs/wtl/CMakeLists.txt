set(SOURCE
	atlapp.h
	atlcrack.h
	atlctrls.h
	atlctrlw.h
	atlctrlx.h
	atlddx.h
	atldlgs.h
	atldwm.h
	atlfind.h
	atlframe.h
	atlgdi.h
	atlmisc.h
	atlprint.h
	atlres.h
	atlribbon.h
	atlscrl.h
	atlsplit.h
	atltheme.h
	atluser.h
	atlwinx.h
	wtl.cpp
)

add_library(wtl STATIC ${SOURCE})
target_include_directories(wtl PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
set_target_properties(wtl PROPERTIES FOLDER "Static Libraries")
