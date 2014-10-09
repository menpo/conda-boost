@echo off

setlocal enableextensions

if %PY3K% (
    SET MSVC_VER="10.0"
) else (
    SET MSVC_VER="9.0"
)

bootstrap
bjam -j2 -sBZIP2_LIBPATH="%PREFIX%\lib" -sBZIP2_INCLUDE="%PREFIX%\include" link=shared toolset="msvc-%MSVC_VER%" stage

md "%PREFIX%\lib"
robocopy "stage\lib" "%PREFIX%\lib" /E

md "%PREFIX%\include"
robocopy "boost" "%PREFIX%\include\boost" /E
