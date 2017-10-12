include(CMakeParseArguments)

function(spec2def _dllname _spec_file)
	get_filename_component(_file ${_dllname} NAME_WE)

	if(NOT ${_spec_file} MATCHES ".*\\.spec$")
		message(FATAL_ERROR "spec2def accepts only *.spec files as output")
	endif()

	if(MSVC OR MSVC_IDE)
		set(_ms_flag --ms)
	endif()

	if(CMAKE_SIZEOF_VOID_P EQUALS 8)
		set(SPEC2DEF_ARCH x86_64)
	else()
		set(SPEC2DEF_ARCH i386)
	endif()

	add_custom_command(
		OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${_file}.def ${CMAKE_CURRENT_BINARY_DIR}/${_file}_stubs.c
		COMMAND $<TARGET_FILE:spec2def> ${_ms_flag} -a=${SPEC2DEF_ARCH} -n=${_dllname} -d=${CMAKE_CURRENT_BINARY_DIR}/${_file}.def -s=${CMAKE_CURRENT_BINARY_DIR}/${_file}_stubs.c ${_spec_file}
		DEPENDS ${_spec_file} spec2def
		COMMENT "Running spec2def" VERBATIM)
endfunction()

function(target_add_manifest target)
	cmake_parse_arguments(_mt "ENABLE_VISUAL_THEMES;ENABLE_HIDPI_SUPPORT;ENABLE_VERSIONING;ENABLE_UAC_ASINVOKER" "" "ADDITIONAL_FRAGMENTS" ${ARGN})
	set(tools_dir ${IECLASSIC_SOURCE_DIR}/tools)

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
	if(_mt_ENABLE_UAC_ASINVOKER)
		list(APPEND _manifest_files "${tools_dir}/manifests/uac_as_invoker.manifest")
	endif()

	list(LENGTH _manifest_files manifest_file_count)
	if(manifest_file_count EQUAL 0)
		message(AUTHOR_WARNING "No manifest files specified, target_add_manifest() won't do anything")
	else()
		add_custom_command(TARGET ${target} POST_BUILD
			COMMAND mt.exe -nologo -manifest ${_manifest_files} -outputresource:$<TARGET_FILE:${target}> -canonicalize
			DEPENDS ${_manifest_files} ${target}
			COMMENT "Adding manifest resource" VERBATIM)
	endif()
endfunction()
