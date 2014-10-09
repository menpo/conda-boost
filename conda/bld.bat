@echo off

setlocal enableextensions

bootstrap
bjam -j2 -sBZIP2_LIBPATH="%PREFIX%\lib" -sBZIP2_INCLUDE="%PREFIX%\include" link=shared stage

md "%PREFIX%\lib"
robocopy "stage\lib" "%PREFIX%\lib" /E

md "%PREFIX%\include"
robocopy "boost" "%PREFIX%\include\boost" /E
