@echo off
setlocal enableextensions enabledelayedexpansion
prompt $

set _name="SourceContentInstaller (Only 2007)"
set _output="SourceContentInstaller_Only2007"

makensis.exe /DNAME=%_name% /DCAPTION=%_name% /DOUTPUTFILE=%_output% /DSOURCE2007 -V3 SourceContentInstaller.nsi

set _name="SourceContentUninstaller (Only 2007)"
set _output="SourceContentUninstaller_Only2007"

makensis.exe /DNAME=%_name% /DCAPTION=%_name% /DOUTPUTFILE=%_output% /DSOURCE2007 /DUNINSTALLER -V3 SourceContentInstaller.nsi

endlocal