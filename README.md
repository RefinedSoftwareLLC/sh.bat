## sh.bat Template

#### Create a copy-paste (per platform) that download-runs your script:

Linux:

    curl -s -L https://github.com/RefinedSoftwareLLC/sh.bat/raw/master/sh.bat | sh

Windows:

    powershell -nop -c "iex(New-Object Net.WebClient).DownloadString('https://github.com/RefinedSoftwareLLC/sh.bat/raw/master/sh.bat')"

#### Create a single script that runs on Linux (.sh) and Windows (.ps1):
    
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

#### Notes:

- File name should end with ".sh.bat" or, if the only script, it can be exactly "sh.bat".
- Window users can also download then double click. The output window will not automatically close.
- Window users can drop files onto the script to pass them as arguments.
- Window users do not need to type .bat to use.
- Some fun 4 letter names: ba.sh.bat, bu.sh.bat, ca.sh.bat, da.sh.bat, di.sh.bat, fi.sh.bat, go.sh.bat, ha.sh.bat, hu.sh.bat, pu.sh.bat, ru.sh.bat, sa.sh.bat, se.sh.bat, wa.sh.bat, wi.sh.bat.

#### Thanks:

- https://blog.netspi.com/15-ways-to-bypass-the-powershell-execution-policy/
- https://docs.chef.io/install_omnibus.html
