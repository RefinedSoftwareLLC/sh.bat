@ (set "return=errorReturn") & setLocal enableDelayedExpansion & setLocal & echo off
set LF=^


::Above 2 blank lines are required - do not remove
set ^"\n=^^^%LF%%LF%^%LF%%LF%^^"
pushd %~dp0

REM (set "outfolder=..")
REM (set "outfile=test.sh.bat")

REM call :newVersionFile ".\version.txt"

REM call :clear
REM call :prefixFileLn ".\file.prefix.txt"
REM call :addFile ".\bat.exit.txt"
REM call :prefixFile ".\file.prefix.txt"



REM (set "test=  ..")

REM setlocal enableextensions

REM (set "count=0")
REM for %%a in (%test%) do (
    REM (set /a "count+=1")
    REM <nul (set /p ".=working on file !count!")
REM )
REM setlocal disabledelayedexpansion

REM (echo(%test%)
REM echo|(set /p ".=%test%")
REM 0>NUL (set /p ".=%test%")
REM <NUL (set /p ".=%test%")
REM <NUL (set /p ".=%test%")|echo

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

(set "outfolder=..")
(set "sourcefolder=%outfolder%\source")

call :newVersionFile ".\version.txt"

call :compileAll "example"
goto :exit

:compileAll
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  call :newVersionFile "%sourcefolder%\%~1.version.txt"
  call :compileUser "%~1"
  call :compileAdmin "%~1"
  start notepad "%outfolder%\%~1.sh.bat"
goto :voidReturn

:compileUser
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  (set "outfile=%~1.sh.bat")
  call :clear
  rem .bat bootstrap
    call :prefixFileLn ".\file.prefix.txt"
    call :addPrefixFileHeadWithEveryLineOfFile ".\comment.prefix.run.bat.txt" ".\bat.try.txt"
    call :addPrefixFileHeadWithEveryLineOfFile ".\comment.prefix.run.bat.txt" ".\bat.finally.txt"
  rem start .ps1 skip over .sh
  call :addFileLn ".\ps1.skip.try.txt"
    rem .sh
      call :sh "%~1"
  rem end of .ps1 skip over .sh
  call :addFileLn ".\ps1.skip.finally.txt"
  rem .ps1
    call :ps1 "%~1"
goto :voidReturn

:compileAdmin
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  (set "outfile=%~1.admin.sh.bat")
  call :clear
  rem .bat bootstrap
    call :prefixFile ".\file.prefix.txt"
    call :addPrefixFileHeadWithEveryLineOfFile ".\comment.prefix.run.bat.txt" ".\bat.try.txt"
    call :addPrefixFileHeadWithEveryLineOfFile ".\comment.prefix.run.bat.txt" ".\bat.finally.txt"
  rem start .ps1 skip over .sh
  call :addFileLn ".\ps1.skip.try.txt"
    rem .sh
      call :sh "%~1"
  rem end of .ps1 skip over .sh
  call :addFileLn ".\ps1.skip.finally.txt"
  rem .ps1
    call :ps1 "%~1"
goto :voidReturn

:sh
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  call :addFile ".\sh.try.txt" & call :addFileHead ".\version.txt" & call :addStringLn " ###"
    call :addFileLn "%sourcefolder%\%~1.sh.txt"
  rem call :addFileLn ".\sh.finally.txt"
goto :voidReturn

:ps1
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  call :addFileLn ".\ps1.constants.txt"
  call :addFileLn ".\ps1.try.txt"
    call :addFileLn "%sourcefolder%\%~1.ps1.txt"
  call :addFileLn ".\ps1.finally.txt"
goto :voidReturn

rem ###############
rem ### library ###
rem ###############

:newVersionFile
setLocal enableDelayedExpansion
  if [%1]==[] goto :error
  if not [%3]==[] goto :error
  if [%2]==[] (
    if not exist "%~1" call :newFileFromString "%~1" "0.0.0.0"
    call :returnFileFirstLine "%~1"
    rem !return!=0.0.0.5
    call :newVersionFile "%~1" "!return!"
    goto :voidReturn
  )
  rem %~2       =0.0.0.5
  rem %~n2      =0.0.0
  rem %~x2      =.5
  (set "z=%~x2")
  (set "z=%z:~1%")
  (set /a "z=z+1")
  rem %z%       =6
  rem %~n2.%z%  =0.0.0.6
  call :newFileFromString "%~1" "%~n2.%z%"
goto :voidReturn

:clear
setLocal
  if not [%1]==[] goto :error
  type nul >"%outfolder%\%outfile%"
  rem copy /b nul "%outfolder%\%outfile%"
goto :voidReturn

:toBuffer
setLocal
  if not [%1]==[] goto :error
  del "%outfolder%\%outfile%.temp" >nul 2>&1
  ren "%outfolder%\%outfile%" "%outfile%.temp"
  call :clear
endlocal & (set "buffer=%outfile%.temp") & exit /b 0

:clearBuffer
setLocal
  if not [%1]==[] goto :error
  del "%outfolder%\%buffer%" >nul 2>&1
goto :voidReturn

:addLn
setLocal
  if not [%1]==[] goto :error
  (echo()>>"%outfolder%\%outfile%"
goto :voidReturn

:addFile
setLocal
  if [%1]==[] goto :error
  if not exist "%~1" goto :error
  if not [%2]==[] goto :error
  copy /b "%outfolder%\%outfile%" + "%~1" "%outfolder%\%outfile%" >nul
goto :voidReturn

:addFileHead
setLocal
  if [%1]==[] goto :error
  if not exist "%~1" goto :error
  if not [%2]==[] goto :error
  call :returnFileFirstLine "%~1"
  call :addStringFoundInFile "%return%" "%~1"
goto :voidReturn

:addStringFoundInFile
setLocal
  if [%1]==[] goto :error
  if [%2]==[] goto :error
  if not exist "%~2" goto :error
  if not [%3]==[] goto :error
  findstr /b /C:"%~1" "%~2">>"%outfolder%\%outfile%"
goto :voidReturn

:addStringFoundInFileLn
setLocal
  if [%1]==[] goto :error
  if [%2]==[] goto :error
  if not exist "%~2" goto :error
  if not [%3]==[] goto :error
  call :addStringFoundInFile "%~1" "%~2"
  call :addLn
goto :voidReturn

:addFileLn
setLocal
  if [%1]==[] goto :error
  if not exist "%~1" goto :error
  if not [%2]==[] goto :error
  call :addFile "%~1"
  call :addLn
goto :voidReturn

:addFileHeadLn
setLocal
  if [%1]==[] goto :error
  if not exist "%~1" goto :error
  if not [%2]==[] goto :error
  call :addFileHead "%~1"
  call :addLn
goto :voidReturn

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
goto :voidReturn

:prefixFileHead
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] if not [%2]==[Ln] goto :error
  if not exist "%~1" goto :error
  if not [%3]==[] goto :error
  call :toBuffer
  call :addFileHead "%~1"
  if [%2]==[Ln] call :addLn
  call :addFile "%outfolder%\%buffer%"
  call :clearBuffer
goto :voidReturn

:prefixFileLn
setLocal
  if [%1]==[] goto :error
  if not exist "%~1" goto :error
  if not [%2]==[] goto :error
  call :prefixFile "%~1" Ln
goto :voidReturn

:prefixFileHeadLn
setLocal
  if [%1]==[] goto :error
  if not exist "%~1" goto :error
  if not [%2]==[] goto :error
  call :prefixFileHead "%~1" Ln
goto :voidReturn

:addString
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  (echo(addString incorrectly adds newline)
  call :addStringLn "%~1"
  REM (set "temp=%~1")
  REM (echo(%temp%)
  REM <NUL (set /p ".=   testing  ")
  rem echo|(set /p ".=   testing  ")
  rem (type %temp%)
  rem echo|(set /p ".=%temp: = %")
  rem (echo(%~1)
  rem echo|(set /p ".=%~1:#=##%")
  
  rem double check this doesnt add white spaces
  rem echo|(set /p ".=%~1") >>"%outfolder%\%outfile%"
  
  rem (echo(%~1)>>"%outfolder%\%outfile%"
  rem call :addFile "%~1"
  rem del "%outfolder%\%buffer%" >nul 2>&1
goto :voidReturn

:addStringLn
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  (echo(%~1)>>"%outfolder%\%outfile%"
goto :voidReturn

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
goto :voidReturn

:prefixStringLn
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  call :prefixString "%~1" Ln
goto :voidReturn

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
goto :voidReturn

:everyLinePrefixFileHead
setLocal disabledelayedexpansion
  if [%1]==[] goto :error
  if not exist "%~1" goto :error
  if not [%2]==[] goto :error
  call :toBuffer
  for /f "usebackq delims=" %%a in ("%outfolder%\%buffer%") do (
    call :addFileHead "%~1"
    (echo(%%a>>"%outfolder%\%outfile%")
  )
  call :clearBuffer
goto :voidReturn

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
goto :voidReturn

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
goto :voidReturn

:addPrefixFileHeadWithEveryLineOfFile
setLocal
  if [%1]==[] goto :error
  if not exist "%~1" goto :error
  if [%2]==[] goto :error
  if not exist "%~2" goto :error
  if not [%3]==[] goto :error
  for /f "usebackq delims=" %%a in ("%~2") do (
    call :addFileHead "%~1"
    (echo(%%a>>"%outfolder%\%outfile%")
  )
goto :voidReturn

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
goto :voidReturn

rem ##############
rem ### engine ###
rem ##############

goto :exit

:example
setLocal
  if [%1]==[] goto :error
  if not [%2]==[] goto :error
  (set "var1=%~1")
  (set "return=%var1% world")
goto :voidReturn

:exclamationsReturnFile
setLocal
  if [%1]==[] goto :error
  if not exist "%~1" goto :error
  if not [%2]==[] goto :error
  set /p "return="<"%~1"
  REM echo | findstr "^" "%~1"
  rem required: !return!
goto :exclamationsReturn

:returnFileFirstLine
setLocal
  if [%1]==[] goto :error
  if not exist "%~1" goto :error
  if not [%2]==[] goto :error
  set /p "return="<"%~1"
  REM requires :return to return=%return% before endlocal
goto :percentsReturn

:newFileFromString
setLocal
  if [%1]==[] goto :error
  if [%2]==[] goto :error
  if not [%3]==[] goto :error
  (echo(%~2)>"%~1"
goto :voidReturn

:error
(echo(Error: %0 %*)
endlocal & (set "return=")
if [%1]==[] exit /b 1
exit /b %~1

:voidReturn
rem return void
endlocal & (set "return=") & exit /b 0

:exclamationsReturn
rem use !return!
endlocal & (set "return=%return%") & exit /b 0

:percentsReturn
rem use %return%
(set "return=%return%") & endlocal & (set "return=%return%")
exit /b 0

:exit
if [%1]==[] exit /b 0
exit /b %~1
