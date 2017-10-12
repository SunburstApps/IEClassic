function(spec2def _dllname _spec_file)
	get_filename_component(_file ${_dllname} NAME_WE)

	if(NOT ${_spec_file} MATCHES ".*\\.spec$")
		message(FATAL_ERROR "spec2def accepts only *.spec files as output")
	endif()

	if(MSVC OR MSVC_IDE)
		set(_ms_flag --ms)
	endif()

	if(CMAKE_GENERATOR MATCHES "Visual Studio .. .... Win64")
		set(SPEC2DEF_ARCH x86_64)
	elseif(CMAKE_GENERATOR MATCHES "Visual Studio .. .... ARM")
		set(SPEC2DEF_ARCH arm)
	elseif(CMAKE_GENERATOR MATCHES "Visual Studio .. ....")
		set(SPEC2DEF_ARCH i386)
	else()
		message(FATAL_ERROR "Don't know how to extract the target architecture for this generator")
	endif()

	add_custom_command(
		OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${_file}.def ${CMAKE_CURRENT_BINARY_DIR}/${_file}_stubs.c
		COMMAND $<TARGET_FILE:spec2def> ${_ms_flag} -a=${SPEC2DEF_ARCH} -n=${_dllname} -d=${CMAKE_CURRENT_BINARY_DIR}/${_file}.def -s=${CMAKE_CURRENT_BINARY_DIR}/${_file}_stubs.c ${_spec_file}
		DEPENDS ${_spec_file} spec2def)
endfunction()
