#!/bin/sh   #^
#:Loading PowerShell:## 2>nul &@setlocal enabledelayedexpansion&echo off
# 2>nul &(if exist "%0" (copy "%0" "%0.ps1" /y >nul)else (copy "%0.bat" "%0.ps1" /y >nul))
# 2>nul &powershell -exec bypass -noprofile -file "%0.ps1" %*&set err=!errorlevel!&del "%0.ps1"
# 2>nul &(if "%0" neq "%~0" (echo.&echo Press any key to close...&pause >nul))&exit /b !err!
@'
#' 2>/dev/null # sh.bat version 0.1 # DO NOT MODIFY THESE 7 LINES

################
### .sh mode ###
################

# Change to path of script:
cd $(dirname $(realpath $0))
echo "passed: $*"

###############
### .sh end ###
###############

exit 0
'@ | Out-Null # DO NOT MODIFY THESE 2 LINES

#################
### .ps1 mode ###
#################

# Change to path of script:
cd $PSScriptRoot
echo "passed: $args"

################
### .ps1 end ###
################
