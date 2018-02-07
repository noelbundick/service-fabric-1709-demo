@echo off

REM TIP: It can be useful to dump all arguments/environment variables during debugging
REM TIP: Make sure you enable ConsoleRedirection in ServiceManifest.xml

REM TIP: List all arguments
REM echo %*

REM TIP: List all environment variables
REM set

REM We'll use PowerShell to create the SMB Global Mappings
powershell.exe -ExecutionPolicy Bypass -Command ".\AddSMBGlobalMapping.ps1"
