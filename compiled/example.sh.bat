@{}# 2>/dev/null # 2>nul&setLocal&echo off
# 2>nul&title %~nx0&(if %0 == "%~0" (cls))&pushd %~dp0
# 2>nul&"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Invoke-Command -ScriptBlock ([ScriptBlock]::Create('Push-Location -LiteralPath ''%~dp0'';#'+(Get-Content -Path '%~dp0\%~nx0' | Out-String)))" -Arg @('%1','%2','%3','%4','%5','%6','%7','%8','%9')&set err=!errorlevel!
# 2>nul&(if not !err! == 0 (if %0 == "%~0" (echo(&echo|set /p="Press any key to close..."&pause >nul)))&exit /b !err!
set .=\`';[void]@'

pushd $(dirname $(realpath $0))
### DO NOT MODIFY THESE LINES - github.com/RefinedSoftwareLLC/sh.bat - v0.5.1.619 ###

################
### .sh mode ###
################

echo "passed: $*"

###############
### .sh end ###
###############

exit 0

'@
Set-ExecutionPolicy Bypass -Scope Process -Force -NoProfile -InputFormat None;
Set-StrictMode -Version 2.0
If (-Not $PSScriptRoot) {$PSScriptRoot=(Get-Item -Path ".\" -Verbose).FullName}
pushd $PSScriptRoot
Function fixPath {$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")};
fixPath;
Function Pause {Write-Host -NoNewLine "`nPress any key to continue...";$Null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")}
Function Write-Throw {For($i = $Error.count-1; $i -ge 0; $i--){$Er = $Error[$i];$Ii=$Er.InvocationInfo;$Ex=$Er.Exception;Write-Warning "$($Ii.MyCommand) : $($Ex.Message)`nAt$([char]0x00A0)$($Ii.ScriptName):$($Ii.ScriptLineNumber) char:$($Ii.OffsetInline)`n$($Ii.Line)"}}
Function IsError {For($i = $Error.count-1; $i -ge 0; $i--){$Er = $Error[$i];$Ii=$Er.InvocationInfo;if ($Error[0].InvocationInfo.BoundParameters["ErrorAction"] -eq "SilentlyContinue"){continue};Return $True}Return $False}
If ($MyInvocation.MyCommand.Name) {$Host.UI.RawUI.WindowTitle = $MyInvocation.MyCommand.Name}
Try{
### DO NOT MODIFY THESE LINES ###

#################
### .ps1 mode ###
#################

Write-Host "passed: $args"

################
### .ps1 end ###
################

}Finally{If(IsError){Write-Throw;Pause;Exit 2}Exit 0}
### DO NOT MODIFY THIS LINE ###
