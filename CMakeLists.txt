cmake_minimum_required(VERSION 4.0.2)

project(SourceSDKBaseResources VERSION "1.0.0" LANGUAGES NONE)

include(FetchContent)

set(PROJECT_VERSION_FULL "${PROJECT_VERSION}-alpha.1")

set(INSTALLER_FILES_VERSION "2025-06-15.1" CACHE STRING "Installer Files release version")
set(DEV_SHARED_FOLDER "" CACHE PATH "Dev shared folder")
set(DEV_ARCH "x64" CACHE STRING "Dev platform architecture")
set_property(CACHE DEV_ARCH PROPERTY STRINGS "x64")

if(NOT DEV_SHARED_FOLDER)
  message(FATAL_ERROR "Variable DEV_SHARED_FOLDER is either not defined or empty.")
endif()

set(ARTIFACTS_DIR "${CMAKE_SOURCE_DIR}/artifacts")
set(DOWNLOADS_INSTALLER_FILES_DIR "${CMAKE_BINARY_DIR}/downloads/installer-files")
set(DOWNLOADS_TOOLS_DIR "${DOWNLOADS_INSTALLER_FILES_DIR}/win-${DEV_ARCH}/tools")

# Download installer files.
FetchContent_Populate(
  installer_files_x64
  URL https://github.com/Source-SDK-Base-Legacy-Project/installer-files/releases/download/${INSTALLER_FILES_VERSION}/Installer-Files-win-x64.zip
  URL_HASH SHA256=2717a146ed95a90a94e2129453833c8bfea037de22d9d33a53d6b145c2fad689
  SOURCE_DIR   ${DOWNLOADS_INSTALLER_FILES_DIR}/win-x64
)

set(EXTRACTVPK "${DOWNLOADS_TOOLS_DIR}/ExtractVPK/ExtractVPK.exe")
set(STEAMAPPS "${DOWNLOADS_TOOLS_DIR}/SteamApps/SteamApps.exe")
set(VPKEDITCLI "${DOWNLOADS_TOOLS_DIR}/VPKEditCLI/vpkeditcli.exe")

# Configure setup_env_vars.bat
configure_file(
  "${CMAKE_SOURCE_DIR}/cmake/setup_env_vars.bat.in"
  "${CMAKE_SOURCE_DIR}/Installer/setup_env_vars.bat"
  @ONLY
)

# Configure NSIS InstallerPaths.nsh
configure_file(
  "${CMAKE_SOURCE_DIR}/cmake/InstallerPaths.nsh.in"
  "${CMAKE_SOURCE_DIR}/Installer/InstallerPaths.nsh"
  @ONLY
)

function(CONFIGURE_PATHS_INI targetfile extractvpk sharedfolderfile steamapps steamappsini vpkeditcli)
  set(EXTRACTVPK "${extractvpk}")
  set(SHARED_FOLDER_FILE "${sharedfolderfile}")
  set(STEAMAPPS "${steamapps}")
  set(STEAMAPPSINI "${steamappsini}")
  set(VPKEDITCLI "${vpkeditcli}")
  configure_file(
    "${CMAKE_SOURCE_DIR}/cmake/paths.ini.in"
    "${targetfile}"
    @ONLY
  )
endfunction()

# Create dev steamapps.ini
set(STEAMAPPSINI "${CMAKE_BINARY_DIR}/steamapps.ini")
execute_process(
    COMMAND "${STEAMAPPS}" -o "${STEAMAPPSINI}"
    OUTPUT_VARIABLE output
    RESULT_VARIABLE result
)

# Configure dev shared_folder.txt
set(SHARED_FOLDER_FILE "${CMAKE_BINARY_DIR}/shared_folder.txt")
configure_file(
  "${CMAKE_SOURCE_DIR}/cmake/shared_folder.txt.in"
  "${SHARED_FOLDER_FILE}"
  @ONLY
)

# Create dev paths.ini
CONFIGURE_PATHS_INI(
  "${CMAKE_SOURCE_DIR}/scripts/private/paths.ini"
  "${EXTRACTVPK}"
  "${SHARED_FOLDER_FILE}"
  "${STEAMAPPS}"
  "${STEAMAPPSINI}"
  "${VPKEDITCLI}"
)

# Create installer paths.ini
CONFIGURE_PATHS_INI(
  "${CMAKE_SOURCE_DIR}/Installer/common/paths.ini"
  "{{extractvpk}}"
  "{{shared_folder_file}}"
  "{{steamapps}}"
  "{{steamappsini}}"
  "{{vpkeditcli}}"
)
