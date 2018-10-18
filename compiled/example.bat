@{}# 2>nul&setLocal&echo off
# 2>nul&rem #### 0.0.0.682 ###

set .=\`';[void]@'

# 2>nul&title %~nx0&(if %0 == "%~0" (cls))&pushd %~dp0
# 2>nul&set "dpnx=%~dp0\%~nx0"&set "dp=%~dp0"&set "args="&(if not ["%1"]==[""] (set "args='%1'"&shift))
:loopTailCall 2>/dev/null
# 2>nul&(if not ["%1"]==[""] (set "args=%args%,'%1'"&shift&goto :loopTailCall))
# 2>nul&"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Invoke-Command -ScriptBlock ([ScriptBlock]::Create('Push-Location -LiteralPath ''%dp%'';'+(Get-Content -Path '%dpnx%' | Out-String)))" -Arg @(%args%)&set err=!errorlevel!
# 2>nul&(if not !err! == 0 (if %0 == "%~0" (echo(&echo|set /p="Press any key to close..."&pause >nul)))&exit /b !err!

'@ #' 2>/dev/null # 2>null

Set-ExecutionPolicy Bypass -Scope Process -Force;
Set-StrictMode -Version 2.0
& {param($PSScriptRoot);If (-Not $PSScriptRoot) {$Script:PSScriptRoot=(Get-Item -Path ".\" -Verbose).FullName;};};
pushd $PSScriptRoot;
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
