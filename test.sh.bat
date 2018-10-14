@{}# 2>/dev/null # 2>nul&setLocal&echo off&@{}# 2>/dev/null # 2>nul&setLocal&echo off&
(if not !err! == 0 (if %0 == "%~0" (echo(&echo|set /p="Press any key to close..."&pause >nul)))&exit /b !err!