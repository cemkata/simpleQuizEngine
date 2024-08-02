::start "" "http://127.0.0.1:8080"
@echo off
cd /d %~dp0
%pythonpath%\python.exe consoleMenu.py
pause