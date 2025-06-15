@echo off
setlocal enableextensions enabledelayedexpansion
prompt $

call build_2006_installers.bat
call build_2007_installers.bat
call build_full_installers.bat

endlocal