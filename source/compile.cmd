@ setLocal enableDelayedExpansion & echo off

REM #################
REM ### .cmd mode ###
REM #################

cd %~dp0
(set outfolder=..)
(set outfile=test.sh.bat)

call :clear
REM .bat bootstrap
call :addFileLn .\bat.try.txt
call :addFileLn .\bat.finally.txt
call :everyLinePrefixFile .\comment.prefix.run.bat.txt
call :prefixFile .\file.prefix.bat.txt
REM start .ps1 skip over .sh
call :addFileLn .\ps1.skip.try.txt
  call :addFileLn .\sh.try.txt
    call :addFileLn .\sh.example.txt
  REM call :addFileLn .\sh.finally.txt
REM end of .ps1 skip over .sh
call :addFileLn .\ps1.skip.finally.txt

goto :exit

:clear
setLocal
type nul >"%outfolder%\%outfile%"
REM copy /b nul "%outfolder%\%outfile%"
REM echo|(set /p=) >"%outfolder%\%outfile%"
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
(echo.)>>"%outfolder%\%outfile%"
goto :return

:addFile
setLocal
if [%1]==[] goto :error
copy /b "%outfolder%\%outfile%" + "%1" "%outfolder%\%outfile%" >nul
goto :return

:addFileLn
setLocal
if [%1]==[] goto :error
copy /b "%outfolder%\%outfile%" + "%1" "%outfolder%\%outfile%" >nul
(echo.)>>"%outfolder%\%outfile%"
goto :return

:prefixFile
setLocal
if [%1]==[] goto :error
copy /b "%1" + "%outfolder%\%outfile%" "%outfolder%\%outfile%" >nul
goto :return

:addString
setLocal
if [%1]==[] goto :error
echo|(set /p=%1) >>"%outfolder%\%outfile%"
goto :return

:addStringLn
setLocal
if [%1]==[] goto :error
echo|(set /p=%1) >>"%outfolder%\%outfile%"
(echo.)>>"%outfolder%\%outfile%"
goto :return

:prefixString
setLocal
if [%1]==[] goto :error
call :toBuffer
echo|(set /p=%1) >>"%outfolder%\%outfile%"
call :addFile "%outfolder%\%buffer%"
call :clearBuffer
goto :return

:everyLinePrefixFile
setLocal
if [%1]==[] goto :error
call :toBuffer
for /f "usebackq delims=" %%a in ("%outfolder%\%buffer%") do (
  call :addFile %1
  echo.%%a >>"%outfolder%\%outfile%"
)
call :clearBuffer
goto :return

REM ################
REM ### .cmd end ###
REM ################

goto :exit

:example
setLocal
if [%1]==[] goto :error
(set var1=%1)
(set return=%var1% world)
goto :return

:error
echo.Error: %0 %*
endlocal & (set return=)
if [%1]==[] exit /b 1
exit /b %1

:return
endlocal & (set return=%return%) & exit /b 0

:exit
if [%1]==[] exit /b 0
exit /b %1