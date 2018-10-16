@setLocal&echo off
# 2>nul&title %~n0
# 2>nul&.\compiler\old.compile.bat
# 2>nul&(if not !err! == 0 (if %0 == "%~0" (echo(&echo|set /p="Press any key to close..."&pause >nul)))&exit /b !err!
