@ echo off & goto :init
:start

REM ###################
REM ###  .bat mode  ###
REM ### Use "echo(" ###
REM ###################

echo(
echo(compile :start
echo(

call :newVersionFile "%compilerFolder%\version.txt"

call :compileMd "README"
call :deleleFile "..\README.md"
move /Y "README.md" "..\README.md" >nul

call :compileBat "compile"
call :deleleFile "..\compile.bat"
move /Y "compile.bat" "..\compile.bat" >nul

call :deleteCompiledFolderContents

call :compileAllNonprivileged "example"
call :compileAllNonprivileged "unmute"
call :compileAllNonprivileged "mute"

REM start notepad "example.sh.bat"
goto :exit

:compileAllNonprivileged
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :newVersionFile "%sourceFolder%\!a1!.version.txt"
  call :compileSh "!a1!"
  call :compilePs1 "!a1!"
  call :compileShPs1 "!a1!"
  REM call :compileShAdmin "!a1!"
  REM call :compileRootPs1 "!a1!"
  REM call :compileRootAdmin "!a1!"
goto :voidReturn

:compileMd
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :setOutFile "!a1!.md"
  call :clear
  REM .md
    call :addFileLn "%sourceFolder%\!a1!.md.txt"
goto :voidReturn

:compileSh
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :setOutFile "!a1!"
  call :clear
  REM .sh
    call :prefixFile "%compilerFolder%\file.prefix.sh.txt"
    call :shWithoutPs1 "!a1!"
goto :voidReturn

:compilePs1
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :setOutFile "!a1!.bat"
  call :clear
  REM .bat bootstrap
    call :prefixFile "%compilerFolder%\file.prefix.ps1.txt"
    call :batBootstrapPs1
  REM .ps1
    call :ps1 "!a1!"
goto :voidReturn

:compileBat
setLocal
  REM bat or ps1 but never both
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :setOutFile "!a1!.bat"
  call :clear
  REM .bat
    call :prefixFile "%compilerFolder%\file.prefix.bat.txt"
    call :bat "!a1!"
goto :voidReturn

:compileShPs1
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :setOutFile "!a1!.sh.bat"
  call :clear
  REM .bat bootstrap
    call :prefixFile "%compilerFolder%\file.prefix.any.txt"
    call :batBootstrapPs1
  REM .sh
    call :shBeforePs1 "!a1!"
  REM .ps1
    call :ps1 "!a1!"
goto :voidReturn

:batBootstrapPs1
setLocal
  if not ["%~1"]==[""] goto :errorReturn
  call :addPrefixFileHeadWithEveryLineOfFileLn "%compilerFolder%\comment.prefix.run.bat.txt" "%compilerFolder%\bat.try.txt"
  call :addPrefixFileHeadWithEveryLineOfFileLn "%compilerFolder%\comment.prefix.run.bat.txt" "%compilerFolder%\bat.powershell.txt"
  call :addPrefixFileHeadWithEveryLineOfFileLn "%compilerFolder%\comment.prefix.run.bat.txt" "%compilerFolder%\bat.finally.txt"
goto :voidReturn

:shBeforePs1
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  REM start .ps1 skip over .sh
  call :addFileLn "%compilerFolder%\ps1.skip.try.txt"
    REM .sh
      call :shWithoutPs1 "!a1!"
  REM end of .ps1 skip over .sh
  call :addFileLn "%compilerFolder%\ps1.skip.finally.txt"
goto :voidReturn

:shWithoutPs1
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :addFile "%compilerFolder%\sh.try.1.txt"
  call :addFileHead "%compilerFolder%\version.txt"
  call :addFileLn "%compilerFolder%\sh.try.2.txt"
    call :addFileLn "%sourceFolder%\!a1!.sh.txt"
  call :addFileLn "%compilerFolder%\sh.finally.txt"
goto :voidReturn

:ps1
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :addFileLn "%compilerFolder%\ps1.constants.txt"
  call :addFileLn "%compilerFolder%\ps1.try.txt"
    call :addFileLn "%sourceFolder%\!a1!.ps1.txt"
  call :addFileLn "%compilerFolder%\ps1.finally.txt"
goto :voidReturn

:bat
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :addPrefixFileHeadWithEveryLineOfFileLn "%compilerFolder%\comment.prefix.run.bat.txt" "%compilerFolder%\bat.try.txt"
    call :addPrefixFileHeadWithEveryLineOfFileLn "%compilerFolder%\comment.prefix.run.bat.txt" "%sourceFolder%\!a1!.bat.txt"
  call :addPrefixFileHeadWithEveryLineOfFileLn "%compilerFolder%\comment.prefix.run.bat.txt" "%compilerFolder%\bat.finally.txt"
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
    if not exist "!a1!" (
      REM call :newFileFromString "!a1!" "0.0.0.0"
        if [%sub%]==[] call :setSub
        >type.temp (echo(0.0.0.0!sub!)
        copy type.temp /a "!a1!" /b >nul
        del type.temp
      REM end :newFileFromString
    )
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
  REM call :newFileLnFromString "!a1!" "%~n2.%z%"
    REM todo only add ln if it is missing
    >"!a1!" (echo(%~n2.%z%)
  REM end :newFileLnFromString
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
  REM todo only add ln if it is missing
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :addFile "!a1!"
  call :addLn
goto :voidReturn

:addFileHeadLn
setLocal
  REM todo only add ln if it is missing
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
  REM todo only add ln if it is missing
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not exist "!a1!" goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  call :prefixFile "!a1!" "ln"
goto :voidReturn

:prefixFileHeadLn
setLocal
  REM todo only add ln if it is missing
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
  REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
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
  REM REM todo only add ln if it is missing
  REM set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  REM if not ["%~2"]==[""] goto :errorReturn
  REM setLocal disableDelayedExpansion
    REM >>"%outFile%" (echo(!%a1%!)
  REM endLocal
REM goto :voidReturn

REM :addStringLn
REM setlocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM REM todo only add ln if it is missing
  REM set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  REM if not ["%~2"]==[""] goto :errorReturn
  REM setLocal disableDelayedExpansion
    REM >>"%outFile%" (echo(%~1)
  REM endLocal
REM goto :voidReturn

REM :prefixString
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  REM set "a2=%~2" & if not ["%~2"]==[""] if not ["!a2!"]==["ln"] goto :errorReturn
  REM if not ["%~3"]==[""] goto :errorReturn
  REM call :toBuffer
  REM REM call :addString "!a1!"
    REM if [%sub%]==[] call :setSub
    REM >type.temp (echo(!a1!!sub!)
    REM copy type.temp /a type2.temp /b >nul
    REM >>"%outFile%" (type type2.temp)
    REM del type.temp type2.temp
  REM REM end :addString
  
  REM if ["!a2!"]==["ln"] call :addLn
  REM call :addFile "buffer.temp"
  REM call :clearBuffer
REM goto :voidReturn

REM :prefixStringLn
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM REM todo only add ln if it is missing
  REM set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  REM if not ["%~2"]==[""] goto :errorReturn
  REM call :prefixString "!a1!" "ln"
REM goto :voidReturn

:everyLinePrefixFileLn
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

:everyLinePrefixFileHeadLn
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

REM :everyLinePrefixStringLn
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  REM if not ["%~2"]==[""] goto :errorReturn
  REM call :toBuffer
  REM for /f "usebackq delims=" %%a in ("buffer.temp") do (set "line=%%a"
    REM REM call :addString "!a1!"
      REM if [%sub%]==[] call :setSub
      REM >type.temp (echo(!a1!!sub!)
      REM copy type.temp /a type2.temp /b >nul
      REM >>"%outFile%" (type type2.temp)
      REM del type.temp type2.temp
    REM REM end :addString
    REM REM call :addString "!line!"
      REM if [%sub%]==[] call :setSub
      REM >type.temp (echo(!line!!sub!)
      REM copy type.temp /a type2.temp /b >nul
      REM >>"%outFile%" (type type2.temp)
      REM del type.temp type2.temp
    REM REM end :addString
  REM )
  REM call :clearBuffer
REM goto :voidReturn

:addPrefixFileWithEveryLineOfFileLn
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

:addPrefixFileHeadWithEveryLineOfFileLn
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

REM :addPrefixStringWithEveryLineOfFileLn
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  REM set "a2=%~2" & if ["%~2"]==[""] goto :errorReturn
  REM if not exist "!a2!" goto :errorReturn
  REM if not ["%~3"]==[""] goto :errorReturn
  REM for /f "usebackq delims=" %%a in ("!a2!") do (set "line=%%a"
    REM REM call :addString "!a1!"
      REM if [%sub%]==[] call :setSub
      REM >type.temp (echo(!a1!!sub!)
      REM copy type.temp /a type2.temp /b >nul
      REM >>"%outFile%" (type type2.temp)
      REM del type.temp type2.temp
    REM REM end :addString
    REM REM call :addString "!line!"
      REM if [%sub%]==[] call :setSub
      REM >type.temp (echo(!line!!sub!)
      REM copy type.temp /a type2.temp /b >nul
      REM >>"%outFile%" (type type2.temp)
      REM del type.temp type2.temp
    REM REM end :addString
  REM )
REM goto :voidReturn

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
call :setOutFolder "..\compiled"
(set "compilerFolder=%~dp0\..\compiler")
(set "sourceFolder=%~dp0\..\source")
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
  (set "compiledFolder=%~dp0\%~1")
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

REM :typeString
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  REM if not ["%~2"]==[""] goto :errorReturn
  REM if [%sub%]==[] call :setSub
  REM >type.temp (echo(!a1!!sub!)
  REM copy type.temp /a type2.temp /b >nul
  REM type type2.temp
  REM del type.temp type2.temp
REM goto :voidReturn

REM :typeStringLn
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM REM todo only add ln if it is missing
  REM set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  REM if not ["%~2"]==[""] goto :errorReturn
  REM (echo(!a1!)
REM goto :voidReturn

REM :typeSp
REM setLocal
  REM if not ["%~1"]==[""] goto :errorReturn
  REM call :typeString " "
REM goto :voidReturn

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
  REM todo only add ln if it is missing
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

REM :setReturnString
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  REM if not ["%~2"]==[""] goto :errorReturn
  REM set "return=!a1!"
  REM REM call :newFileFromString "line.temp" "!a1!"
  REM REM <"line.temp" (set /p "return=")
REM goto :exclamationsReturn

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

REM :newFileFromString
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  REM set "a2=%~2" & if ["%~2"]==[""] goto :errorReturn
  REM if not ["%~3"]==[""] goto :errorReturn
  REM if [%sub%]==[] call :setSub
  REM >type.temp (echo(!a2!!sub!)
  REM copy type.temp /a "!a1!" /b >nul
  REM del type.temp
REM goto :voidReturn

REM :newFileLnFromString
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM REM todo only add ln if it is missing
  REM set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  REM set "a2=%~2" & if ["%~2"]==[""] goto :errorReturn
  REM if not ["%~3"]==[""] goto :errorReturn
  REM >"!a1!" (echo(!a2!)
REM goto :voidReturn

:deleleFile
setLocal
  set "a1=%~1" & if ["%~1"]==[""] goto :errorReturn
  if not ["%~2"]==[""] goto :errorReturn
  del "!a1!" >nul 2>&1
  if exist "!a1!" goto :errorReturn
goto :voidReturn

:deleteCompiledFolderContents
setLocal
  if not ["%~1"]==[""] goto :errorReturn
  pushd "%compiledFolder%\..\compiled\." && (rd /s /q "%compiledFolder%\..\compiled\." 2>nul & popd)
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

REM :percentsReturn
REM REM use %return%
REM REM (call set "return=%return%")
REM (set "return=%return%")
REM REM do not merge into single line
REM endlocal & (set "return=%return%") & exit /b 0

:exportReturn
REM use !variable!
if ["%export%"]==[""] goto :errorReturn
(set "return=!%export%!")
endlocal & (set "%export%=%return%")
(set "return=") & exit /b 0

:exit
set "a1=%~1" & if ["%~1"]==[""] exit /b 0
exit /b !a1!
