::start "" "http://127.0.0.1:8080"
@echo off
cd /d %~dp0
if exist set_python_path.txt (
	goto loadPythonPath
) else (
    goto useDefault
)

:loadPythonPath
set /p customepythonpath=<set_python_path.txt
if [%customepythonpath%] == [] (
	goto useDefault
) else (
	goto useCustom
)

:useDefault
echo Using system default python
echo.
echo.
consoleMenu.py %1
goto eof

:useCustom
echo Using python from: %customepythonpath%
echo.
echo.
%customepythonpath%\python.exe consoleMenu.py %1
goto eof

:eof