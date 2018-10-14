@ setLocal & echo off
cd %~dp0

REM (set outfolder=..)
REM (set outfile=test.sh.bat)

REM call :newVersion ".\version.txt"

REM call :clear
REM call :prefixFileLn ".\file.prefix.txt"
REM call :addFile ".\bat.exit.txt"
REM call :prefixFile ".\file.prefix.txt"



REM (set test=  ..)

REM setlocal enableextensions enabledelayedexpansion

REM (set count=0)
REM for %%a in (%test%) do (
    REM (set /a count+=1)
    REM <nul (set /p .=working on file !count!)
REM )
REM setlocal disabledelayedexpansion

REM (echo(%test%)
REM echo|(set /p .=%test%)
REM echo|(set /p .="%test%")
REM 0>NUL (set /p .=%test%)
REM 0>NUL (set /p .="%test%")
REM <NUL (set /p .=%test%)
REM <NUL (set /p .="%test%")
REM <NUL (set /p .=%test%)|echo
REM <NUL (set /p .="%test%")|echo

REM call :addStringLn ".  ###  ."
REM call :addString "  ### " & call :addStringLn " ###  ."
REM call :prefixString ".  ### "

REM (echo()
REM (echo(done)
REM start notepad ..\test.sh.bat
REM goto :exit

rem ###################
rem ###  .bat mode  ###
rem ### Use "echo(" ###
rem ###################

(set outfolder=..)
(set sourcefolder=%outfolder%\source)

call :newVersion ".\version.txt"

call :compileAll "example"
goto :exit

:compileAll
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  call :newVersion "%sourcefolder%\%~1.version.txt"
  call :compileUser "%~1"
  call :compileAdmin "%~1"
  start notepad "%outfolder%\%~1.sh.bat"
goto :return

:compileUser
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  (set outfile=%~1.sh.bat)
  call :clear
  rem .bat bootstrap
    call :prefixFileLn ".\file.prefix.txt"
    call :addPrefixFileWithEveryLineOfFile ".\comment.prefix.run.bat.txt" ".\bat.try.txt"
    call :addPrefixFileWithEveryLineOfFile ".\comment.prefix.run.bat.txt" ".\bat.finally.txt"
  rem start .ps1 skip over .sh
  call :addFileLn ".\ps1.skip.try.txt"
    rem .sh
      call :sh "%~1"
  rem end of .ps1 skip over .sh
  call :addFileLn ".\ps1.skip.finally.txt"
  rem .ps1
    call :ps1 "%~1"
goto :return

:compileAdmin
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  (set outfile=%~1.admin.sh.bat)
  call :clear
  rem .bat bootstrap
    call :prefixFile ".\file.prefix.txt"
    call :addPrefixFileWithEveryLineOfFile ".\comment.prefix.run.bat.txt" ".\bat.try.txt"
    call :addPrefixFileWithEveryLineOfFile ".\comment.prefix.run.bat.txt" ".\bat.finally.txt"
  rem start .ps1 skip over .sh
  call :addFileLn ".\ps1.skip.try.txt"
    rem .sh
      call :sh "%~1"
  rem end of .ps1 skip over .sh
  call :addFileLn ".\ps1.skip.finally.txt"
  rem .ps1
    call :ps1 "%~1"
goto :return

:sh
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  call :addFile ".\sh.try.txt" & call :addFile ".\version.txt" & call :addStringLn " ###"
  call :addFileLn "%sourcefolder%\%~1.sh.txt"
  rem call :addFileLn ".\sh.finally.txt"
goto :return

:ps1
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  call :addFileLn ".\ps1.constants.txt"
  call :addFileLn ".\ps1.try.txt"
    call :addFileLn "%sourcefolder%\%~1.ps1.txt"
  call :addFileLn ".\ps1.finally.txt"
goto :return

rem ###############
rem ### library ###
rem ###############

:newVersion
setLocal EnableDelayedExpansion
  if [%1]==[] goto :error
  if not [%3]==[] goto :error
  if [%2]==[] (
    if not exist "%~1" (echo(0.0.0.0)>"%~1"
    (set /p az=<"%~1")
    rem %az%    =0.0.0.5
    call :newVersion "%~1" "!az!"
    goto :return
  )
  rem %~2      =0.0.0.5
  rem %~n2    =0.0.0
  rem %~x2    =.5
  (set z=%~x2)
  (set z=%z:~1%)
  (set /a z=z+1)
  rem %z%     =6
  (set az=%~n2.%z%)
  rem %~n2.%z%=0.0.0.6
  (echo(%az%)>"%~1"
goto :return

:clear
setLocal
  if not [%1]==[] goto :error
  type nul >"%outfolder%\%outfile%"
  rem copy /b nul "%outfolder%\%outfile%"
goto :return

:toBuffer
setLocal
  if not [%1]==[] goto :error
  del "%outfolder%\%outfile%.temp" >nul 2>&1
  ren "%outfolder%\%outfile%" "%outfile%.temp"
  call :clear
endlocal & (set buffer=%outfile%.temp) & exit /b 0

:clearBuffer
setLocal
  if not [%1]==[] goto :error
  del "%outfolder%\%buffer%" >nul 2>&1
goto :return

:addLn
setLocal
  if not [%1]==[] goto :error
  (echo()>>"%outfolder%\%outfile%"
goto :return

:addFile
setLocal
  if [%1]==[] goto :error
  if not exist "%~1" goto :error
  if not [%2]==[] goto :error
  copy /b "%outfolder%\%outfile%" + "%~1" "%outfolder%\%outfile%" >nul
goto :return

:addFileLn
setLocal
  if [%1]==[] goto :error
  if not exist "%~1" goto :error
  if not [%2]==[] goto :error
  call :addFile "%~1"
  call :addLn
goto :return

:prefixFile
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] if not [%2]==[Ln] goto :error
  if not exist "%~1" goto :error
  if not [%3]==[] goto :error
  call :toBuffer
  call :addFile "%~1"
  if [%2]==[Ln] call :addLn
  call :addFile "%outfolder%\%buffer%"
  call :clearBuffer
goto :return

:prefixFileLn
setLocal
  if [%1]==[] goto :error
  if not exist "%~1" goto :error
  if not [%2]==[] goto :error
  call :prefixFile "%~1" Ln
goto :return

:addString
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  (echo(addString incorrectly adds newline)
  call :addStringLn "%~1"
  REM (set temp=%~1)
  REM (echo(%temp%)
  REM <NUL (set /p.="   testing  ")
  rem echo|(set /p.="   testing  ")
  rem (type %temp%)
  rem echo|(set /p.=%temp: = %)
  rem (echo(%~1)
  rem echo|(set /p.=%~1:#=##%)
  
  rem double check this doesnt add white spaces
  rem echo|(set /p.= %~1) >>"%outfolder%\%outfile%"
  
  rem (echo(%~1)>>"%outfolder%\%outfile%"
  rem call :addFile "%~1"
  rem del "%outfolder%\%buffer%" >nul 2>&1
goto :return

:addStringLn
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  (echo(%~1)>>"%outfolder%\%outfile%"
goto :return

:prefixString
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] if not [%2]==[Ln] goto :error
  if not [%3]==[] goto :error
  call :toBuffer
  call :addString "%~1"
  if [%2]==[Ln] call :addLn
  call :addFile "%outfolder%\%buffer%"
  call :clearBuffer
goto :return

:prefixStringLn
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  call :prefixString "%~1" Ln
goto :return

:everyLinePrefixFile
setLocal disabledelayedexpansion
  if [%1]==[] goto :error
  if not exist "%~1" goto :error
  if not [%2]==[] goto :error
  call :toBuffer
  for /f "usebackq delims=" %%a in ("%outfolder%\%buffer%") do (
    call :addFile "%~1"
    (echo(%%a>>"%outfolder%\%outfile%")
  )
  call :clearBuffer
goto :return

:everyLinePrefixString
setLocal disabledelayedexpansion
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  call :toBuffer
  for /f "usebackq delims=" %%a in ("%outfolder%\%buffer%") do (
    call :addString "%~1"
    (echo(%%a>>"%outfolder%\%outfile%")
  )
  call :clearBuffer
goto :return

:addPrefixFileWithEveryLineOfFile
setLocal
  if [%1]==[] goto :error
  if not exist "%~1" goto :error
  if [%2]==[] goto :error
  if not exist "%~2" goto :error
  if not [%3]==[] goto :error
  for /f "usebackq delims=" %%a in ("%~2") do (
    call :addFile "%~1"
    (echo(%%a>>"%outfolder%\%outfile%")
  )
goto :return

:addPrefixStringWithEveryLineOfFile
setLocal
  if [%1]==[] goto :error
  if [%2]==[] goto :error
  if not exist "%~2" goto :error
  if not [%3]==[] goto :error
  for /f "usebackq delims=" %%a in ("%~2") do (
    call :addString "%~1"
    (echo(%%a>>"%outfolder%\%outfile%")
  )
goto :return

rem ##############
rem ### engine ###
rem ##############

goto :exit

:example
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  (set var1=%~1)
  (set return=%var1% world)
goto :return

:error
(echo(Error: %0 %*)
endlocal & (set return=)
if [%1]==[] exit /b 1
exit /b %~1

:return
endlocal & (set return=%return%) & exit /b 0

:exit
if [%1]==[] exit /b 0
exit /b %~1
