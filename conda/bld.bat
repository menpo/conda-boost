@echo off

mkdir build
cd build

rem Need to handle Python 3.x case at some point (Visual Studio 2010)
if %ARCH%==32 (
  if %PY_VER% LSS 3 (
    set CMAKE_GENERATOR="Visual Studio 9 2008"
    set CMAKE_CONFIG="Release|Win32"
  )
)
if %ARCH%==64 (
  if %PY_VER% LSS 3 (
    set CMAKE_GENERATOR="Visual Studio 9 2008 Win64"
    set CMAKE_CONFIG="Release|x64"
  )
)

cmake .. -G%CMAKE_GENERATOR% ^
 -DBUILD_SHARED_LIBS=1 ^
 -DINCLUDE_INSTALL_DIR=%LIBRARY_INC% ^
 -DLIB_INSTALL_DIR=%LIBRARY_LIB% ^
 -DBIN_INSTALL_DIR=%LIBRARY_BIN% ^
 -DLIB_SUFFIX= ^
 -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
 -DUSE_MSVC_RUNTIME_LIBRARY_DLL=1

cmake --build . --config %CMAKE_CONFIG% --target ALL_BUILD
cmake --build . --config %CMAKE_CONFIG% --target INSTALL
