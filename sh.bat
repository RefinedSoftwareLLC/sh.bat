#!/bin/sh  #^
#:Loading PowerShell:## 2>nul&@setlocal enabledelayedexpansion&echo off&copy "%~nx0" "%~nx0.temp.ps1" /y >nul
# 2>nul&powershell -exec bypass -noprofile -file "%~nx0.temp.ps1" %*&set err=!errorlevel!&del "%~nx0.temp.ps1"
# 2>nul&(if "%0" neq "%~0" (echo.&echo Press any key to close...&pause >nul))&exit /b !err!
[void]@'
#' 2>/dev/null ### github.com/RefinedSoftwareLLC/sh.bat - v0.2 - DO NOT MODIFY THESE 6 LINES ###

################
### .sh mode ###
################

# Change to path of script:
cd $(dirname $(realpath $0))
echo "passed: $*"

###############
### .sh end ###
###############

'@#' 2>/dev/null;exit 0 ### DO NOT MODIFY THIS LINE ###

#################
### .ps1 mode ###
#################

# Change to path of script:
cd $PSScriptRoot
echo "passed: $args"

################
### .ps1 end ###
################
