!include "MUI2.nsh"
!include "TextFunc.nsh"

!ifndef ARCH
  !error "ARCH not defined. [x86/x64]"
!else
  !if ${ARCH} == x86
    !echo "Arch = x86"
  !else if ${ARCH} == x64
    !echo "Arch = x64"
  !else
    !error "ARCH must be either [x86/x64]"
  !endif
!endif

!include "InstallerPaths.nsh"

!define DOWNLOADS_INSTALLER_FILES_ARCH_DIR "${DOWNLOADS_INSTALLER_FILES_DIR}\win-${ARCH}"
!define DOWNLOADS_SDKBASE2006_DIR "${DOWNLOADS_INSTALLER_FILES_ARCH_DIR}\Source SDK Base"
!define DOWNLOADS_SDKBASE2007_DIR "${DOWNLOADS_INSTALLER_FILES_ARCH_DIR}\Source SDK Base 2007"
!define DOWNLOADS_LICENSES_DIR "${DOWNLOADS_INSTALLER_FILES_ARCH_DIR}\licenses"
!define DOWNLOADS_TOOLS_DIR "${DOWNLOADS_INSTALLER_FILES_ARCH_DIR}\tools"
!define DOWNLOADS_EXTRACTVPK_DIR "${DOWNLOADS_TOOLS_DIR}\ExtractVPK"
!define DOWNLOADS_STEAMAPPS_DIR "${DOWNLOADS_TOOLS_DIR}\SteamApps"
!define DOWNLOADS_VPKEDITCLI_DIR "${DOWNLOADS_TOOLS_DIR}\VPKEDITCLI"

!define INSTALL_CONFIG_DIR "$INSTDIR\config"
!define INSTALL_LICENSES_DIR "$INSTDIR\licenses"
!define INSTALL_TOOLS_DIR "$INSTDIR\tools"
!define INSTALL_SCRIPTS_DIR "$INSTDIR\scripts"

!define INSTALL_SHARED_FOLDER_FILE "${INSTALL_CONFIG_DIR}\shared_folder.txt"

!define INSTALL_EXTRACTVPK_DIR "${INSTALL_TOOLS_DIR}\ExtractVPK"
!define INSTALL_EXTRACTVPK_EXE "${INSTALL_EXTRACTVPK_DIR}\ExtractVPK.exe"

!define INSTALL_STEAMAPPS_DIR "${INSTALL_TOOLS_DIR}\SteamApps"
!define INSTALL_STEAMAPPS_EXE "${INSTALL_STEAMAPPS_DIR}\SteamApps.exe"

!define INSTALL_STEAMAPPSINI_FILE "${INSTALL_CONFIG_DIR}\steamapps.ini"

!define INSTALL_VPKEDITCLI_DIR "${INSTALL_TOOLS_DIR}\VPKEditCLI"
!define INSTALL_VPKEDITCLI_EXE "${INSTALL_VPKEDITCLI_DIR}\vpkeditcli.exe"

!define INSTALL_PATHSINI_DIR "${INSTALL_SCRIPTS_DIR}\private"
!define INSTALL_PATHSINI_FILE "${INSTALL_PATHSINI_DIR}\paths.ini"

!define TEMP_DIR "$INSTDIR\temp"

!define APP_NAME "Source SDK Base Resources"

Name "${NAME}"
OutFile "${OUTPUTFILE}_${VERSION_FULL}_Windows_${ARCH}.exe"
Caption "${CAPTION}"
!if ${ARCH} == x86
InstallDir "$PROGRAMFILES32\${APP_NAME}"
!else if ${ARCH} == x64
InstallDir "$PROGRAMFILES64\${APP_NAME}"
!endif
Unicode true
RequestExecutionLevel admin
SetCompress force
ManifestDPIAware true
ShowInstDetails show

!define MUI_ABORTWARNING

!insertmacro MUI_PAGE_LICENSE "..\LICENSE"
!insertmacro MUI_PAGE_DIRECTORY

