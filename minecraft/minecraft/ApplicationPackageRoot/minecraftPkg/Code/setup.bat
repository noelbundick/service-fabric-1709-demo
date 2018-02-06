@echo off

rem TODO: clean up

rem dump all parameters
echo %*

rem dump all environment vars
set

rem use PS for the real work
powershell.exe -ExecutionPolicy Bypass -Command ".\AddSMBGlobalMapping.ps1"
