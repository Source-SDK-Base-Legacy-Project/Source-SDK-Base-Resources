@echo off
setlocal enableextensions enabledelayedexpansion
prompt $

pushd .\SourceContentInstaller
call build_2007_installers.bat
popd

call setup_env_vars.bat

set _name="Source SDK Base Resources (Only 2007)"
set _output="SourceSDKBaseResources_Only2007"

makensis.exe /DNAME=%_name% /DCAPTION=%_name% /DOUTPUTFILE=%_output% /DVERSION=%_version% /DVERSION_FULL=%_version_full% /DARCH=x64 /DSOURCE2007 -V3 SourceSDKBaseResources.nsi
makensis.exe /DNAME=%_name% /DCAPTION=%_name% /DOUTPUTFILE=%_output% /DVERSION=%_version% /DVERSION_FULL=%_version_full% /DARCH=x86 /DSOURCE2007 -V3 SourceSDKBaseResources.nsi

xcopy "%_output%_*_x64.exe" "%_artifacts_dir%\publish\release_win-x64\*" /r /y
xcopy "%_output%_*_x86.exe" "%_artifacts_dir%\publish\release_win-x86\*" /r /y

endlocal