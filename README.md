## sh.bat Template

#### Create a copy-paste (per platform) that download-runs your script:

Linux:

    curl -s -L https://raw.githubusercontent.com/RefinedSoftwareLLC/sh.bat/master/user.sh.bat | sh

Windows:

    powershell -nop -c "iex(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/RefinedSoftwareLLC/sh.bat/master/user.sh.bat')"

#### Create a single script that runs on Linux (.sh) and Windows (.ps1):

    @{}# 2>/dev/null # 2>nul&setLocal&echo off
    # 2>nul&title %~n0
    # 2>nul&"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Invoke-Command -ScriptBlock ([ScriptBlock]::Create('Push-Location -LiteralPath ''%~dp0'';#'+(Get-Content -Path '%~dp0\%~nx0' | Out-String)))" -Arg @('%1','%2','%3','%4','%5','%6','%7','%8','%9')&set err=!errorlevel!
    # 2>nul&(if not !err! == 0 (if %0 == "%~0" (echo(&echo|set /p="Press any key to close..."&pause >nul)))&exit /b !err!
    set .=\`';[void]@'
    pushd $(dirname $(realpath $0))
    ### DO NOT MODIFY THESE LINES - github.com/RefinedSoftwareLLC/sh.bat - v0.5.1.611 ###
    
    ################
    ### .sh mode ###
    ################
    
    echo "passed: $*"
    
    ###############
    ### .sh end ###
    ###############
    
    '@ #' 2>/dev/null;Exit 0
    If (-Not $PSScriptRoot) {$PSScriptRoot=(Get-Item -Path ".\" -Verbose).FullName}
    Function Pause {Write-Host -NoNewLine "`nPress any key to continue...";$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")}
    Function Write-Throw {for($i = $Error.count-1; $i -ge 0; $i--){$Er = $Error[$i];$Ii=$Er.InvocationInfo;$Ex=$Er.Exception;Write-Warning "$($Ii.MyCommand) : $($Ex.Message)`nAt$([char]0x00A0)$($Ii.ScriptName):$($Ii.ScriptLineNumber) char:$($Ii.OffsetInline)`n$($Ii.Line)"}}
    Try{
    ### DO NOT MODIFY THESE LINES ###
    
    #################
    ### .ps1 mode ###
    #################
    
    Write-Host "passed: $args"
    
    ################
    ### .ps1 end ###
    ################
    
    }Finally{If($Error[0]){Write-Throw;Pause;Exit 2}Exit 0}
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
