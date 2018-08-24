## sh.bat Template

#### Create a copy-paste (per platform) that download-runs your script:

Linux:

    curl -s -L https://github.com/RefinedSoftwareLLC/sh.bat/raw/master/sh.bat | sh

Windows:

    powershell -nop -c "iex(New-Object Net.WebClient).DownloadString('https://github.com/RefinedSoftwareLLC/sh.bat/raw/master/sh.bat')"

#### Create a single script that runs on Linux (.sh) and Windows (.ps1):
    
    @ 2>/dev/null # 2>nul&echo off&setlocal enabledelayedexpansion&title %~n0&cd %~dp0&echo|set /p=# >"%~nx0.temp.ps1"&type "%~nx0" >>"%~nx0.temp.ps1"
    # 2>nul&powershell -exec bypass -noprofile -file "%~nx0.temp.ps1" %*&set err=!errorlevel!
    # 2>nul&del "%~nx0.temp.ps1"&(if not !err! == 0 (if %0 == "%~0" (echo.&echo|set /p="Press any key to close..."&pause >nul)))&exit /b !err!
    echo \' >/dev/null ' >$null;[void]@'
    cd $(dirname $(realpath $0))
    ### github.com/RefinedSoftwareLLC/sh.bat - v0.5 - DO NOT MODIFY THESE LINES ###

    ################
    ### .sh mode ###
    ################
    echo "passed: $*"

    # place .sh script here

    ###############
    ### .sh end ###
    ###############

    '@ #' 2>/dev/null;exit 0
    if ($PSScriptRoot -eq $Null) {$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition}
    cd $PSScriptRoot
    function DropExt ($file,$repeat=1) {$a=$file.Split('.');[string]::Join('.', $a[0..($a.count-1-$repeat)])}
    $Host.UI.RawUI.WindowTitle = DropExt $MyInvocation.MyCommand.Name 3
    function pause {Write-Host -NoNewLine "`nPress any key to continue...";$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")}
    function Write-Throw {for($i = $Error.count-1; $i -ge 0; $i--){$Er = $Error[$i];$Ii=$Er.InvocationInfo;$Ex=$Er.Exception;Write-Warning "$($Ii.MyCommand) : $($Ex.Message)`nAt$([char]0x00A0)$($Ii.ScriptName):$($Ii.ScriptLineNumber) char:$($Ii.OffsetInline)`n$($Ii.Line)"}}
    try{
    ### DO NOT MODIFY THESE LINES ###

    #################
    ### .ps1 mode ###
    #################
    Write-Host passed: $args
    
    # place .ps1 script here
    
    ################
    ### .ps1 end ###
    ################
    }finally{if($Error[0]){Write-Throw;pause;exit 2}exit 0}
    ### DO NOT MODIFY THIS LINE ###

#### Notes:
- File name should end with ".sh.bat" or, if the only script, it can be exactly "sh.bat".
- Window users can also download then double click. The output window will not automatically close if there is an error.
- Window users can drop files onto the script to pass them as arguments.
- Window users do not need to type .bat to use.
- Some fun 4 letter names: ba.sh.bat, bu.sh.bat, ca.sh.bat, da.sh.bat, di.sh.bat, fi.sh.bat, go.sh.bat, ha.sh.bat, hu.sh.bat, pu.sh.bat, ru.sh.bat, sa.sh.bat, se.sh.bat, wa.sh.bat, wi.sh.bat.

#### Thanks:

- https://blog.netspi.com/15-ways-to-bypass-the-powershell-execution-policy/
- https://docs.chef.io/install_omnibus.html
