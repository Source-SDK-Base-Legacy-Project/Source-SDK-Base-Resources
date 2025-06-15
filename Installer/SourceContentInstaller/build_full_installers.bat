@echo off
setlocal enableextensions enabledelayedexpansion
prompt $

set _name="SourceContentInstaller (Full)"
set _output="SourceContentInstaller_Full"

makensis.exe /DNAME=%_name% /DCAPTION=%_name% /DOUTPUTFILE=%_output% /DSOURCE2006 /DSOURCE2007 -V3 SourceContentInstaller.nsi

set _name="SourceContentUninstaller (Full)"
set _output="SourceContentUninstaller_Full"

makensis.exe /DNAME=%_name% /DCAPTION=%_name% /DOUTPUTFILE=%_output% /DSOURCE2006 /DSOURCE2007 /DUNINSTALLER -V3 SourceContentInstaller.nsi

endlocal