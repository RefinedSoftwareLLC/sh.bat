@ (set "return=errorReturn") & setLocal enableDelayedExpansion & setLocal & echo off
call :init
pushd %~dp0

REM (set "outfolder=..")
REM (set "outfile=test.sh.bat")

REM call :newVersionFile ".\version.txt"

REM call :clear
REM call :prefixFileLn ".\file.prefix.txt"
REM call :addFile ".\bat.exit.txt"
REM call :prefixFile ".\file.prefix.txt"

REM call :addStringLn ".  ###  ."
REM call :addString "  ### " & call :addStringLn " ###  ."
REM call :prefixString ".  ### "

REM call :typeLn
REM call :typeString "done"
REM start notepad ..\test.sh.bat
REM goto :exit

REM ###################
REM ###  .bat mode  ###
REM ### Use "echo(" ###
REM ###################

(set "outfolder=..")
(set "sourcefolder=%outfolder%\source")

call :newVersionFile ".\version.txt"

call :compileAll "example"
goto :exit

:compileAll
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  call :newVersionFile "%sourcefolder%\%~1.version.txt"
  call :compileUser "%~1"
  call :compileAdmin "%~1"
  start notepad "%outfolder%\%~1.sh.bat"
goto :voidReturn

:compileUser
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  (set "outfile=%~1.sh.bat")
  call :clear
  REM .bat bootstrap
    call :prefixFileLn ".\file.prefix.txt"
    call :addPrefixFileHeadWithEveryLineOfFile ".\comment.prefix.run.bat.txt" ".\bat.try.txt"
    call :addPrefixFileHeadWithEveryLineOfFile ".\comment.prefix.run.bat.txt" ".\bat.finally.txt"
  REM start .ps1 skip over .sh
  call :addFileLn ".\ps1.skip.try.txt"
    REM .sh
      call :sh "%~1"
  REM end of .ps1 skip over .sh
  call :addFileLn ".\ps1.skip.finally.txt"
  REM .ps1
    call :ps1 "%~1"
goto :voidReturn

:compileAdmin
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  (set "outfile=%~1.admin.sh.bat")
  call :clear
  REM .bat bootstrap
    call :prefixFile ".\file.prefix.txt"
    call :addPrefixFileHeadWithEveryLineOfFile ".\comment.prefix.run.bat.txt" ".\bat.try.txt"
    call :addPrefixFileHeadWithEveryLineOfFile ".\comment.prefix.run.bat.txt" ".\bat.finally.txt"
  REM start .ps1 skip over .sh
  call :addFileLn ".\ps1.skip.try.txt"
    REM .sh
      call :sh "%~1"
  REM end of .ps1 skip over .sh
  call :addFileLn ".\ps1.skip.finally.txt"
  REM .ps1
    call :ps1 "%~1"
goto :voidReturn

:sh
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  call :addFile ".\sh.try.txt" & call :addFileHead ".\version.txt" & call :addStringLn " ###"
    call :addFileLn "%sourcefolder%\%~1.sh.txt"
  REM call :addFileLn ".\sh.finally.txt"
goto :voidReturn

:ps1
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  call :addFileLn ".\ps1.constants.txt"
  call :addFileLn ".\ps1.try.txt"
    call :addFileLn "%sourcefolder%\%~1.ps1.txt"
  call :addFileLn ".\ps1.finally.txt"
goto :voidReturn

REM ###############
REM ### library ###
REM ###############

:newVersionFile
setLocal enableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~3"]==[""] goto :error
  if ["%~2"]==[""] (
    if not exist "%~1" call :newFileFromString "%~1" "0.0.0.0"
    call :exclamationsReturnFileFirstLine "%~1"
    REM !return!=0.0.0.5
    call :newVersionFile "%~1" "!return!"
    goto :voidReturn
  )
  REM %~2       =0.0.0.5
  REM %~n2      =0.0.0
  REM %~x2      =.5
  (set "z=%~x2")
  (set "z=%z:~1%")
  (set /a "z=z+1")
  REM %z%       =6
  REM %~n2.%z%  =0.0.0.6
  call :newFileLnFromString "%~1" "%~n2.%z%"
goto :voidReturn

:clear
setLocal disableDelayedExpansion
  if not ["%~1"]==[""] goto :error
  >"%outfolder%\%outfile%" (type nul)
  REM copy /b nul "%outfolder%\%outfile%"
goto :voidReturn

:toBuffer
setLocal disableDelayedExpansion
  if not ["%~1"]==[""] goto :error
  call :delFile "%outfolder%\%outfile%1.temp"
  ren "%outfolder%\%outfile%" "%outfile%1.temp"
  call :clear
endlocal & (set "buffer=%outfile%1.temp") & exit /b 0

:clearBuffer
setLocal disableDelayedExpansion
  if not ["%~1"]==[""] goto :error
  call :delFile "%outfolder%\%buffer%"
