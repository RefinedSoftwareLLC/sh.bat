@{}# 2>nul&setLocal&echo off
set .=\`';[void]@'

# 2>nul&pushd %~dp0
# 2>nul&set "dpnx=%~dp0\%~nx0"&set "dp=%~dp0"&set "args="&(if not ["%1"]==[""] (set "args='%1'"&shift))
:loopTailCall 2>/dev/null
# 2>nul&(if not ["%1"]==[""] (set "args=%args%,'%1'"&shift&goto :loopTailCall))
# 2>nul&"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -WindowStyle Hidden -NonInteractive -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Invoke-Command -ScriptBlock ([ScriptBlock]::Create('Push-Location -LiteralPath ''%dp%'';'+(Get-Content -Path '%dpnx%' | Out-String)))" -Arg @(%args%)&set err=!errorlevel!
# 2>nul&exit /b !err!

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
Function IsNotAdmin {$CurrentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent());$CurrentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) -eq $False}
If (IsNotAdmin){Try{
  $PInfo = New-Object System.Diagnostics.ProcessStartInfo
  $PInfo.FileName = "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
  $PInfo.RedirectStandardError = $true
  $PInfo.RedirectStandardOutput = $true
  $PInfo.UseShellExecute = $false
  $PInfo.Arguments = @'
-Verb RunAs -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Invoke-Command -ScriptBlock ([ScriptBlock]::Create(Get-Content -Path '%~dp0\%~nx0' | Out-String))" -Arg @('%1','%2','%3','%4','%5','%6','%7','%8','%9')
'@
  $P = New-Object System.Diagnostics.Process
  $P.StartInfo = $PInfo
  $P.Start() | Out-Null
  $P.WaitForExit();exit $P.ExitCode}
  Catch [System.InvalidOperationException]{Write-Host "`nRight-click script then select `"Run as administrator`"`n";Exit 1}
  Finally{If(IsError){Write-Throw;Exit 1}Exit 0}
};
Try{
### DO NOT MODIFY THESE LINES ###

#################
### .ps1 mode ###
#################

# https://stackoverflow.com/questions/4660587/system-windows-messagebox-vs-system-windows-forms-messagebox
# MessageBox3rdArgument {
    # Ok = 0x000000,
    # OkCancel = 0x000001,
    # AbortRetryIgnore = 0x000002,
    # YesNoCancel = 0x000003,
    # YesNo = 0x000004,
    # RetryCancel = 0x000005,

    # IconHand = 0x000010,
    # IconQuestion = 0x000020,
    # IconExclamation = 0x000030,
    # IconAsterisk = 0x000040,
    # UserIcon = 0x000080,
    # IconWarning = IconExclamation,
    # IconError = IconHand,
    # IconInformation = IconAsterisk,
    # IconStop = IconHand,
    # DefButton1 = 0x000000,
    # DefButton2 = 0x000100,
    # DefButton3 = 0x000200,
    # DefButton4 = 0x000300,

    # ApplicationModal = 0x000000,
    # SystemModal = 0x001000,
    # TaskModal = 0x002000,

    # Help = 0x004000, //Help Button
    # NoFocus = 0x008000,

    # SetForeground = 0x010000,
    # DefaultDesktopOnly = 0x020000,
    # Topmost = 0x040000,
    # Right = 0x080000,
    # RTLReading = 0x100000,
# }

# MessageBoxReturnedResult {
    # Ok = 1,
    # Cancel,
    # Abort,
    # Retry,
    # Ignore,
    # Yes,
    # No,
    # Close,
    # Help,
    # TryAgain,
    # Continue,
    # Timeout = 32000
# }

[Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms");
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
[string]$ScriptName = "openwebpageyesno.bat"
[string]$ScriptPath = $MyInvocation.MyCommand.Definition -replace ".temp.ps1"
write $ScriptPath
if ($MyInvocation.MyCommand.Definition -ne "$env:PROGRAMDATA\$ScriptName") {
  
}

[string]$RunScript = "`"$ScriptPath`""
# COPY SCRIPT FILE INTO SYSTEM FOLDER AND POINT TO THAT COPY!
# 
# [string]$ScriptRegPath = "HKCR:\Applications\$ScriptName"

if ($args[0] -eq $RunScript) {
  $args = $args[1..($args.Length-1)]
}

function Get-Reg-Path {
  [string]$RegPath = "HKCR:\Applications\$($args)"
  if ($RegPath -and (Test-Path $RegPath)) {
    return $RegPath
  }
  [string]$RegPath = "HKCR:\$($args)"
  if ($RegPath -and (Test-Path $RegPath)) {
    return $RegPath
  }
  return $Null
}

function Backup-Set-Reg {
  param([Parameter(Mandatory=$true)][string]$Path, [string]$BackupPath = $Path, [Parameter(Mandatory=$true)][string]$Name, [Parameter(Mandatory=$true)][string]$Value)
  if ($Path -and (Test-Path $Path)) {
    if (!(Test-Path $BackupPath)) { New-Item -Path $BackupPath -force | Out-Null }
    [string]$RegBackup = (Get-ItemProperty -Path $Path)."$Name"
    if ($RegBackup -ne "") {
      New-ItemProperty -path $BackupPath -name "backup$Name" -value $RegBackup -force | Out-Null
    }
    New-ItemProperty -path $Path -name $Name -value $Value -force | Out-Null
  }
}

function Restore-Reg {
  param([Parameter(Mandatory=$true)][string]$Path, [string]$BackupPath = $Path, [Parameter(Mandatory=$true)][string]$Name)
  if ($Path -and (Test-Path $Path) -and $BackupPath -and (Test-Path $BackupPath)) {
    [string]$RegBackup = (Get-ItemProperty -Path $BackupPath)."backup$Name"
    if ($RegBackup -ne "") {
      New-ItemProperty -path $Path -name $Name -value $RegBackup -force | Out-Null
      Remove-ItemProperty -path $BackupPath -name "backup$Name" -force | Out-Null
    }
  }
}

function Install-Reg-Browser {
  [string]$RegPath0 = (Get-Reg-Path "$($args)")
  [string]$RegPath = "$RegPath0\shell\open\command"
  [string]$RegPath2 = "$RegPath0\Capabilities\URLAssociations"
  if ($RegPath -and (Test-Path $RegPath)) {
    [string]$RegBackupValue = (Get-ItemProperty -Path $RegPath)."(Default)"
    if ($RegBackupValue -and $RegBackupValue -ne "" -and !($RegBackupValue.StartsWith("$RunScript "))) {
      New-ItemProperty -path $RegPath -name "backupshell" -value $RegBackupValue -force | Out-Null
      New-ItemProperty -path $RegPath -name "(Default)" -value "$RunScript $RegBackupValue" -force | Out-Null
    }
    Backup-Set-Reg -path $RegPath2 -backuppath $RegPath -name "ftp" -value "$($args)"
    Backup-Set-Reg -path $RegPath2 -backuppath $RegPath -name "http" -value "$($args)"
    Backup-Set-Reg -path $RegPath2 -backuppath $RegPath -name "https" -value "$($args)"
  } 
}

function Uninstall-Reg-Browser {
  [string]$Path = Get-Reg-Path $args
  [string]$RegPath = "$Path\shell\open\command"
  [string]$RegPath2 = "$Path\Capabilities\URLAssociations"
  if ($RegPath -and (Test-Path $RegPath)) {
    [string]$RegValue = (Get-ItemProperty -Path $RegPath)."(Default)"
    [string]$RegBackupValue = (Get-ItemProperty -Path $RegPath)."backupshell"
    if ($RegValue.StartsWith("$RunScript ")) {
      if ($RegBackupValue -and $RegBackupValue -ne "") {
        New-ItemProperty -path $RegPath -name "(Default)" -value $RegBackupValue -force | Out-Null
      } else {
        $RegBackupValue = $RegValue.Substring("$RunScript ".length)
        New-ItemProperty -path $RegPath -name "(Default)" -value $RegBackupValue -force | Out-Null
      }
      if ((Get-ItemProperty -Path $RegPath)."backupshell") {
        Remove-ItemProperty -path $RegPath -name "backupshell" -force | Out-Null
      }
    }
    Restore-Reg -path $RegPath2 -backuppath $RegPath -name "ftp"
    Restore-Reg -path $RegPath2 -backuppath $RegPath -name "http"
    Restore-Reg -path $RegPath2 -backuppath $RegPath -name "https"
  }
}

if ($args.length -gt 0) {
  [string]$site = $args[$args.length-1]
  if ($true) { # Verifiy browser loading webpage
    [string]$r = [Windows.Forms.MessageBox]::show($site, "Open Webpage?", 4)
    switch ($r) {
      "Yes" {
        & $args[0] $args[1..($args.Length-1)]
      }
      "No" {}
      default { [Windows.Forms.MessageBox]::show("Error: Open webpage response is malformed.", "Open Webpage Error:") }
    }
  }
} else {
  [string]$r = [Windows.Forms.MessageBox]::show("Ask before opening a Webpage? Yes: Install, No: Uninstall.", "Setup Open Webpage?", 3)
  switch ($r) {
    "Yes" {
      # Install-Reg-Browser "iexplore.exe"
      Install-Reg-Browser "TorURL"
      Install-Reg-Browser "FirefoxURL"
      Install-Reg-Browser "FirefoxHTML"
      Install-Reg-Browser "ftp"
      Install-Reg-Browser "http"
      Install-Reg-Browser "https"      
    }
    "No" {
      # Uninstall-Reg-Browser "iexplore.exe"
      Uninstall-Reg-Browser "TorURL"
      Uninstall-Reg-Browser "FirefoxURL"
      Uninstall-Reg-Browser "FirefoxHTML"
      Uninstall-Reg-Browser "ftp"
      Uninstall-Reg-Browser "http"
      Uninstall-Reg-Browser "https"
    }
    "Cancel" {}
    default { [Windows.Forms.MessageBox]::show("Error: Setup response is malformed.", "Setup Open Webpage Error:") }
  }
}

################
### .ps1 end ###
################

}Finally{If(IsError){Write-Throw;Pause;Exit 2}Exit 0}
### DO NOT MODIFY THIS LINE ###
