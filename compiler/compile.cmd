@ setLocal & echo off
cd %~dp0

(set test=  ..)

setlocal enableextensions enabledelayedexpansion

set "count=0"
for %%a in (%test%) do (
    set /a "count+=1"
    <nul set /p ".=working on file !count!"
)
setlocal disabledelayedexpansion

(echo(%test%)
echo|set /p.=%test%
echo|set /p.="%test%"
0>NUL set /p.=%test%
0>NUL set /p.="%test%"
<NUL set /p.=%test%
<NUL set /p.="%test%"
<NUL set /p.=%test%|echo
<NUL set /p.="%test%"|echo

call :addStringLn ".  ###  ."
call :addString "  ### " & call :addStringLn " ###  ."
call :prefixString ".  ### "

(echo()
(echo(done)
goto :exit

rem ###################
rem ###  .cmd mode  ###
rem ### Use "echo(" ###
rem ###################

(set outfolder=..)
(set outfile=test.sh.bat)

call :newVersion ".\version.txt"

call :clear
rem .bat bootstrap
  call :prefixFile ".\file.prefix.txt"
  call :addPrefixFileToEveryLineOfFile ".\comment.prefix.run.bat.txt" ".\bat.try.txt"
  call :addPrefixFileToEveryLineOfFile ".\comment.prefix.run.bat.txt" ".\bat.finally.txt"
rem start .ps1 skip over .sh
call :addFileLn ".\ps1.skip.try.txt"
  rem .sh
    call :sh
rem end of .ps1 skip over .sh
call :addFileLn ".\ps1.skip.finally.txt"
rem .ps1
  call :ps1

goto :exit

:sh
setLocal
  call :addFile ".\sh.try.txt" & call :addFile ".\version.txt" & call :addStringLn " ###"
  call :addFileLn ".\sh.example.txt"
  rem call :addFileLn ".\sh.finally.txt"
goto :return

:ps1
setLocal
  call :addFileLn ".\ps1.constants.txt"
  call :addFileLn ".\ps1.try.txt"
    call :addFileLn ".\ps1.example.txt"
  call :addFileLn ".\ps1.finally.txt"
goto :return

rem ###############
rem ### library ###
rem ###############



:newVersion
setLocal EnableDelayedExpansion
  if [%1]==[] goto :error
  if [%2]==[] (
    if not exist "%1" (echo(0.0.0.0)>"%1"
    set /p az=<"%1"
    rem %az%    =0.0.0.5
    call :newVersion "%1" "!az!"
    goto :return
  )
  rem %2      =0.0.0.5
  rem %~n2    =0.0.0
  rem %~x2    =.5
  set z=%~x2
  set z=%z:~1%
  set /a z=z+1
  rem %z%     =6
  set az=%~n2.%z%
  rem %~n2.%z%=0.0.0.6
  (echo(%az%)>"%1"
goto :return

:clear
setLocal
  type nul >"%outfolder%\%outfile%"
  rem copy /b nul "%outfolder%\%outfile%"
goto :return

:toBuffer
setLocal
  del "%outfolder%\%outfile%.temp" >nul 2>&1
  ren "%outfolder%\%outfile%" "%outfile%.temp"
  call :clear
endlocal & (set buffer=%outfile%.temp) & exit /b 0

:clearBuffer
setLocal
  del "%outfolder%\%buffer%" >nul 2>&1
goto :return

:addLn
setLocal
  (echo()>>"%outfolder%\%outfile%"
goto :return

:addFile
setLocal
  if [%1]==[] goto :error
  copy /b "%outfolder%\%outfile%" + "%1" "%outfolder%\%outfile%" >nul
goto :return

:addFileLn
setLocal
  if [%1]==[] goto :error
  call :addFile "%1"
  call :addLn "%1"
goto :return

:prefixFile
setLocal
  if [%1]==[] goto :error
  call :toBuffer
  call :addFile "%1"
  if not [%2]==[] call :addLn "%1"
  call :addFile "%outfolder%\%buffer%"
  call :clearBuffer
goto :return

:prefixFileLN
setLocal
  if [%1]==[] goto :error
  call :prefixFile "%1" ""
goto :return

:addString
setLocal
  if [%1]==[] goto :error
  echo addString incorrectly adds newline
  call :addStringLn "%1"
  REM set temp=%~1
  REM (echo(%temp%)
  REM <NUL set /p.="   testing  "
  rem echo|set /p.="   testing  "
  rem (type %temp%)
  rem echo|(set /p.=%temp: = %)
  rem (echo(%~1)
  rem echo|(set /p.=%1:#=##%)
  rem echo|(set /p.= %~1) >>"%outfolder%\%outfile%"
  rem (echo(%~1)>>"%outfolder%\%outfile%"
  rem call :addFile "%1"
  rem del "%outfolder%\%buffer%" >nul 2>&1
goto :return

:addStringLn
setLocal
  if [%1]==[] goto :error
  (echo(%~1)>>"%outfolder%\%outfile%"
goto :return

:prefixString
setLocal
  if [%1]==[] goto :error
  call :toBuffer
  call :addString "%1"
  if not [%2]==[] call :addLn "%1"
  call :addFile "%outfolder%\%buffer%"
  call :clearBuffer
goto :return

:prefixStringLN
setLocal
  if [%1]==[] goto :error
  call :prefixString "%1" ""
goto :return

:everyLinePrefixFile
setLocal disabledelayedexpansion
if [%1]==[] goto :error
  call :toBuffer
  for /f "usebackq delims=" %%a in ("%outfolder%\%buffer%") do (
    call :addFile "%1"
    echo(%%a >>"%outfolder%\%outfile%"
  )
  call :clearBuffer
goto :return

:everyLinePrefixString
setLocal disabledelayedexpansion
if [%1]==[] goto :error
  call :toBuffer
  for /f "usebackq delims=" %%a in ("%outfolder%\%buffer%") do (
    call :addString "%1"
    echo(%%a >>"%outfolder%\%outfile%"
  )
  call :clearBuffer
goto :return

:addPrefixFileToEveryLineOfFile
setLocal
  if [%1]==[] goto :error
  if [%2]==[] goto :error
  call :toBuffer
  for /f "usebackq delims=" %%a in ("%2") do (
    call :addFile "%1"
    echo(%%a >>"%outfolder%\%outfile%"
  )
  call :clearBuffer
goto :return

:addPrefixStringToEveryLineOfFile
setLocal
  if [%1]==[] goto :error
  if [%2]==[] goto :error
  call :toBuffer
  for /f "usebackq delims=" %%a in ("%2") do (
    call :addString "%1"
    echo(%%a >>"%outfolder%\%outfile%"
  )
  call :clearBuffer
goto :return

rem ##############
rem ### engine ###
rem ##############

goto :exit

:example
setLocal
  if [%1]==[] goto :error
  (set var1=%1)
  (set return=%var1% world)
goto :return

:error
echo(Error: %0 %*
endlocal & (set return=)
if [%1]==[] exit /b 1
exit /b %1

:return
endlocal & (set return=%return%) & exit /b 0

:exit
if [%1]==[] exit /b 0
exit /b %1