Var /GLOBAL SHARED_FOLDER

!define MUI_DIRECTORYPAGE_VARIABLE $SHARED_FOLDER
!define MUI_DIRECTORYPAGE_TEXT_TOP "Choose a shared folder. This is where shared content will be installed to. To select a different folder, click Browse and select another folder. Click Next to continue."
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "Shared Folder"
!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_COMPONENTS
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

VIProductVersion "${VERSION}.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${APP_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" "${VERSION}.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${APP_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" ""
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${VERSION}"

Var /GLOBAL SDKBASE2006_DIR

!ifdef SOURCE2007
Var /GLOBAL SDKBASE2007_DIR
Var /GLOBAL EP2CONTENT_USES_HL2
!endif

!macro ExtractFilesFromVPK VPKPath OutputDir FilesToExtract NoFileRootPath
  ${If} ${NoFileRootPath} == true
    # Without root path
    nsExec::ExecToLog '"${INSTALL_EXTRACTVPK_EXE}" -i "${VPKPath}" -o "${OutputDir}" -e "${FilesToExtract}" -n'
  ${Else}
    # With root path
    nsExec::ExecToLog '"${INSTALL_EXTRACTVPK_EXE}" -i "${VPKPath}" -o "${OutputDir}" -e "${FilesToExtract}"'
  ${EndIf}
  Pop $R0
  ${If} $R0 != 0
    Abort "${INSTALL_EXTRACTVPK_EXE} returned $R0"
  ${EndIf}
!macroend

!macro RunContentInstallationScript ScriptFileName Args SourceArg bOutputToLog
  ${If} ${bOutputToLog} == true
    nsExec::ExecToLog 'powershell.exe -ExecutionPolicy Bypass -File "${INSTALL_SCRIPTS_DIR}\${ScriptFileName}.ps1" ${Args} -Source ${SourceArg} -ErrorAction Stop'
    Pop $R0
    ${If} $R0 != 0
      Abort "${ScriptFileName}.ps1 returned $R0"
    ${EndIf}
  ${Else}
    ExecWait 'powershell.exe -ExecutionPolicy Bypass -File "${INSTALL_SCRIPTS_DIR}\${ScriptFileName}.ps1" ${Args} -Source ${SourceArg} -ErrorAction Stop' $R0
    IfErrors 0 +2
    Abort "${ScriptFileName}.ps1 returned $R0"
  ${EndIf}
!macroend

!macro ReplaceTextInPathsINI TextToReplace NewText
  nsExec::ExecToLog 'powershell.exe -ExecutionPolicy Bypass -File "${TEMP_DIR}\replace_text_in_file.ps1" "${TextToReplace}" "${NewText}" "${INSTALL_PATHSINI_FILE}" -ErrorAction Stop'
  Pop $R0
  ${If} $R0 != 0
    Abort "replace_text_in_file.ps1 returned $R0"
  ${EndIf}
!macroend

!macro UpdateSteamVPKs SourceArg
  # Update Steam VPKs.
  DetailPrint "Updating steam_vpks.vdf..."
  nsExec::ExecToLog 'powershell.exe -ExecutionPolicy Bypass -File "${INSTALL_SCRIPTS_DIR}\private\update_steam_vpks.ps1" -Source ${SourceArg} -ErrorAction Stop'
  Pop $R0
  ${If} $R0 != 0
    Abort "update_steam_vpks.ps1 returned $R0"
  ${EndIf}
!macroend

