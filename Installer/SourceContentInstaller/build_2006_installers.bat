@echo off
setlocal enableextensions enabledelayedexpansion
prompt $

set _name="SourceContentInstaller (Only 2006)"
set _output="SourceContentInstaller_Only2006"

makensis.exe /DNAME=%_name% /DCAPTION=%_name% /DOUTPUTFILE=%_output% /DSOURCE2006 -V3 SourceContentInstaller.nsi

set _name="SourceContentUninstaller (Only 2006)"
set _output="SourceContentUninstaller_Only2006"

makensis.exe /DNAME=%_name% /DCAPTION=%_name% /DOUTPUTFILE=%_output% /DSOURCE2006 /DUNINSTALLER -V3 SourceContentInstaller.nsi

endlocal