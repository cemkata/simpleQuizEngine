::start "" "http://127.0.0.1:8080"
@echo off
call set_python_path.bat
cd /d %~dp0
%pythonpath%\python.exe consoleMenu.py -s