Section "Base files" SecBaseFiles
  SetOutPath $INSTDIR
  SetDetailsPrint listonly

  # ========
  # INSTALLATION CORE.
  # ========

  # Create directories
  CreateDirectory "$INSTDIR"
  CreateDirectory "${INSTALL_CONFIG_DIR}"
  CreateDirectory "${INSTALL_TOOLS_DIR}"
  CreateDirectory "${INSTALL_SCRIPTS_DIR}"

  # Write licenses.
  SetOutPath "${INSTALL_LICENSES_DIR}"
  File /oname=Source_SDK_Base_Resources.txt ..\LICENSE
  File /a /r "${DOWNLOADS_LICENSES_DIR}\*.*"

  SetOutPath "$INSTDIR"

  # Write shared folder file.
  FileOpen $R0 "${INSTALL_SHARED_FOLDER_FILE}" w
  FileWrite $R0 "$SHARED_FOLDER"
  FileClose $R0

  # Replace tokens in paths.ini
  SetOutPath "${TEMP_DIR}"
  File ".\scripts\replace_text_in_file.ps1"
  SetOutPath "${INSTALL_PATHSINI_DIR}"
  File ".\common\paths.ini"
  
  DetailPrint "Replacing text in ${INSTALL_PATHSINI_FILE} ..."
  !insertmacro ReplaceTextInPathsINI "{{extractvpk}}" "${INSTALL_EXTRACTVPK_EXE}"
  !insertmacro ReplaceTextInPathsINI "{{shared_folder_file}}" "${INSTALL_SHARED_FOLDER_FILE}"
  !insertmacro ReplaceTextInPathsINI "{{steamapps}}" "${INSTALL_STEAMAPPS_EXE}"
  !insertmacro ReplaceTextInPathsINI "{{steamappsini}}" "${INSTALL_STEAMAPPSINI_FILE}"
  !insertmacro ReplaceTextInPathsINI "{{vpkeditcli}}" "${INSTALL_VPKEDITCLI_EXE}"

  # Remove temp files since we don't need them anymore.
  RMDir /r "${TEMP_DIR}"

  # Extract tools
  DetailPrint "Extracting tools..."
  CreateDirectory "${INSTALL_TOOLS_DIR}"
  SetOutPath "${INSTALL_TOOLS_DIR}"
  File /a /r "${DOWNLOADS_TOOLS_DIR}\*.*"

  # Run SteamApps.exe to create steamapps.ini.
  nsExec::ExecToLog '"${INSTALL_STEAMAPPS_EXE}" -o "${INSTALL_STEAMAPPSINI_FILE}"'
  Pop $R0
  DetailPrint "SteamApps.exe returned $R0"
  ${If} $R0 != 0
    Abort "Installation failed!"
  ${EndIf}
  
  # Extract installation scripts.
  DetailPrint "Extracting install scripts..."
  SetOutPath "${INSTALL_SCRIPTS_DIR}"
  File /a /r "..\scripts\*.ps1"
  
  # Uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  # ========

  # ========
  # SPECIFIC INSTALLATIONS
  # ========
 
  ReadINIStr $SDKBASE2006_DIR "${INSTALL_STEAMAPPSINI_FILE}" steamapps sdkbase2006
  
  !ifdef SOURCE2006
    # Extract specific Source SDK Base 2006 resources
   
    DetailPrint "Extracting Source 2006 content..."
    SetOutPath "$SDKBASE2006_DIR"
    File /a /r "${DOWNLOADS_SDKBASE2006_DIR}\*.*"

    # Extract Episodic male and female shared anims.
    !insertmacro ExtractFilesFromVPK "$SDKBASE2006_DIR\vpks\depot_213_dir.vpk" "$SDKBASE2006_DIR\hl2_2006\models\humans" "episodic/models/humans" true
  
    # Update Steam VPKs.
    !insertmacro UpdateSteamVPKs "2006"
  !endif
  
  !ifdef SOURCE2007
    ReadINIStr $SDKBASE2007_DIR "${INSTALL_STEAMAPPSINI_FILE}" steamapps sdkbase2007

    # Extract specific Source SDK Base 2007 resources
    DetailPrint "Extracting Source 2007 content..."
    SetOutPath "$SDKBASE2007_DIR"
    File /a /r "${DOWNLOADS_SDKBASE2007_DIR}\*.*"

    # Fixup misplaced resources
    DetailPrint "Copying EP2 media files..."
    CopyFiles "$SDKBASE2006_DIR\ep2\media\*" "$SDKBASE2007_DIR\ep2\media"

    DetailPrint "Copying EP2 VPK files..."
    CopyFiles "$SDKBASE2006_DIR\vpks\depot_421_*.vpk" "$SDKBASE2007_DIR\vpks"
    CopyFiles "$SDKBASE2006_DIR\vpks\depot_422_*.vpk" "$SDKBASE2007_DIR\vpks"
    CopyFiles "$SDKBASE2006_DIR\vpks\depot_423_*.vpk" "$SDKBASE2007_DIR\vpks"
    
    # Update Steam VPKs.
    !insertmacro UpdateSteamVPKs "2007"
  !endif
  
  # ========
