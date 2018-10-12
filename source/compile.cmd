@ setlocal & echo off

REM #################
REM ### .cmd mode ###
REM #################

cd %~dp0
echo.passed: %*
REM copy /b NUL EmptyFile.txt

goto :exit

:append
if [%1]==[] goto :error
set file=%1

goto :return

REM ################
REM ### .cmd end ###
REM ################

goto :exit

:example
setlocal
if [%1]==[] goto :error
set var1=%1
set return=%var1% world
goto :return

:error
echo.Error: %0 %*
rem fall-through

:return
endlocal & set return=%return%
rem fall-through

:exit
exit /B 1