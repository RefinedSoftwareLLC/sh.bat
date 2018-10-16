@ echo off & goto :init
:start

REM ###################
REM ###  .bat mode  ###
REM ### Use "echo(" ###
REM ###################

echo(
echo(compile :start
echo(
call :newVersionFile "compiler\version.txt"
call :compileAll "example"

start notepad "example.sh.bat"
goto :exit

:compileAll
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :newVersionFile "%sourceFolder%\!a1!.version.txt"
  call :compileUser "!a1!"
  call :compileAdmin "!a1!"
  
goto :voidReturn

:compileUser
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :setOutFile "!a1!.sh.bat"
  call :clear
  REM .bat bootstrap
    call :prefixFileLn "compiler\file.prefix.txt"
    call :addPrefixFileHeadWithEveryLineOfFile "compiler\comment.prefix.run.bat.txt" "compiler\bat.try.txt"
    call :addPrefixFileHeadWithEveryLineOfFile "compiler\comment.prefix.run.bat.txt" "compiler\bat.finally.txt"
  REM start .ps1 skip over .sh
  call :addFileLn "compiler\ps1.skip.try.txt"
    REM .sh
      call :sh "!a1!"
  REM end of .ps1 skip over .sh
  call :addFileLn "compiler\ps1.skip.finally.txt"
  REM .ps1
    call :ps1 "!a1!"
goto :voidReturn

:compileAdmin
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :setOutFile "!a1!.admin.sh.bat"
  call :clear
  REM .bat bootstrap
    call :prefixFile "compiler\file.prefix.txt"
    call :addPrefixFileHeadWithEveryLineOfFile "compiler\comment.prefix.run.bat.txt" "compiler\bat.try.txt"
    call :addPrefixFileHeadWithEveryLineOfFile "compiler\comment.prefix.run.bat.txt" "compiler\bat.finally.txt"
  REM start .ps1 skip over .sh
  call :addFileLn "compiler\ps1.skip.try.txt"
    REM .sh
      call :sh "!a1!"
  REM end of .ps1 skip over .sh
  call :addFileLn "compiler\ps1.skip.finally.txt"
  REM .ps1
    call :ps1 "!a1!"
goto :voidReturn

:sh
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :addFile "compiler\sh.try.txt" & call :addFileHead "compiler\version.txt"
  REM call :addStringLn " ###"
    setLocal disableDelayedExpansion
      >>"%outFile%" (echo( ###)
    endLocal
  REM call :addStringLn
    call :addFileLn "%sourceFolder%\!a1!.sh.txt"
  REM call :addFileLn "compiler\sh.finally.txt"
goto :voidReturn

:ps1
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :addFileLn "compiler\ps1.constants.txt"
  call :addFileLn "compiler\ps1.try.txt"
    call :addFileLn "%sourceFolder%\!a1!.ps1.txt"
  call :addFileLn "compiler\ps1.finally.txt"
goto :voidReturn

REM ###############
REM ### library ###
REM ###############

:newVersionFile
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~3"]==[""] goto :errorReturn
  set "a2=%~2" & if ["%~2"]==[""] (
    (set "return=")
    if not exist "!a1!" call :newFileFromString "!a1!" "0.0.0.0"
    call :exclamationsReturnFileFirstLine "!a1!"
    REM !return!=0.0.0.5
    if ["!return!"]==[""] goto :errorReturn
    if not ["!return!"]==[""] call :newVersionFile "!a1!" "!return!"
    goto :voidReturn
  )
  REM !a2!      =0.0.0.5
  REM %~n2      =0.0.0
  REM %~x2      =.5
  (set "z=%~x2")
  (set "z=%z:~1%")
  (set /a "z=z+1")
  REM %z%       =6
  REM %~n2.%z%  =0.0.0.6
  call :newFileLnFromString "!a1!" "%~n2.%z%"
goto :voidReturn

:clear
setLocal
  if not ["%~1"]==[""] goto :errorReturn
  >"%outFile%" (type nul)
  REM copy /b nul "%outFile%"
goto :voidReturn

:toBuffer
setLocal
  if not ["%~1"]==[""] goto :errorReturn
  call :deleleFile "buffer.temp"
  call :renameFileToFile "%outFile%" ".\buffer.temp"
  call :clear
goto :voidReturn

:clearBuffer
setLocal
  if not ["%~1"]==[""] goto :errorReturn
  call :deleleFile "buffer.temp"
goto :voidReturn

REM :addSp
REM setLocal
  REM if not ["%~1"]==[""] goto :errorReturn
  REM call :addString " "
REM goto :voidReturn

:addLn
setLocal
  if not ["%~1"]==[""] goto :errorReturn
  setLocal disableDelayedExpansion
    >>"%outFile%" (echo()
  endLocal
goto :voidReturn

:addFile
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  copy /b "%outFile%" + "!a1!" "%outFile%" >nul
goto :voidReturn

:addFileHead
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :exclamationsReturnFileFirstLine "!a1!"
  REM call :addString "!return!"
    if [%sub%]==[] call :setSub
    >type.temp (echo(!return!!sub!)
    copy type.temp /a type2.temp /b >nul
    >>"%outFile%" (type type2.temp)
    del type.temp type2.temp
  REM end :addString
    
goto :voidReturn

REM :addStringFoundInFile
REM setLocal
  REM set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  REM set "a2=%~2" & if ["%~2"]==[""] goto :errorReturn
  REM if not exist "!a2!" goto :errorReturn
  REM if not ["%~3"]==[""] goto :errorReturn
  REM >>"%outFile%" (findstr /b /C:"!a1!" "!a2!")
REM goto :voidReturn

:addFileLn
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :addFile "!a1!"
  call :addLn
goto :voidReturn

:addFileHeadLn
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :addFileHead "!a1!"
  call :addLn
goto :voidReturn

:prefixFile
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  set "a2=%~2" & if not ["%~2"]==[""] if not ["!a2!"]==["ln"] goto :errorReturn
  if not ["%~3"]==[""] goto :errorReturn
  call :toBuffer
  call :addFile "!a1!"
  if ["!a2!"]==["ln"] call :addLn
  call :addFile "buffer.temp"
  call :clearBuffer
goto :voidReturn

:prefixFileHead
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  set "a2=%~2" & if not ["%~2"]==[""] if not ["!a2!"]==["ln"] goto :errorReturn
  if not ["%~3"]==[""] goto :errorReturn
  call :toBuffer
  call :addFileHead "!a1!"
  if ["!a2!"]==["ln"] call :addLn
  call :addFile "buffer.temp"
  call :clearBuffer
goto :voidReturn

:prefixFileLn
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :prefixFile "!a1!" "ln"
goto :voidReturn

:prefixFileHeadLn
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :prefixFileHead "!a1!" "ln"
goto :voidReturn

REM :addVariable
REM setLocal
  REM set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  REM if not ["%~2"]==[""] goto :errorReturn
  REM if [%sub%]==[] call :setSub
  REM >type.temp (echo(!%a1%!!sub!)
  REM copy type.temp /a type2.temp /b >nul
  REM >>"%outFile%" (type type2.temp)
  REM del type.temp type2.temp
REM goto :voidReturn

REM :addString
REM setLocal
  REM set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  REM if not ["%~2"]==[""] goto :errorReturn
  REM if [%sub%]==[] call :setSub
  REM >type.temp (echo(!a1!!sub!)
  REM copy type.temp /a type2.temp /b >nul
  REM >>"%outFile%" (type type2.temp)
  REM del type.temp type2.temp
REM goto :voidReturn

REM :addVariableLn
REM setlocal
  REM set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  REM if not ["%~2"]==[""] goto :errorReturn
  REM setLocal disableDelayedExpansion
    REM >>"%outFile%" (echo(!%a1%!)
  REM endLocal
REM goto :voidReturn

:addStringLn
setlocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  setLocal disableDelayedExpansion
    >>"%outFile%" (echo(%~1)
  endLocal
goto :voidReturn

:prefixString
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  set "a2=%~2" & if not ["%~2"]==[""] if not ["!a2!"]==["ln"] goto :errorReturn
  if not ["%~3"]==[""] goto :errorReturn
  call :toBuffer
  REM call :addString "!a1!"
    if [%sub%]==[] call :setSub
    >type.temp (echo(!a1!!sub!)
    copy type.temp /a type2.temp /b >nul
    >>"%outFile%" (type type2.temp)
    del type.temp type2.temp
  REM end :addString
  
  if ["!a2!"]==["ln"] call :addLn
  call :addFile "buffer.temp"
  call :clearBuffer
goto :voidReturn

:prefixStringLn
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :prefixString "!a1!" "ln"
goto :voidReturn

:everyLinePrefixFile
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :toBuffer
  for /f "usebackq delims=" %%a in ("buffer.temp") do (set "line=%%a"
    call :addFile "!a1!"
    REM call :addString "!line!"
      if [%sub%]==[] call :setSub
      >type.temp (echo(!line!!sub!)
      copy type.temp /a type2.temp /b >nul
      >>"%outFile%" (type type2.temp)
      del type.temp type2.temp
    REM end :addString
  )
  call :clearBuffer
goto :voidReturn

:everyLinePrefixFileHead
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :toBuffer
  for /f "usebackq delims=" %%a in ("buffer.temp") do (set "line=%%a"
    call :addFileHead "!a1!"
    REM call :addString "!line!"
      if [%sub%]==[] call :setSub
      >type.temp (echo(!line!!sub!)
      copy type.temp /a type2.temp /b >nul
      >>"%outFile%" (type type2.temp)
      del type.temp type2.temp
    REM end :addString
  )
  call :clearBuffer
goto :voidReturn

:everyLinePrefixString
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :toBuffer
  for /f "usebackq delims=" %%a in ("buffer.temp") do (set "line=%%a"
    REM call :addString "!a1!"
      if [%sub%]==[] call :setSub
      >type.temp (echo(!a1!!sub!)
      copy type.temp /a type2.temp /b >nul
      >>"%outFile%" (type type2.temp)
      del type.temp type2.temp
    REM end :addString
    REM call :addString "!line!"
      if [%sub%]==[] call :setSub
      >type.temp (echo(!line!!sub!)
      copy type.temp /a type2.temp /b >nul
      >>"%outFile%" (type type2.temp)
      del type.temp type2.temp
    REM end :addString
  )
  call :clearBuffer
goto :voidReturn

:addPrefixFileWithEveryLineOfFile
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  set "a2=%~2" & if ["%~2"]==[""] goto :errorReturn
  if not exist "!a2!" goto :errorReturn
  if not ["%~3"]==[""] goto :errorReturn
  for /f "usebackq delims=" %%a in ("!a2!") do (set "line=%%a"
    call :addFile "!a1!"
    REM call :addString "!line!"
      if [%sub%]==[] call :setSub
      >type.temp (echo(!line!!sub!)
      copy type.temp /a type2.temp /b >nul
      >>"%outFile%" (type type2.temp)
      del type.temp type2.temp
    REM end :addString
  )
goto :voidReturn

:addPrefixFileHeadWithEveryLineOfFile
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  set "a2=%~2" & if ["%~2"]==[""] goto :errorReturn
  if not exist "!a2!" goto :errorReturn
  if not ["%~3"]==[""] goto :errorReturn  
  for /f "usebackq delims=" %%a in ("!a2!") do (set "line=%%a"
    REM call :typeFile "!a1!"
    call :addFileHead "^!a1^!"
    REM call :addStringLn "^!line^!"
      setLocal disableDelayedExpansion
        >>"%outFile%" (echo(%%a)
      endLocal
    REM call :addStringLn
  )
  
goto :voidReturn

:addPrefixStringWithEveryLineOfFile
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  set "a2=%~2" & if ["%~2"]==[""] goto :errorReturn
  if not exist "!a2!" goto :errorReturn
  if not ["%~3"]==[""] goto :errorReturn
  for /f "usebackq delims=" %%a in ("!a2!") do (set "line=%%a"
    REM call :addString "!a1!"
      if [%sub%]==[] call :setSub
      >type.temp (echo(!a1!!sub!)
      copy type.temp /a type2.temp /b >nul
      >>"%outFile%" (type type2.temp)
      del type.temp type2.temp
    REM end :addString
    REM call :addString "!line!"
      if [%sub%]==[] call :setSub
      >type.temp (echo(!line!!sub!)
      copy type.temp /a type2.temp /b >nul
      >>"%outFile%" (type type2.temp)
      del type.temp type2.temp
    REM end :addString
  )
goto :voidReturn

REM ##############
REM ### engine ###
REM ##############

goto :exit

:example
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  (set "var1=!a1!")
  (set "return=%var1% world")
goto :voidReturn

:init
setLocal enableDelayedExpansion
(set "setLocal=1")
(set "a1=errorA1") & (set "a2=errorA2") & (set "a3=errorA3") & (set "a4=errorA4") & (set "a5=errorA5") & (set "a6=errorA6") & (set "a7=errorA7") & (set "a8=errorA8") & (set "a9=errorA9")
(set "export=errorExport")
(set "return=errorReturn")
(set "lf=errorLf")
setLocal
(set /a "setLocal=setLocal+1")
REM Above 2 setLocals are required - do not remove
pushd %~dp0
call :setOutFolder ".."
(set "sourceFolder=.\source")
call :setLf
call :setSub
if not ["%~1"]==[""] (echo(Error: %0 %*)

REM start starting
call :start
REM start exited

echo(compile :exit
if not ["%setLocal%"]==["2"] (
  echo(setLocal depth %setLocal% but should be 2
  exit /b 1
)
exit /b 0

:setOutFolder
REM no setLocal, a1, a2, :return
  if ["%~1"]==[""] (
    (echo(Error: %0 %*)
    exit /b 1
  )
  if not ["%~2"]==[""] (
    (echo(Error: %0 %*)
    exit /b 1
  )
  popd
  pushd "%~dp0\%~1"
exit /b 0

:setOutFile
REM no setLocal, a1, a2, :return
  if ["%~1"]==[""] (
    (echo(Error: %0 %*)
    exit /b 1
  )
  if not ["%~2"]==[""] (
    (echo(Error: %0 %*)
    exit /b 1
  )
  (set "outFile=%~1")
exit /b 0

:typeString
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  if [%sub%]==[] call :setSub
  >type.temp (echo(!a1!!sub!)
  copy type.temp /a type2.temp /b >nul
  type type2.temp
  del type.temp type2.temp
goto :voidReturn

:typeStringLn
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  (echo(!a1!)
goto :voidReturn

:typeSp
setLocal
  if not ["%~1"]==[""] goto :errorReturn
  call :typeString " "
goto :voidReturn

:typeLn
setLocal
  if not ["%~1"]==[""] goto :errorReturn
  (echo()
goto :voidReturn

:typeFile
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  type "!a1!"
goto :voidReturn

:typeFileLn
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  type "!a1!"
  call :typeLn
goto :voidReturn

:escapeString
REM no setLocal, a1, a2, :return
  if ["%~1"]==[""] (
    (echo(Error: %0 %*)
    exit /b 1
  )
  set "%~1=!%~1:%%=%%%%!"
  set "%~1=!%~1:&=^&!"
  REM set "%~1=!%~1:^^!=!"
  REM set "%~1=!%~1:t=!"
  REM echo(# !%~1!
exit /b 0

:exclamationsReturnFile
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  <"!a1!" (set /p "return=")
  REM findstr "^" "!a1!"
  REM required: !return!
goto :exclamationsReturn

:exclamationsReturnFileLineCount
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  if [%sub%]==[] call :setSub
  set "i=0"
  for /F "usebackq tokens=*" %%a in ("!a1!") do (set "line=%%a"
    (set /a "i=i+1")
  )
  set "return=%i%"
goto :exclamationsReturn

:exclamationsReturnFileLastLine
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  if [%sub%]==[] call :setSub
  set "i=0"
  for /F "usebackq tokens=*" %%a in ("!a1!") do (set "line=%%a"
    (set /a "i=i+1")
    set "return=!line!"
  )
  if ["%i%"]==["0"] goto :errorReturn
  :exclamationsReturnFileLastLineBreak
goto :exclamationsReturn

:exclamationsReturnFileFirstLine
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  if [%sub%]==[] call :setSub
  for /F "usebackq tokens=*" %%a in ("!a1!") do (set "line=%%a"
    set "return=!line!"
    goto :exclamationsReturnFileFirstLineBreak
  )
  goto :errorReturn
  :exclamationsReturnFileFirstLineBreak
goto :exclamationsReturn

:exclamationsReturnFileNthLine
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  if [%sub%]==[] call :setSub
  set "i=0"
  for /F "usebackq tokens=*" %%a in ("!a1!") do (set "line=%%a"
    (set /a "i=i+1")
    (set "return=!line!")
    if ["!a1!"]==["%i%"] goto :exclamationsReturnFileNthLineBreak
  )
  goto :errorReturn
  :exclamationsReturnFileNthLineBreak
goto :exclamationsReturn

:setReturnString
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  set "return=!a1!"
  REM call :newFileFromString "line.temp" "!a1!"
  REM <"line.temp" (set /p "return=")
goto :exclamationsReturn

:setReturnFile
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  <"!a1!" (set /p "return=")
goto :exclamationsReturn

:renameFileToFile
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  set "a2=%~2" & if ["%~2"]==[""] goto :errorReturn
  if not ["%~3"]==[""] goto :errorReturn
  call :deleleFile "%~nx2"
  rename "!a1!" "%~nx2"
goto :voidReturn

:newFileFromString
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  set "a2=%~2" & if ["%~2"]==[""] goto :errorReturn
  if not ["%~3"]==[""] goto :errorReturn
  if [%sub%]==[] call :setSub
  >type.temp (echo(!a2!!sub!)
  copy type.temp /a "!a1!" /b >nul
  del type.temp
goto :voidReturn

:newFileLnFromString
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  set "a2=%~2" & if ["%~2"]==[""] goto :errorReturn
  if not ["%~3"]==[""] goto :errorReturn
  >"!a1!" (echo(!a2!)
goto :voidReturn

:deleleFile
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  del "!a1!" >nul 2>&1
  if exist "!a1!" goto :errorReturn
goto :voidReturn

:setSub
setLocal
  REM SUB, EOF, Ctrl-Z, 0x1A, decimal 26
  if not ["%~1"]==[""] goto :errorReturn
  copy nul sub.temp /a >nul
  for /F %%a in (sub.temp) DO (set "line=%%a"
     set "sub=!line!"
  )
  del sub.temp
  (set "export=sub")
goto :exportReturn

:setLf
REM no setLocal, a1, a2, :return
  if not ["%~1"]==[""] (
    (echo(Error: %0 %*)
    exit /b 1
  )
  set lf=^


  REM Above 2 blank lines are required - do not remove or indent
  REM (set "export=lf")
exit /b 0

REM :set\n
REM setLocal
  REM if not ["%~1"]==[""] goto :errorReturn
  REM if [%lf%]==[] call :setLf
  REM set ^"\n=^^^%LF%%LF%^%LF%%LF%^^"
  REM (set "export=\n")
REM goto :exportReturn

:errorReturn
set "a1=%~1"
(echo(Error: %0 %*)
endlocal & (set "return=")
if ["%~1"]==[""] exit /b 1
exit /b !a1!

:voidReturn
REM return void
endlocal & (set "return=") & exit /b 0

:exclamationsReturn
REM use !return!
endlocal & (set "return=%return%") & exit /b 0

:percentsReturn
REM use %return%
(set "return=%return%")
REM do not merge into single line
endlocal & (set "return=%return%") & exit /b 0

:exportReturn
REM use !variable!
if ["%export%"]==[""] goto :errorReturn
(set "return=!%export%!")
endlocal & (set "%export%=%return%")
(set "return=") & exit /b 0

:exit
set "a1=%~1" & if ["%~1"]==[""] exit /b 0
exit /b !a1!
