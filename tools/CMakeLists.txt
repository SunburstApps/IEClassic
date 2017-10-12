add_executable(spec2def spec2def.c)
target_compile_definitions(spec2def PRIVATE _CRT_SECURE_NO_WARNINGS)
set_target_properties(spec2def PROPERTIES FOLDER "Build-Time Tools")