SectionEnd

!macro EnableSection SecName
  !insertmacro ClearSectionFlag ${SecName} ${SF_RO}
  !insertmacro SetSectionFlag ${SecName} ${SF_SELECTED}
!macroend

!macro DisableSection SecName
  !insertmacro ClearSectionFlag ${SecName} ${SF_SELECTED}
  !insertmacro SetSectionFlag ${SecName} ${SF_RO}
!macroend

!ifdef SOURCE2007

!macro EnableEP2Sections
  !insertmacro EnableSection ${SecEP2EnglishSoundFiles}
  !insertmacro EnableSection ${SecEP2Teaser}
!macroend

!macro DisableEP2Sections
  !insertmacro DisableSection ${SecEP2EnglishSoundFiles}
  !insertmacro DisableSection ${SecEP2Teaser}
!macroend

Section /o "EP2 English sound files" SecEP2EnglishSoundFiles
  ${If} $EP2CONTENT_USES_HL2 == true
    DetailPrint "Extracting EP2 sound files from Half-Life 2 ..."
    !insertmacro RunContentInstallationScript "HL2EP2" "-Base" "2007" true
  ${Else}
    DetailPrint "Extracting EP2 sound files from Source SDK Base 2013 Singleplayer ..."
    !insertmacro RunContentInstallationScript "SDK2013SP_HL2EP2" "-Base" "2007" true
  ${EndIf}
  
  # NOTE: steam_vpks.vdf files are already updated by the Powershell scripts.
SectionEnd

Section /o "EP2 Teaser" SecEP2Teaser
  !insertmacro RunContentInstallationScript "Install_EP2_Teaser" "" "2007" true
SectionEnd
!endif

Section /o "Source Content Installer" SecSourceContentInstaller
  SetOutPath $INSTDIR
  SetDetailsPrint listonly
  DetailPrint "Extracting SourceContentInstaller..."

  !ifdef SOURCE2006
    !ifdef SOURCE2007
      File "/oname=SourceContentInstaller.exe" ".\SourceContentInstaller\SourceContentInstaller_Full.exe"
      File "/oname=SourceContentUninstaller.exe" ".\SourceContentInstaller\SourceContentUninstaller_Full.exe"
    !else
      File "/oname=SourceContentInstaller.exe" ".\SourceContentInstaller\SourceContentInstaller_Only2006.exe"
      File "/oname=SourceContentUninstaller.exe" ".\SourceContentInstaller\SourceContentUninstaller_Only2006.exe"
    !endif
  !else
    !ifdef SOURCE2007
      File "/oname=SourceContentInstaller.exe" ".\SourceContentInstaller\SourceContentInstaller_Only2007.exe"
      File "/oname=SourceContentUninstaller.exe" ".\SourceContentInstaller\SourceContentUninstaller_Only2007.exe"
    !endif
  !endif
SectionEnd

LangString DESC_BaseFiles ${LANG_ENGLISH} "Install base resources."
!ifdef SOURCE2007
  LangString DESC_EP2EnglishSoundFiles ${LANG_ENGLISH} "Install HL2:EP2 English sound files.$\r$\n$\r$\nRequires either Half-Life 2 or Source SDK Base 2013 Singleplayer installed."
  LangString DESC_EP2Teaser ${LANG_ENGLISH} "Install HL2:EP2 media teaser.$\r$\n$\r$\nRequires either Half-Life 2 or Source SDK Base 2013 Singleplayer installed."
