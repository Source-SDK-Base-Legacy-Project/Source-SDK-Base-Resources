@echo off
setlocal enableextensions enabledelayedexpansion
prompt $

pushd .\SourceContentInstaller
call build_full_installers.bat
popd

call setup_env_vars.bat

set _name="Source SDK Base Resources (Full)"
set _output="SourceSDKBaseResources_Full"

makensis.exe /DNAME=%_name% /DCAPTION=%_name% /DOUTPUTFILE=%_output% /DVERSION=%_version% /DVERSION_FULL=%_version_full% /DARCH=x64 /DSOURCE2006 /DSOURCE2007 -V3 SourceSDKBaseResources.nsi

xcopy "%_output%_*_x64.exe" "%_artifacts_dir%\publish\release_win-x64\*" /r /y

endlocal