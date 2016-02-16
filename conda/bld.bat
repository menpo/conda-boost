setlocal enableextensions

if "%PY_VER%" == "3.4" (
    set MSVC_VER="10.0"
) else (
    if "%PY_VER%" == "3.5" (
        set MSVC_VER="14.0"
    ) else (
        set MSVC_VER="9.0"
    )
)

set EXTRA_ARGS=""
if %ARCH% EQU 64 (
	set EXTRA_ARGS="address-model=64"
)


%PYTHON% -c "from __future__ import print_function; import distutils.sysconfig; print(distutils.sysconfig.get_python_inc(True))" > temp.txt
set /p PYTHON_INCLUDE_DIR=<temp.txt

call bootstrap.bat

bjam.exe --debug-configuration ^
         --user-config="%RECIPE_DIR%/user-config-win.jam" ^
		 -sBZIP2_LIBPATH="%LIBRARY_LIB%" -sBZIP2_INCLUDE="%LIBRARY_INC%" -sBZIP2_BINARY=bzip2 ^
		 -sZLIB_INCLUDE="%LIBRARY_INC%" -sZLIB_LIBPATH="%LIBRARY_LIB%" -sZLIB_BINARY=zlib ^
		 link=shared toolset="msvc-%MSVC_VER%" %EXTRA_ARGS% stage

if !errorlevel! NEQ 0 exit /b !errorlevel!
         
robocopy "stage\lib" "%LIBRARY_BIN%" /E /NFL
robocopy "boost" "%LIBRARY_INC%\boost" /E /NFL /NDL

if !errorlevel! GTR 8 exit /b !errorlevel!

exit 0