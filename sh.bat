#!/bin/sh  #^
#:Loading PowerShell:## 2>nul&@setlocal enabledelayedexpansion&echo off&(if "%0" neq "%~0" (cls))&copy "%~nx0" "%~nx0.temp.ps1" /y >nul
# 2>nul&powershell -exec bypass -noprofile -file "%~nx0.temp.ps1" %*&set err=!errorlevel!
# 2>nul&del "%~nx0.temp.ps1"&(if "%0" neq "%~0" (echo.&echo Press any key to close...&pause >nul))&exit /b !err!
echo \' >/dev/null ' >$null;[void]@'
### github.com/RefinedSoftwareLLC/sh.bat - v0.3 - DO NOT MODIFY THESE 6 LINES ###

################
### .sh mode ###
################

# Change to path of script:
cd $(dirname $(realpath $0))
echo "passed: $*"

###############
### .sh end ###
###############

'@ #' 2>/dev/null;exit 0 ### DO NOT MODIFY THIS LINE ###

#################
### .ps1 mode ###
#################

# Change to path of script:
if ($PSScriptRoot -eq $Null) { $PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition }
cd $PSScriptRoot
echo "passed: $args"

################
### .ps1 end ###
################
