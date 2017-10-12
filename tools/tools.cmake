include(CMakeParseArguments)

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

function(target_add_manifest target)
	cmake_parse_arguments(_mt "ENABLE_VISUAL_THEMES;ENABLE_HIDPI_SUPPORT;ENABLE_VERSIONING" "" "ADDITIONAL_FRAGMENTS" ${ARGN})
	set(tools_dir ${REACTOS_INTERNET_EXPLORER_SOURCE_DIR}/tools)

	set(_manifest_files ${_mt_ADDITIONAL_FRAGMENTS})
	if(_mt_ENABLE_VISUAL_THEMES)
		list(APPEND _manifest_files "${tools_dir}/manifests/visual_themes.manifest")
	endif()
	if(_mt_ENABLE_HIDPI_SUPPORT)
		list(APPEND _manifest_files "${tools_dir}/manifests/hidpi_support.manifest")
	endif()
	if(_mt_ENABLE_VERSIONING)
		list(APPEND _manifest_files "${tools_dir}/manifests/versioning.manifest")
	endif()

	list(LENGTH _manifest_files manifest_file_count)
	if(manifest_file_count EQUAL 0)
		message(AUTHOR_WARNING "No manifest files specified, target_add_manifest() won't do anything")
	else()
		add_custom_command(TARGET ${target} POST_BUILD
			COMMAND mt.exe -nologo -manifest ${_manifest_files} -outputresource:$<TARGET_FILE:${target}> -canonicalize
			DEPENDS ${_manifest_files} ${target})
	endif()
endfunction()
