spec2def(ieclassic_cryptui.dll cryptui.spec)

set(SOURCE
	cryptui.c
	cryptui.rc
	resource.h

	${CMAKE_CURRENT_BINARY_DIR}/ieclassic_cryptui_stubs.c
	${CMAKE_CURRENT_BINARY_DIR}/ieclassic_cryptui.def
)

add_library(ieclassic_cryptui SHARED ${SOURCE})
target_link_libraries(ieclassic_cryptui wine_support)
target_link_libraries(ieclassic_cryptui uuid.lib urlmon.lib wintrust.lib user32.lib ole32.lib crypt32.lib gdi32.lib advapi32.lib comctl32.lib comdlg32.lib kernel32.lib ntdll.lib)
target_compile_definitions(ieclassic_cryptui PRIVATE _CRT_SECURE_NO_WARNINGS)
