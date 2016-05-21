#&@setlocal enabledelayedexpansion&echo off&(if "%0" neq "%~0" (cls))&copy "%~nx0" "%~nx0.temp.ps1" /y >nul
#&powershell -exec bypass -noprofile -file "%~nx0.temp.ps1" %*&set err=!errorlevel!&del "%~nx0.temp.ps1"
#&(if "%0" neq "%~0" (echo.&echo Press any key to close...&pause >nul))&exit /b !err!
### github.com/RefinedSoftwareLLC/sh.bat - ps1.bat v0.1 - DO NOT MODIFY THESE 4 LINES ###
