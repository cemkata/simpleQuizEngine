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
cd /d %~dp0
start "" mainGUI.pyw
exit

:useCustom
cd /d %~dp0
start "" "%customepythonpath%\pythonw.exe" mainGUI.pyw
exit

:eof