@{}# 2>nul&setLocal&echo off
# 2>nul&rem #### 0.0.0.318 ###

set .=\`';[void]@'

# 2>nul&title %~nx0&(if %0 == "%~0" (cls))&pushd %~dp0
# 2>nul&set "dpnx=%~dpnx0"&set "dp=%~dp0"&set "args="&(if not ["%1"]==[""] (set "args='%1'"&shift))
:loopTailCall 2>/dev/null
# 2>nul&(if not ["%1"]==[""] (set "args=%args%,'%1'"&shift&goto :loopTailCall))
# 2>nul&"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "$Script:ShBatScriptBlock=[ScriptBlock]::Create('$Script:ShBatScriptFile=''%dpnx%'';$Script:PSScriptRoot=''%dp%'';Push-Location -LiteralPath ''%dp%'';'+(Get-Content -Path '%dpnx%' | Out-String));Invoke-Command -ScriptBlock ($Script:ShBatScriptBlock)" -Arg @(%args%) <nul&set err=!errorlevel!
# 2>nul&(if not !err! == 0 (if %0 == "%~0" (echo(&echo|set /p="Press any key to close..."&pause >nul)))&exit /b !err!

'@ #' 2>/dev/null # 2>null

Set-ExecutionPolicy Bypass -Scope Process -Force;
Set-StrictMode -Version 2.0
& {param($PSScriptRoot);If (-Not $PSScriptRoot) {$Script:PSScriptRoot=(Get-Item -Path ".\" -Verbose).FullName;};};
pushd $PSScriptRoot;
Function fixPath {$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")};
fixPath;
Function Pause {Write-Host -NoNewLine "`nPress any key to continue...";$Null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")}
Function Write-Throw {For($i = $Error.count-1; $i -ge 0; $i--){$Er = $Error[$i];$Ii=$Er.InvocationInfo;$Ex=$Er.Exception;Write-Warning "$($Ii.MyCommand) : $($Ex.Message)`nAt$([char]0x00A0)$($Ii.ScriptName,'line'|?{$_-NE''}|Select -First 1):$($Ii.ScriptLineNumber) char:$($Ii.OffsetInline)`n$($Ii.Line)"}}
Function IsError {For($i = $Error.count-1; $i -ge 0; $i--){$Er = $Error[$i];$Ii=$Er.InvocationInfo;if ($Error[0].InvocationInfo.BoundParameters["ErrorAction"] -eq "SilentlyContinue"){continue};Return $True}Return $False}
If ($MyInvocation.MyCommand.Name) {$Host.UI.RawUI.WindowTitle = $MyInvocation.MyCommand.Name}else{$Host.UI.RawUI.WindowTitle = Split-Path -Path $Script:ShBatScriptFile -Leaf}
Function IsNotAdmin {$CurrentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent());$CurrentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) -eq $False}
If (IsNotAdmin) {
  Try {
    [String]$Script:ShBatScriptArgs = ($Args | ForEach-Object { '''{0}''' -f $_}) -Join(',');
    $PSInfo = New-Object System.Diagnostics.ProcessStartInfo
    $PSInfo.LoadUserProfile = $false;
    $PSInfo.FileName = "$Env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
    $PSInfo.Arguments = @(
      "-NoProfile",
      "-ExecutionPolicy", "Bypass",
      "-InputFormat", "None",
      "-Command", """`$ShBatScriptBlock=[ScriptBlock]::Create(`'`$Script:ShBatScriptFile=`'`'$Script:ShBatScriptFile`'`';`$Script:PSScriptRoot=`'`'$Script:PSScriptRoot`'`';Push-Location -LiteralPath `'`'$Script:PSScriptRoot`'`';`'+(Get-Content -Path `'$Script:ShBatScriptFile`' | Out-String));Invoke-Command -ScriptBlock (`$Script:ShBatScriptBlock)"""
      "-Arg", "@($($Script:ShBatScriptArgs))"
    );
    $PSInfo.Verb = "runas"
    # [System.Diagnostics.Process]::Start($PSInfo);
    $PSProcess = New-Object System.Diagnostics.Process
    $PSProcess.StartInfo = $PSInfo
    Try{
      $PSProcess.Start() | Out-Null
      $PSProcess.WaitForExit();
      # Write-Host "Admin Exit Code $([String]$PSProcess.ExitCode)"
      Exit $PSProcess.ExitCode;
    } Catch [System.Management.Automation.MethodInvocationException]{Write-Host "`nRight-click script then select `"Run as administrator`"`n";Exit 1}
  }
Catch [System.InvalidOperationException]{Write-Host "`nRight-click script then select `"Run as administrator`"`n";Exit 1}
Finally {If(IsError){Write-Throw;Exit 1}Exit 0}};
Try{
### DO NOT MODIFY THESE LINES ###

#################
### .ps1 mode ###
#################

Write-Host "passed: $args"
If (IsNotAdmin) {
  Write-Error 'Error not admin'
} else {
  Write-Host 'Successfully admin'
}
Pause

################
### .ps1 end ###
################

}Finally{If(IsError){Write-Throw;Pause;Exit 2}Exit 0}
### DO NOT MODIFY THIS LINE ###