goto :voidReturn

:addSp
setLocal disableDelayedExpansion
  if not ["%~1"]==[""] goto :error
  call :addString " "
goto :voidReturn

:addLn
setLocal disableDelayedExpansion
  if not ["%~1"]==[""] goto :error
  >>"%outfolder%\%outfile%" (echo()
goto :voidReturn

:addFile
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not exist "%~1" goto :error
  if not ["%~2"]==[""] goto :error
  copy /b "%outfolder%\%outfile%" + "%~1" "%outfolder%\%outfile%" >nul
goto :voidReturn

:addFileHead
setLocal enableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not exist "%~1" goto :error
  if not ["%~2"]==[""] goto :error
  call :exclamationsReturnFileFirstLine "%~1"
  call :addStringFoundInFile "!return!" "%~1"
goto :voidReturn

:addStringFoundInFile
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if ["%~2"]==[""] goto :error
  if not exist "%~2" goto :error
  if not ["%~3"]==[""] goto :error
  >>"%outfolder%\%outfile%" (findstr /b /C:"%~1" "%~2")
goto :voidReturn

:addStringFoundInFileLn
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if ["%~2"]==[""] goto :error
  if not exist "%~2" goto :error
  if not ["%~3"]==[""] goto :error
  call :addStringFoundInFile "%~1" "%~2"
  call :addLn
goto :voidReturn

:addFileLn
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not exist "%~1" goto :error
  if not ["%~2"]==[""] goto :error
  call :addFile "%~1"
  call :addLn
goto :voidReturn

:addFileHeadLn
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not exist "%~1" goto :error
  if not ["%~2"]==[""] goto :error
  call :addFileHead "%~1"
  call :addLn
goto :voidReturn

:prefixFile
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] if not [%2]==[Ln] goto :error
  if not exist "%~1" goto :error
  if not ["%~3"]==[""] goto :error
  call :toBuffer
  call :addFile "%~1"
  if [%2]==[Ln] call :addLn
  call :addFile "%outfolder%\%buffer%"
  call :clearBuffer
goto :voidReturn

:prefixFileHead
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] if not [%2]==[Ln] goto :error
  if not exist "%~1" goto :error
  if not ["%~3"]==[""] goto :error
  call :toBuffer
  call :addFileHead "%~1"
  if [%2]==[Ln] call :addLn
  call :addFile "%outfolder%\%buffer%"
  call :clearBuffer
goto :voidReturn

:prefixFileLn
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not exist "%~1" goto :error
  if not ["%~2"]==[""] goto :error
  call :prefixFile "%~1" Ln
goto :voidReturn

:prefixFileHeadLn
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not exist "%~1" goto :error
  if not ["%~2"]==[""] goto :error
  call :prefixFileHead "%~1" Ln
goto :voidReturn

