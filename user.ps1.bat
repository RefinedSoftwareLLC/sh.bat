@ 2>/dev/null # 2>nul&echo off&setlocal enabledelayedexpansion&title %~n0&cd %~dp0&echo|set /p=# >"%~nx0.temp.ps1"&type "%~nx0" >>"%~nx0.temp.ps1"
# 2>nul&powershell -exec bypass -noprofile -file "%~nx0.temp.ps1" %*&set err=!errorlevel!
# 2>nul&del "%~nx0.temp.ps1"&(if not !err! == 0 (if %0 == "%~0" (echo.&echo|set /p="Press any key to close..."&pause >nul)))&exit /b !err!
if ($PSScriptRoot -eq $Null) {$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition}
cd $PSScriptRoot
function DropExt ($file,$repeat=1) {$a=$file.Split('.');[string]::Join('.', $a[0..($a.count-1-$repeat)])}
$Host.UI.RawUI.WindowTitle = DropExt $MyInvocation.MyCommand.Name 3
function pause {Write-Host -NoNewLine "`nPress any key to continue...";$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")}
function Write-Throw {for($i = $Error.count-1; $i -ge 0; $i--){$Er = $Error[$i];$Ii=$Er.InvocationInfo;$Ex=$Er.Exception;Write-Warning "$($Ii.MyCommand) : $($Ex.Message)`nAt$([char]0x00A0)$($Ii.ScriptName):$($Ii.ScriptLineNumber) char:$($Ii.OffsetInline)`n$($Ii.Line)"}}
try{
### github.com/RefinedSoftwareLLC/sh.bat - v0.5 - DO NOT MODIFY THESE LINES ###

#################
### .ps1 mode ###
#################
Write-Host passed: $args

################
### .ps1 end ###
################
}finally{if($Error[0]){Write-Throw;pause;exit 2}exit 0}
### DO NOT MODIFY THIS LINE ###
