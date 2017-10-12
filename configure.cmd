@echo off
setlocal enabledelayedexpansion

REM Does the user need help?
if /I "%1" == "help" goto help
if /I "%1" == "/?" (
:help
    echo Help for configure script
    echo Syntax: path\to\source\configure.cmd [script-options] [cmake-options]
    echo Available script-options: VSSolution, VSSolution-x64, NMake
    echo cmake-options: -DVARIABLE:TYPE=VALUE
    goto quit
)

REM Detect presence of cmake
cmd /c cmake --version 2>&1 | find "cmake version" > NUL || goto cmake_notfound

REM Parse command-line parameters
set CMAKE_GENERATOR=Ninja
set BUILD_DIR_NAME=output-i386

:next_arg
if /I "%1" == "VSSolution" (
    set CMAKE_GENERATOR="Visual Studio 15 2017"
    set BUILD_DIR_NAME=output-i386-VS
) else if /I "%1" == "VSSolution-x64" (
    set CMAKE_GENERATOR="Visual Studio 15 2017 Win64"
    set BUILD_DIR_NAME=output-x64-VS
) else if /I "%1" == "NMake" (
    set CMAKE_GENERATOR="NMake Makefiles"
    set BUILD_DIR_NAME=output-i386-nmake
) else (
    goto end_arg_processing
)

shift
goto next_arg

:end_arg_processing

set PROJECT_SOURCE_DIR=%~dp0
cd %PROJECT_SOURCE_DIR%
mkdir %BUILD_DIR_NAME%
cd %BUILD_DIR_NAME%

cmake -G %CMAKE_GENERATOR% %* "%PROJECT_SOURCE_DIR%"
goto :quit

:cmake_notfound
echo Cannot find CMake. If it is installed, check your PATH variable.
exit /b 1

:quit
endlocal
exit /b 0