:addString
setLocal enableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  if [%sub%]==[] call :setSub
  >type.temp (echo(%~1!sub!)
  copy type.temp /a type2.temp /b >nul
  >>"%outfolder%\%outfile%" (type type2.temp)
  del type.temp type2.temp
goto :voidReturn

:addStringLn
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  >>"%outfolder%\%outfile%" (echo(%~1)
(set "return=") & exit /b 0

:prefixString
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] if not [%2]==[Ln] goto :error
  if not ["%~3"]==[""] goto :error
  call :toBuffer
  call :addString "%~1"
  if [%2]==[Ln] call :addLn
  call :addFile "%outfolder%\%buffer%"
  call :clearBuffer
goto :voidReturn

:prefixStringLn
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  call :prefixString "%~1" Ln
goto :voidReturn

:everyLinePrefixFile
setLocal disabledelayedexpansion
  if ["%~1"]==[""] goto :error
  if not exist "%~1" goto :error
  if not ["%~2"]==[""] goto :error
  call :toBuffer
  for /f "usebackq delims=" %%a in ("%outfolder%\%buffer%") do (
    call :addFile "%~1"
    >>"%outfolder%\%outfile%" (echo(%%a)
  )
  call :clearBuffer
goto :voidReturn

:everyLinePrefixFileHead
setLocal disabledelayedexpansion
  if ["%~1"]==[""] goto :error
  if not exist "%~1" goto :error
  if not ["%~2"]==[""] goto :error
  call :toBuffer
  for /f "usebackq delims=" %%a in ("%outfolder%\%buffer%") do (
    call :addFileHead "%~1"
    >>"%outfolder%\%outfile%" (echo(%%a)
  )
  call :clearBuffer
goto :voidReturn

:everyLinePrefixString
setLocal disabledelayedexpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  call :toBuffer
  for /f "usebackq delims=" %%a in ("%outfolder%\%buffer%") do (
    call :addString "%~1"
    >>"%outfolder%\%outfile%" (echo(%%a)
  )
  call :clearBuffer
goto :voidReturn

:addPrefixFileWithEveryLineOfFile
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not exist "%~1" goto :error
  if ["%~2"]==[""] goto :error
  if not exist "%~2" goto :error
  if not ["%~3"]==[""] goto :error
  for /f "usebackq delims=" %%a in ("%~2") do (
    call :addFile "%~1"
    >>"%outfolder%\%outfile%" (echo(%%a)
  )
goto :voidReturn

:addPrefixFileHeadWithEveryLineOfFile
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not exist "%~1" goto :error
  if ["%~2"]==[""] goto :error
  if not exist "%~2" goto :error
  if not ["%~3"]==[""] goto :error
  for /f "usebackq delims=" %%a in ("%~2") do (
    call :addFileHead "%~1"
    >>"%outfolder%\%outfile%" (echo(%%a)
  )
goto :voidReturn

:addPrefixStringWithEveryLineOfFile
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if ["%~2"]==[""] goto :error
  if not exist "%~2" goto :error
  if not ["%~3"]==[""] goto :error
  for /f "usebackq delims=" %%a in ("%~2") do (
    call :addString "%~1"
    >>"%outfolder%\%outfile%" (echo(%%a)
  )
goto :voidReturn

REM ##############
REM ### engine ###
REM ##############

goto :exit

:example
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  (set "var1=%~1")
  (set "return=%var1% world")
goto :voidReturn

:init
setLocal disableDelayedExpansion
  call :setSub
  call :setLf
goto :voidReturn

:typeString
setLocal enableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  if [%sub%]==[] call :setSub
  >type.temp (echo(%~1!sub!)
  copy type.temp /a type2.temp /b >nul
  type type2.temp
  del type.temp type2.temp
goto :voidReturn

:typeStringLn
setLocal enableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  (echo(%1)
goto :voidReturn

:typeSp
setLocal enableDelayedExpansion
  if not ["%~1"]==[""] goto :error
  call :typeString " "
goto :voidReturn

:typeLn
setLocal enableDelayedExpansion
  if not ["%~1"]==[""] goto :error
  (echo()
goto :voidReturn

:typeFile
setLocal enableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  type "%~1"
goto :voidReturn

:typeFileLn
setLocal enableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  type "%~1"
  call :typeLn
goto :voidReturn

:exclamationsReturnFile
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not exist "%~1" goto :error
  if not ["%~2"]==[""] goto :error
  <"%~1" (set /p "return=")
  REM echo | findstr "^" "%~1"
  REM required: !return!
goto :exclamationsReturn

:exclamationsReturnFileFirstLine
setLocal enableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not exist "%~1" goto :error
  if not ["%~2"]==[""] goto :error
  if [%sub%]==[] call :setSub
  for /F "usebackq tokens=*" %%a in ("%~1") do (
    set "return=%%a"
  )
goto :exclamationsReturn

:setReturnString
setLocal enableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  set "return=%~1"
  REM call :newFileFromString "line.temp" "%~1"
  REM <"line.temp" (set /p "return=")
goto :exclamationsReturn

:setReturnFile
setLocal enableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  <"%~1" (set /p "return=")
goto :exclamationsReturn

:newFileFromString
setLocal enableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if ["%~2"]==[""] goto :error
  if not ["%~3"]==[""] goto :error
  if [%sub%]==[] call :setSub
  set "t=%~2"
  >type.temp (echo(!t!!sub!)
  copy type.temp /a "%~1" /b >nul
  del type.temp
goto :voidReturn

:newFileLnFromString
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if ["%~2"]==[""] goto :error
  if not ["%~3"]==[""] goto :error
  >"%~1" (echo(%~2)
goto :voidReturn

:delFile
setLocal disableDelayedExpansion
  if ["%~1"]==[""] goto :error
  if not ["%~2"]==[""] goto :error
  del "%~1" >nul 2>&1
goto :voidReturn

:setSub
copy nul sub.temp /a >nul
  REM SUB, EOF, Ctrl-Z, 0x1A, decimal 26
  for /F %%a in (sub.temp) DO (
     set "sub=%%a"
  )
  del sub.temp
exit /b

:setLf
  set lf=^


  ::Above 2 blank lines are required - do not remove or indent
  set ^"\n=^^^%LF%%LF%^%LF%%LF%^^"
exit /b 0

:error
(echo(Error: %0 %*)
endlocal & (set "return=")
if ["%~1"]==[""] exit /b 1
exit /b %~1

:voidReturn
REM return void
endlocal & (set "return=") & exit /b 0

:exclamationsReturn
REM use !return!
endlocal & (set "return=%return%") & exit /b 0

:percentsReturn
REM use %return%
(set "return=%return%") & endlocal & (set "return=%return%")
exit /b 0

:exit
if ["%~1"]==[""] exit /b 0
exit /b %~1
