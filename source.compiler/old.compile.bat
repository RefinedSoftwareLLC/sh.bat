@ echo off & goto :init
:start

REM ###################
REM ###  .bat mode  ###
REM ### Use "echo(" ###
REM ###################

echo(
echo(compile :start
echo(

call :newVersionFile "%compilerFolder%\..\version.txt"

call :deleteCompiledFolderContents "%compiledFolder%"

call :compileAllNonprivileged "example"
call :compileAllNonprivileged "unmute"
call :compileAllNonprivileged "mute"

call :newVersionFile "%cliFolder%\..\install.openwebpageyesno.hidden.version.txt"
call :compileAdminHidden "install.openwebpageyesno.hidden"


call :compileMd "README"
call :deleleFile "..\README.md"
move /Y "README.md" "..\README.md" >nul

call :compileBat "compile"
call :deleleFile "..\compile.bat"
move /Y "compile.bat" "..\compile.bat" >nul

REM start notepad "example.sh.bat"
goto :exit

:compileAllNonprivileged
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :newVersionFile "%cliFolder%\..\!a1!.version.txt"
  call :compileSh "!a1!"
  call :compilePs1 "!a1!"
  call :compileShPs1 "!a1!"
goto :voidReturn

:compilePrivileged
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :newVersionFile "%cliFolder%\..\!a1!.version.txt"
  REM call :compileSh "!a1!"
  REM call :compilePs1 "!a1!"
  REM call :compileShPs1 "!a1!"
  REM call :compileRoot "!a1!"
  REM call :compileAdmin "!a1!"
  REM call :compileShAdmin "!a1!"
  REM call :compileRootPs1 "!a1!"
  call :compileRootAdmin "!a1!"
goto :voidReturn

:compileMd
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :setOutFile "!a1!.md"
  call :clear
  REM .md
    REM call :addFileLnExpandingFileLinks "%cliFolder%\!a1!.md.txt"
    call :addFileLn "%textFolder%\!a1!.1.md.txt"
    call :mdLink "%compilerFolder%\cli.download.sh"
    call :addFileLn "%textFolder%\!a1!.2.md.txt"
    call :mdLink "%compilerFolder%\cli.download.bat"
    call :addFileLn "%textFolder%\!a1!.3.md.txt"
    call :mdFile "%compiledFolder%\example.sh.bat"
    call :addFile "%textFolder%\!a1!.4.md.txt"
goto :voidReturn

:compileSh
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :setOutFile "!a1!"
  call :clear
  REM .sh
    call :prefixFile "%compilerFolder%\file.prefix.sh.txt"
    call :shWithoutPs1 "!a1!"
goto :voidReturn

:compilePs1
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
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
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :setOutFile "!a1!.bat"
  call :clear
  REM .bat
    call :prefixFile "%compilerFolder%\file.prefix.bat.txt"
    call :bat "!a1!"
goto :voidReturn

:compileRoot
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :setOutFile "!a1!.sh"
  call :clear
  REM .sh
    call :prefixFile "%compilerFolder%\file.prefix.sh.txt"
    call :root "!a1!"
goto :voidReturn

:compileAdmin
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :setOutFile "!a1!.bat"
  call :clear
  REM .bat bootstrap
    call :prefixFile "%compilerFolder%\file.prefix.ps1.txt"
    call :batBootstrapPs1
  REM .ps1
    call :ps1Admin "!a1!"
goto :voidReturn

:compileAdminHidden
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :setOutFile "!a1!.bat"
  call :clear
  REM .bat bootstrap
    call :prefixFile "%compilerFolder%\file.prefix.ps1.txt"
    call :batHiddenPs1
  REM .ps1
    call :ps1Admin "!a1!"
goto :voidReturn

:compileShPs1
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
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

:compileRootAdminHidden
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :setOutFile "!a1!.sh.bat"
  call :clear
  REM .bat bootstrap
    call :prefixFile "%compilerFolder%\file.prefix.any.txt"
    call :batHiddenPs1
  REM .sh
    call :shBeforePs1 "!a1!"
  REM .ps1
    call :ps1Admin "!a1!"
goto :voidReturn

:batBootstrapPs1
setLocal
  (if not ["%~1"]==[""] goto :errorReturn)
  call :addPrefixFileHeadWithEveryLineOfFileLn "%compilerFolder%\comment.prefix.run.bat.txt" "%compilerFolder%\bat.bootstrap.ps1.try.txt"
  call :addFileLn "%compilerFolder%\ps1.skip.try.txt"
  call :addFileLn "%compilerFolder%\bat.bootstrap.ps1.powershell.txt"
  call :addFileLn "%compilerFolder%\ps1.skip.finally.txt"
  call :addPrefixFileHeadWithEveryLineOfFileLn "%compilerFolder%\comment.prefix.run.bat.txt" "%compilerFolder%\bat.bootstrap.ps1.finally.txt"
goto :voidReturn

:batHiddenPs1
setLocal
  (if not ["%~1"]==[""] goto :errorReturn)
  call :addPrefixFileHeadWithEveryLineOfFileLn "%compilerFolder%\comment.prefix.run.bat.txt" "%compilerFolder%\bat.hidden.ps1.try.txt"
  call :addFileLn "%compilerFolder%\ps1.skip.try.txt"
  call :addFileLn "%compilerFolder%\bat.hidden.ps1.powershell.txt"
  call :addFileLn "%compilerFolder%\ps1.skip.finally.txt"
  call :addPrefixFileHeadWithEveryLineOfFileLn "%compilerFolder%\comment.prefix.run.bat.txt" "%compilerFolder%\bat.hidden.ps1.finally.txt"
goto :voidReturn

:shBeforePs1
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  REM start .ps1 skip over .sh
  call :addFileLn "%compilerFolder%\ps1.skip.try.txt"
    REM .sh
      call :shWithoutPs1 "!a1!"
  REM end of .ps1 skip over .sh
  call :addFileLn "%compilerFolder%\ps1.skip.finally.txt"
goto :voidReturn

:shWithoutPs1
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :addFile "%compilerFolder%\sh.try.1.txt"
  call :addFileHead "%compilerFolder%\version.txt"
  call :addFileLn "%compilerFolder%\sh.try.2.txt"
    call :addFileLn "%cliFolder%\!a1!.sh.txt"
  call :addFileLn "%compilerFolder%\sh.finally.txt"
goto :voidReturn

:ps1
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :addFileLn "%compilerFolder%\ps1.constants.txt"
  call :addFileLn "%compilerFolder%\ps1.try.txt"
    call :addFileLn "%cliFolder%\!a1!.ps1.txt"
  call :addFileLn "%compilerFolder%\ps1.finally.txt"
goto :voidReturn

:ps1Admin
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :addFileLn "%compilerFolder%\ps1.constants.txt"
  call :addFileLn "%compilerFolder%\ps1.admin.txt"
  call :addFileLn "%compilerFolder%\ps1.try.txt"
    call :addFileLn "%cliFolder%\!a1!.ps1.txt"
  call :addFileLn "%compilerFolder%\ps1.finally.txt"
goto :voidReturn

:bat
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :addPrefixFileHeadWithEveryLineOfFileLn "%compilerFolder%\comment.prefix.run.bat.txt" "%compilerFolder%\bat.try.txt"
    call :addPrefixFileHeadWithEveryLineOfFileLn "%compilerFolder%\comment.prefix.run.bat.txt" "%cliFolder%\!a1!.bat.txt"
  call :addPrefixFileHeadWithEveryLineOfFileLn "%compilerFolder%\comment.prefix.run.bat.txt" "%compilerFolder%\bat.finally.txt"
goto :voidReturn

:mdLink
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :addFile "%compilerFolder%\md.try.txt"
  call :addFile "%compilerFolder%\comment.prefix.md.txt"
    call :addFile  "!a1!.try.txt"
    call :addFile  "%compilerFolder%\cli.download.link.txt"
    call :addFileLn  "!a1!.finally.txt"
  call :addFileLn "%compilerFolder%\md.finally.txt"
goto :voidReturn

:mdFile
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :addFile "%compilerFolder%\md.try.txt"
  call :addPrefixFileHeadWithEveryLineOfFileLn "%compilerFolder%\comment.prefix.md.txt" "!a1!"
  call :addFileLn "%compilerFolder%\md.finally.txt"
goto :voidReturn

REM ###############
REM ### library ###
REM ###############

:newVersionFile
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  REM (if not exist "!a1!" goto :errorReturn)
  (if not ["%~3"]==[""] goto :errorReturn)
  set "a2=%~2" & (if ["%~2"]==[""] (
    (set "return=")
    (if not exist "!a1!" (
      REM call :newFileFromString "!a1!" "0.0.0.0"
        >type.temp (echo(0.0.0.0%sub%)
        copy type.temp /a "!a1!" /b >nul
        del type.temp
      REM end :newFileFromString
    ))
    call :exclamationsReturnFileFirstLine "!a1!"
    REM !return!=0.0.0.5
    (if ["!return!"]==[""] goto :errorReturn)
    (if not ["!return!"]==[""] call :newVersionFile "!a1!" "!return!")
    goto :voidReturn
  ))
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
  >"%~dp1\compiled\%~nx1" (type "!a1!")
goto :voidReturn

:clear
setLocal
  (if not ["%~1"]==[""] goto :errorReturn)
  >"%outFile%" (type nul)
  REM copy /b nul "%outFile%"
goto :voidReturn

:toBuffer
setLocal
  (if not ["%~1"]==[""] goto :errorReturn)
  call :deleleFile "buffer.temp"
  call :renameFileToFile "%outFile%" ".\buffer.temp"
  call :clear
goto :voidReturn

:clearBuffer
setLocal
  (if not ["%~1"]==[""] goto :errorReturn)
  call :deleleFile "buffer.temp"
goto :voidReturn

REM :addSp
REM setLocal
  REM (if not ["%~1"]==[""] goto :errorReturn)
  REM call :addString " "
REM goto :voidReturn

:addLn
setLocal
  (if not ["%~1"]==[""] goto :errorReturn)
  setLocal disableDelayedExpansion
    >>"%outFile%" (echo()
  endLocal
goto :voidReturn

:addFile
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  copy /b "%outFile%" + "!a1!" "%outFile%" >nul
goto :voidReturn

:addFileHead
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :exclamationsReturnFileFirstLine "!a1!"
  REM call :addString "!return!"
    >type.temp (echo(!return!%sub%)
    copy type.temp /a type2.temp /b >nul
    >>"%outFile%" (type type2.temp)
    del type.temp type2.temp
  REM end :addString
goto :voidReturn

:addFileLn
setLocal
  REM todo only add ln if it is missing
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :addFile "!a1!"
  call :addLn
goto :voidReturn

:addFileHeadLn
setLocal
  REM todo only add ln if it is missing
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :addFileHead "!a1!"
  call :addLn
goto :voidReturn

:prefixFile
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  set "a2=%~2" & (if not ["%~2"]==[""] (if not ["!a2!"]==["ln"] goto :errorReturn))
  (if not ["%~3"]==[""] goto :errorReturn)
  call :toBuffer
  call :addFile "!a1!"
  (if ["!a2!"]==["ln"] call :addLn)
  call :addFile "buffer.temp"
  call :clearBuffer
goto :voidReturn

:prefixFileHead
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  set "a2=%~2" & (if not ["%~2"]==[""] (if not ["!a2!"]==["ln"] goto :errorReturn))
  (if not ["%~3"]==[""] goto :errorReturn)
  call :toBuffer
  call :addFileHead "!a1!"
  (if ["!a2!"]==["ln"] call :addLn)
  call :addFile "buffer.temp"
  call :clearBuffer
goto :voidReturn

:prefixFileLn
setLocal
  REM todo only add ln if it is missing
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :prefixFile "!a1!" "ln"
goto :voidReturn

:prefixFileHeadLn
setLocal
  REM todo only add ln if it is missing
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :prefixFileHead "!a1!" "ln"
goto :voidReturn

REM :addVariable
REM setLocal
  REM set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  REM (if not ["%~2"]==[""] goto :errorReturn)
  REM >type.temp (echo(!%a1%!%sub%)
  REM copy type.temp /a type2.temp /b >nul
  REM >>"%outFile%" (type type2.temp)
  REM del type.temp type2.temp
REM goto :voidReturn

REM :addString
REM setLocal
  REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  REM (if not ["%~2"]==[""] goto :errorReturn)
  REM >type.temp (echo(!a1!%sub%)
  REM copy type.temp /a type2.temp /b >nul
  REM >>"%outFile%" (type type2.temp)
  REM del type.temp type2.temp
REM goto :voidReturn

REM :addVariableLn
REM setLocal
  REM REM todo only add ln if it is missing
  REM set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  REM (if not ["%~2"]==[""] goto :errorReturn)
  REM setLocal disableDelayedExpansion
    REM >>"%outFile%" (echo(!%a1%!)
  REM endLocal
REM goto :voidReturn

REM :addStringLn
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM REM todo only add ln if it is missing
  REM set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  REM (if not ["%~2"]==[""] goto :errorReturn)
  REM setLocal disableDelayedExpansion
    REM >>"%outFile%" (echo(%~1)
  REM endLocal
REM goto :voidReturn

REM :prefixString
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  REM set "a2=%~2" & (if not ["%~2"]==[""] (if not ["!a2!"]==["ln"] goto :errorReturn))
  REM (if not ["%~3"]==[""] goto :errorReturn)
  REM call :toBuffer
  REM REM call :addString "!a1!"
    REM >type.temp (echo(!a1!%sub%)
    REM copy type.temp /a type2.temp /b >nul
    REM >>"%outFile%" (type type2.temp)
    REM del type.temp type2.temp
  REM REM end :addString

  REM (if ["!a2!"]==["ln"] call :addLn)
  REM call :addFile "buffer.temp"
  REM call :clearBuffer
REM goto :voidReturn

REM :prefixStringLn
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM REM todo only add ln if it is missing
  REM set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  REM (if not ["%~2"]==[""] goto :errorReturn)
  REM call :prefixString "!a1!" "ln"
REM goto :voidReturn

:everyLinePrefixFileLn
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :toBuffer
  set "forFile=buffer.temp"
    (call :newFile "lastForLine.temp") & setLocal disableDelayedExpansion & for /f "tokens=* delims=" %%A in ('findstr /b /n "^" "%forFile%"') do (set "line=%%A" & setLocal enableDelayedExpansion & set "line=!line:*:=!" & >type.temp (echo(!line!%sub%) & copy type.temp /a "lastForLine.temp" /b >nul & del type.temp
      call :addFile "!a1!"
      REM call :addString "!line!"
        >type.temp (echo(!line!%sub%)
        copy type.temp /a type2.temp /b >nul
        >>"%outFile%" (type type2.temp)
        del type.temp type2.temp
      REM end :addString
    endLocal)
  endLocal
  call :clearBuffer
goto :voidReturn

:everyLinePrefixFileHeadLn
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  call :toBuffer
  set "forFile=buffer.temp"
    (call :newFile "lastForLine.temp") & setLocal disableDelayedExpansion & for /f "tokens=* delims=" %%A in ('findstr /b /n "^" "%forFile%"') do (set "line=%%A" & setLocal enableDelayedExpansion & set "line=!line:*:=!" & >type.temp (echo(!line!%sub%) & copy type.temp /a "lastForLine.temp" /b >nul & del type.temp
      call :addFileHead "!a1!"
      REM call :addString "!line!"
        >type.temp (echo(!line!%sub%)
        copy type.temp /a type2.temp /b >nul
        >>"%outFile%" (type type2.temp)
        del type.temp type2.temp
      REM end :addString
    endLocal)
  endLocal
  call :clearBuffer
goto :voidReturn

REM :everyLinePrefixStringLn
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  REM (if not ["%~2"]==[""] goto :errorReturn)
  REM call :toBuffer
  REM set "forFile=buffer.temp"
    REM (call :newFile "lastForLine.temp") & setLocal disableDelayedExpansion & for /f "tokens=* delims=" %%A in ('findstr /b /n "^" "%forFile%"') do (set "line=%%A" & setLocal enableDelayedExpansion & set "line=!line:*:=!" & >type.temp (echo(!line!%sub%) & copy type.temp /a "lastForLine.temp" /b >nul & del type.temp
      REM REM call :addString "!a1!"
        REM >type.temp (echo(!a1!%sub%)
        REM copy type.temp /a type2.temp /b >nul
        REM >>"%outFile%" (type type2.temp)
        REM del type.temp type2.temp
      REM REM end :addString
      REM REM call :addString "!line!"
        REM >type.temp (echo(!line!%sub%)
        REM copy type.temp /a type2.temp /b >nul
        REM >>"%outFile%" (type type2.temp)
        REM del type.temp type2.temp
      REM REM end :addString
    REM endLocal)
  REM endLocal
  REM call :clearBuffer
REM goto :voidReturn

:addPrefixFileWithEveryLineOfFileLn
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  set "a2=%~2" & (if ["%~2"]==[""] goto :errorReturn)
  set "a2=%~f2" & (if not exist "!a2!" goto :errorReturn)
  (if not ["%~3"]==[""] goto :errorReturn)
  set "forFile=!a2!"
    (call :newFile "lastForLine.temp") & setLocal disableDelayedExpansion & for /f "tokens=* delims=" %%A in ('findstr /b /n "^" "%forFile%"') do (set "line=%%A" & setLocal enableDelayedExpansion & set "line=!line:*:=!" & >type.temp (echo(!line!%sub%) & copy type.temp /a "lastForLine.temp" /b >nul & del type.temp
      call :addFile "!a1!"
      REM call :addStringLn "^!line^!"
        >>"%outFile%" (echo(^!line^!)
      REM call :addStringLn
    endLocal)
  endLocal
goto :voidReturn

:addPrefixFileHeadWithEveryLineOfFileLn
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  set "a2=%~2" & (if ["%~2"]==[""] goto :errorReturn)
  set "a2=%~f2" & (if not exist "!a2!" goto :errorReturn)
  (if not ["%~3"]==[""] goto :errorReturn)
  set "forFile=!a2!"
    (call :newFile "lastForLine.temp") & setLocal disableDelayedExpansion & for /f "tokens=* delims=" %%A in ('findstr /b /n "^" "%forFile%"') do (set "line=%%A" & setLocal enableDelayedExpansion & set "line=!line:*:=!" & >type.temp (echo(!line!%sub%) & copy type.temp /a "lastForLine.temp" /b >nul & del type.temp
      call :addFileHead "^!a1^!"
      REM call :addStringLn "^!line^!"
        >>"%outFile%" (echo(^!line^!)
      REM call :addStringLn
    endLocal)
  endLocal
goto :voidReturn

REM :addPrefixStringWithEveryLineOfFileLn
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  REM set "a2=%~2" & (if ["%~2"]==[""] goto :errorReturn)
  REM set "a2=%~f2" & (if not exist "!a2!" goto :errorReturn)
  REM (if not ["%~3"]==[""] goto :errorReturn)
  set "forFile=!a2!"
    (call :newFile "lastForLine.temp") & setLocal disableDelayedExpansion & for /f "tokens=* delims=" %%A in ('findstr /b /n "^" "%forFile%"') do (set "line=%%A" & setLocal enableDelayedExpansion & set "line=!line:*:=!" & >type.temp (echo(!line!%sub%) & copy type.temp /a "lastForLine.temp" /b >nul & del type.temp
      REM call :addString "!a1!"
        >type.temp (echo(!a1!%sub%)
        copy type.temp /a type2.temp /b >nul
        >>"%outFile%" (type type2.temp)
        del type.temp type2.temp
      REM end :addString
      REM call :addStringLn "^!line^!"
        >>"%outFile%" (echo(^!line^!)
      REM call :addStringLn
    endLocal)
  endLocal
REM goto :voidReturn

REM :addFileLnExpandingFileLinks
REM setLocal
  REM set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  REM (if not exist "!a1!" goto :errorReturn)
  REM (if not ["%~2"]==[""] goto :errorReturn)
  REM set "forFile=!a1!"
    REM (call :newFile "lastForLine.temp") & setLocal disableDelayedExpansion & for /f "tokens=* delims=" %%A in ('findstr /b /n "^" "%forFile%"') do (set "line=%%A" & setLocal enableDelayedExpansion & set "line=!line:*:=!" & >type.temp (echo(!line!%sub%) & copy type.temp /a "lastForLine.temp" /b >nul & del type.temp
      REM echo(Not programmed :addFileLnExpandingFileLinks
      REM echo(%%A
      REM REM call :addStringLn "^!line^!"
        REM >>"%outFile%" (echo(^!line^!)
      REM REM call :addStringLn
    REM endLocal)
  REM endLocal
REM goto :voidReturn

REM ##############
REM ### engine ###
REM ##############

goto :exit

:example
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
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
(set "sub=errorSub")
setLocal
(set /a "setLocal=setLocal+1")
REM Above 2 setLocals are required - do not remove
call :setLf
call :setSub

if not ["%~1"]==[""] (echo(Error: %0 %*)

pushd %~dp0
call :setOutFolderAndCurrentFolder "%~dp0\..\compiled"

(set "compilerFolder=%~dp0\..\source.compiler\compiled")
call :deleteCompiledFolderContents "%compilerFolder%"
call :compileFolderToAscii "%compilerFolder%\.."

(set "functionFolder=%~dp0\..\source.function\compiled")
call :deleteCompiledFolderContents "%functionFolder%"
call :compileFolderToAscii "%functionFolder%\.."

(set "cliFolder=%~dp0\..\source.cli\compiled")
call :deleteCompiledFolderContents "%cliFolder%"
call :compileFolderToAscii "%cliFolder%\.."

(set "textFolder=%~dp0\..\source.text\compiled")
call :deleteCompiledFolderContents "%textFolder%"
call :compileFolderToAscii "%textFolder%\.."

REM start starting
call :start
REM start exited
del "%compiledFolder%\lastForLine.temp" >nul 2>&1
echo(
echo(compile :exit
echo(
if not ["%setLocal%"]==["2"] (
  echo(setLocal depth %setLocal% but should be 2
  exit /b 1
)
exit /b 0

:setOutFolderAndCurrentFolder
REM no setLocal, a1, a2, :return
  (if ["%~1"]==[""] (
    (echo(Error: %0 %*)
    exit /b 1
  ))
  (if not exist "%~1" (
    (echo(Error: %0 %*)
    exit /b 1
  ))
  (if not ["%~2"]==[""] (
    (echo(Error: %0 %*)
    exit /b 1
  ))
  popd
  pushd "%~1"
  (set "compiledFolder=%~1")
exit /b 0

:setOutFile
REM no setLocal, a1, a2, :return
  (if ["%~1"]==[""] (
    (echo(Error: %0 %*)
    exit /b 1
  ))
  (if not ["%~2"]==[""] (
    (echo(Error: %0 %*)
    exit /b 1
  ))
  (set "outFile=%~1")
exit /b 0

:compileFolderToAscii
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "%~1" goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  mkdir "%~1\compiled" 2>nul
  for /r "%~1" %%A in (*) do (
    >"%~1\compiled\%%~nxA" (type "%~1\%%~nxA")
  )
goto :voidReturn

REM :typeString
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  REM (if not ["%~2"]==[""] goto :errorReturn)
  REM >type.temp (echo(!a1!%sub%)
  REM copy type.temp /a type2.temp /b >nul
  REM type type2.temp
  REM del type.temp type2.temp
REM goto :voidReturn

REM :typeStringLn
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM REM todo only add ln if it is missing
  REM set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  REM (if not ["%~2"]==[""] goto :errorReturn)
  REM (echo(!a1!)
REM goto :voidReturn

REM :typeSp
REM setLocal
  REM (if not ["%~1"]==[""] goto :errorReturn)
  REM call :typeString " "
REM goto :voidReturn

:typeLn
setLocal
  (if not ["%~1"]==[""] goto :errorReturn)
  (echo()
goto :voidReturn

:typeFile
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  type "!a1!"
goto :voidReturn

:typeFileLn
setLocal
  REM todo only add ln if it is missing
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  type "!a1!"
  call :typeLn
goto :voidReturn

:escapeString
REM no setLocal, a1, a2, :return
  (if ["%~1"]==[""] (
    (echo(Error: %0 %*)
    exit /b 1
  ))
  REM set "%~1=!%~1:%lf%=^n!"
  set "%~1=!%~1:%%=%%%%!"
  set "%~1=!%~1:&=^&!"
  REM set "%~1=!%~1:^^!=!"
  REM set "%~1=!%~1:t=!"
  REM echo(# !%~1!
exit /b 0

:exclamationsReturnFile
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  <"!a1!" (set /p "return=")
  REM required: !return!
goto :exclamationsReturn

REM :exclamationsReturnFileLineCount
REM setLocal
  REM set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  REM (if not exist "!a1!" goto :errorReturn)
  REM (if not ["%~2"]==[""] goto :errorReturn)
  REM set "i=0"
  REM set "forFile=!a1!"
    REM (call :newFile "lastForLine.temp") & setLocal disableDelayedExpansion & for /f "tokens=* delims=" %%A in ('findstr /b /n "^" "%forFile%"') do (set "line=%%A" & setLocal enableDelayedExpansion & set "line=!line:*:=!" & >type.temp (echo(!line!%sub%) & copy type.temp /a "lastForLine.temp" /b >nul & del type.temp
      REM REM (set /a "i=i+1")
    REM endLocal & (set /a "i=i+1"))
  REM endLocal & (set "i=!i!")
  REM set "return=!i!"
REM goto :exclamationsReturn

:exclamationsReturnFileLastLine
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  set "i=0"
  set "forFile=!a1!"
    (call :newFile "lastForLine.temp") & setLocal disableDelayedExpansion & for /f "tokens=* delims=" %%A in ('findstr /b /n "^" "%forFile%"') do (set "line=%%A" & setLocal enableDelayedExpansion & set "line=!line:*:=!" & >type.temp (echo(!line!%sub%) & copy type.temp /a "lastForLine.temp" /b >nul & del type.temp
      REM (set /a "i=i+1")
      REM set "return=!line!"
    endLocal & (set /a "i=i+1"))
  endLocal & (set "i=!i!")
  (if ["!i!"]==["0"] goto :errorReturn)
  call :setReturnLastForLine
goto :exclamationsReturn

:exclamationsReturnFileFirstLine
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  set "forFile=!a1!"
    (call :newFile "lastForLine.temp") & setLocal disableDelayedExpansion & for /f "tokens=* delims=" %%A in ('findstr /b /n "^" "%forFile%"') do (set "line=%%A" & setLocal enableDelayedExpansion & set "line=!line:*:=!" & >type.temp (echo(!line!%sub%) & copy type.temp /a "lastForLine.temp" /b >nul & del type.temp
      REM set "return=!line!"
    endLocal & goto :exclamationsReturnFileFirstLineBreak)
  endLocal
  goto :errorReturn
  :exclamationsReturnFileFirstLineBreak
  endLocal
  call :setReturnLastForLine
goto :exclamationsReturn

:exclamationsReturnFileNthLine
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  set "i=0"
  set "forFile=!a1!"
    (call :newFile "lastForLine.temp") & setLocal disableDelayedExpansion & for /f "tokens=* delims=" %%A in ('findstr /b /n "^" "%forFile%"') do (set "line=%%A" & setLocal enableDelayedExpansion & set "line=!line:*:=!" & >type.temp (echo(!line!%sub%) & copy type.temp /a "lastForLine.temp" /b >nul & del type.temp
      REM (set /a "i=i+1")
      REM (set "return=!line!")
    endLocal & (set /a "i=i+1") & (if ["!a1!"]==["%i%"] goto :exclamationsReturnFileNthLineBreak))
  endLocal
  goto :errorReturn
  :exclamationsReturnFileNthLineBreak
  endLocal
  call :setReturnLastForLine
goto :exclamationsReturn

REM :setReturnString
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  REM (if not ["%~2"]==[""] goto :errorReturn)
  REM set "return=!a1!"
  REM REM call :newFileFromString "line.temp" "!a1!"
  REM REM <"line.temp" (set /p "return=")
REM goto :exclamationsReturn

:setReturnFile
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  <"!a1!" (set /p "return=")
goto :exclamationsReturn

:setReturnLastForLine
setLocal
  (if not ["%~1"]==[""] goto :errorReturn)
  set "a1=lastForLine.temp" & (if not exist "!a1!" goto :errorReturn)
  <"!a1!" (set /p "return=")
  REM set "return=!return:*:=!"
goto :exclamationsReturn

:renameFileToFile
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not exist "!a1!" goto :errorReturn)
  set "a2=%~2" & (if ["%~2"]==[""] goto :errorReturn)
  (if not ["%~3"]==[""] goto :errorReturn)
  call :deleleFile "%~nx2"
  rename "!a1!" "%~nx2"
goto :voidReturn

:newFile
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  >"!a1!" (type nul)
goto :exclamationsReturn

REM :newFileFromString
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  REM set "a2=%~2" & (if ["%~2"]==[""] goto :errorReturn)
  REM (if not ["%~3"]==[""] goto :errorReturn)
  REM >type.temp (echo(!a2!%sub%)
  REM copy type.temp /a "!a1!" /b >nul
  REM del type.temp
REM goto :voidReturn

REM :newFileLnFromString
REM setLocal
  REM REM Strings can't be passed as arguments without escape glitches, you can only save and load them from files.
  REM REM todo only add ln if it is missing
  REM set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  REM set "a2=%~2" & (if ["%~2"]==[""] goto :errorReturn)
  REM (if not ["%~3"]==[""] goto :errorReturn)
  REM >"!a1!" (echo(!a2!)
REM goto :voidReturn

:deleleFile
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  del "!a1!" >nul 2>&1
  (if exist "!a1!" goto :errorReturn)
goto :voidReturn

:deleteCompiledFolderContents
setLocal
  set "a1=%~1" & (if ["%~1"]==[""] goto :errorReturn)
  (if not ["%~2"]==[""] goto :errorReturn)
  mkdir "%~1\..\compiled\" 2>nul
  pushd "%~1\..\compiled\." && (rd /s /q "%~1\..\compiled\." 2>nul & popd)
goto :voidReturn

:setSub
setLocal
  REM SUB, EOF, Ctrl-Z, 0x1A, decimal 26
  (if not ["%~1"]==[""] goto :errorReturn)
  copy nul sub.temp /a >nul
  for /F %%A in (sub.temp) DO (set "line=%%A"
     set "sub=!line!"
  )
  del sub.temp
  (set "export=sub")
goto :exportReturn

:setLf
REM no setLocal, a1, a2, :return
  (if not ["%~1"]==[""] (
    (echo(Error: %0 %*)
    exit /b 1
  ))
  set lf=^


  REM Above 2 blank lines are required - do not remove or indent
  REM (set "export=lf")
exit /b 0

REM :set\n
REM setLocal
  REM (if not ["%~1"]==[""] goto :errorReturn)
  REM (if [%lf%]==[] call :setLf)
  REM set ^"\n=^^^%LF%%LF%^%LF%%LF%^^"
  REM (set "export=\n")
REM goto :exportReturn

:errorReturn
set "a1=%~1"
(echo(Error: %0 %*)
endLocal & (set "return=")
if ["%~1"]==[""] exit /b 1
exit /b !a1!

:voidReturn
REM return void
endLocal & (set "return=") & exit /b 0

:exclamationsReturn
REM use !return!
endLocal & (set "return=%return%") & exit /b 0

REM :percentsReturn
REM REM use %return%
REM REM (call set "return=%return%")
REM (set "return=%return%")
REM REM do not merge into single line
REM endLocal & (set "return=%return%") & exit /b 0

:exportReturn
REM use !variable!
if ["%export%"]==[""] goto :errorReturn
(set "return=!%export%!")
endLocal & (set "%export%=%return%")
(set "return=") & exit /b 0

:exit
set "a1=%~1" & (if ["%~1"]==[""] exit /b 0)
exit /b !a1!
