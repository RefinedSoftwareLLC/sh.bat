# sh.bat
Single script that runs .sh or .ps1 as needed.

    #!/bin/sh   #^
    #:Loading PowerShell:## 2>nul &@SETLOCAL EnableDelayedExpansion&echo off
    # 2>nul &del "%0.ps1" 2>nul&(if exist "%0" (copy "%0" "%0.ps1" /y >nul)else (copy "%0.bat" "%0.ps1" /y >nul))
    # 2>nul &powershell -ExecutionPolicy Bypass -noprofile -file "%0.ps1" %*&set error=!errorlevel!&del "%0.ps1"
    # 2>nul &(if "%0" neq "%~0" (echo.&echo Press any key to close...&pause >nul))&exit /b !error!
    @'
    #' >/dev/null 2>&1 # sh.bat version 0.1 # DO NOT MODIFY THESE 7 LINES
    
    ################
    ### .sh mode ###
    ################
    
    # place .sh script here
    
    ###############
    ### .sh end ###
    ###############
    
    exit 0
    '@ | Out-Null # DO NOT MODIFY THESE 2 LINES
    
    #################
    ### .ps1 mode ###
    #################
    
    # place .ps1 script here
    
    ################
    ### .ps1 end ###
    ################