!endif
LangString DESC_SourceContentInstaller ${LANG_ENGLISH} "GUI content installation tool."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecBaseFiles} $(DESC_BaseFiles)
  !ifdef SOURCE2007
    !insertmacro MUI_DESCRIPTION_TEXT ${SecEP2EnglishSoundFiles} $(DESC_EP2EnglishSoundFiles)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecEP2Teaser} $(DESC_EP2Teaser)
  !endif
  !insertmacro MUI_DESCRIPTION_TEXT ${SecSourceContentInstaller} $(DESC_SourceContentInstaller)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Function .onInit

  # ========
  # Load shared folder.
  # ========
  StrCpy $SHARED_FOLDER "$INSTDIR\shared_folder"

  ${If} ${FileExists} "${INSTALL_SHARED_FOLDER_FILE}"
    ${LineRead} "${INSTALL_SHARED_FOLDER_FILE}" 1 $SHARED_FOLDER
  ${EndIf}

  # ========

  # NOTE: Source SDK Base 2007 fixes require SDK Base 2006 installed.
  ReadRegDWORD $R0 HKCU Software\Valve\Steam\Apps\215 Installed

  !ifdef SOURCE2007
    ReadRegDWORD $R1 HKCU Software\Valve\Steam\Apps\218 Installed
    ${If} $R0 == 0
      ${If} $R1 == 0
        MessageBox MB_OK "Source SDK Base 2006 and 2007 are not installed. The setup cannot continue."
        Abort
      ${Else}
        MessageBox MB_OK "Source SDK Base 2006 is not installed. The setup cannot continue."
        Abort
      ${EndIf}
    ${ElseIf} $R1 == 0
      MessageBox MB_OK "Source SDK Base 2007 is not installed. The setup cannot continue."
      Abort
    ${EndIf}
  !else
    ${If} $R0 == 0
      MessageBox MB_OK "Source SDK Base 2006 is not installed. The setup cannot continue."
      Abort
    ${EndIf}
  !endif

  # Make Base files section mandatory.
  !insertmacro SetSectionFlag ${SecBaseFiles} ${SF_RO}

  # Check if HL2 is installed.
  ReadRegDWORD $R0 HKCU Software\Valve\Steam\Apps\220 Installed
  # R0 == 0 => HL2 is not installed
  # R0 != 0 => HL2 is installed

  !ifdef SOURCE2007
    ${If} $R0 == 0
      # Check if Source SDK Base 2013 Singleplayer is installed.
      ReadRegDWORD $R1 HKCU Software\Valve\Steam\Apps\243730 Installed
      ${If} $R1 == 0
        !insertmacro DisableEP2Sections
      ${Else}
        StrCpy $EP2CONTENT_USES_HL2 false
        !insertmacro EnableEP2Sections
      ${EndIf}
    ${Else}
      StrCpy $EP2CONTENT_USES_HL2 true
      !insertmacro EnableEP2Sections
    ${EndIf}
  !endif

FunctionEnd

Section /o "un.Shared folder" SecUnSharedFolder
  ${If} ${FileExists} "${INSTALL_SHARED_FOLDER_FILE}"
    ${LineRead} "${INSTALL_SHARED_FOLDER_FILE}" 1 $R0
    RMDir /r "$R0"
  ${EndIf}
SectionEnd

Section -Uninstall
  Delete "$INSTDIR\Uninstall.exe"
  RMDir /r "$INSTDIR"
SectionEnd

LangString DESC_UnSharedFolder ${LANG_ENGLISH} "Delete shared folder."

!insertmacro MUI_UNFUNCTION_DESCRIPTION_BEGIN 
  !insertmacro MUI_DESCRIPTION_TEXT ${SecUnSharedFolder} $(DESC_UnSharedFolder)
!insertmacro MUI_UNFUNCTION_DESCRIPTION_END

Function un.onInit
  
FunctionEnd
