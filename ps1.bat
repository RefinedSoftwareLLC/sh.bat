@setlocal enabledelayedexpansion&echo off&(if %0 == "%~0" (cls))
# 2>nul&echo|set/P="#">"%~nx0.temp.ps1"&copy "%~nx0.temp.ps1"+"%~nx0" "%~nx0.temp.ps1" /y >nul
# 2>nul&powershell -exec bypass -noprofile -file "%~nx0.temp.ps1" %*&set err=!errorlevel!
# 2>nul&del "%~nx0.temp.ps1"&(if %0 == "%~0" (echo.&echo Press any key to close...&pause >nul))&exit /b !err!
### github.com/RefinedSoftwareLLC/sh.bat - ps1.bat v0.2 - DO NOT MODIFY THESE 5 LINES ###

# place .ps1 script here
