!include "MUI2.nsh"

!ifdef SOURCE2006
  !ifdef SOURCE2007
    !define SOURCE_ARGS "both"
  !else
    !define SOURCE_ARGS "2006"
  !endif
!else
  !ifdef SOURCE2007
    !define SOURCE_ARGS "2007"
  !endif
!endif

Name "${NAME}"
OutFile "${OUTPUTFILE}.exe"
Caption "${CAPTION}"

Unicode true
SetCompress force
#ManifestDPIAware true
ShowInstDetails show

!define CONFIG_DIR "$EXEDIR\config"
!define SCRIPTS_DIR "$EXEDIR\scripts"
!define STEAMAPPSINI "${CONFIG_DIR}\steamapps.ini"

!define MUI_ABORTWARNING
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

!macro RunContentInstallationScript ScriptFileName Args bOutputToLog
  ${If} ${bOutputToLog} == true
    nsExec::ExecToLog 'powershell.exe -ExecutionPolicy Bypass -File "${SCRIPTS_DIR}\${ScriptFileName}.ps1" ${Args} -ErrorAction Stop'
    Pop $R0
    ${If} $R0 != 0
      Abort "${ScriptFileName}.ps1 returned $R0"
    ${EndIf}
  ${Else}
    ExecWait 'powershell.exe -ExecutionPolicy Bypass -File "${SCRIPTS_DIR}\${ScriptFileName}.ps1" ${Args} -ErrorAction Stop' $R0
    IfErrors 0 +2
    Abort "${ScriptFileName}.ps1 returned $R0"
  ${EndIf}
!macroend

!macro AddSection SectionName DisplayName ScriptFileName Args Source
  Section /o "${DisplayName}" "${SectionName}"
    SetDetailsPrint listonly
    !ifndef UNINSTALLER
      !insertmacro RunContentInstallationScript "${ScriptFileName}" "${Args} -Source ${Source}" true
    !else
      !insertmacro RunContentInstallationScript "${ScriptFileName}" "${Args} -Source ${Source} -Uninstall" true
    !endif
  SectionEnd
!macroend

!macro AddBaseContentSection GameShortName Source
  !insertmacro AddSection Sec${GameShortName}Base "Base" "${GameShortName}" "-Base" ${Source}
!macroend

!macro AddMapsContentSection GameShortName Source
  !insertmacro AddSection Sec${GameShortName}Maps "Maps" "${GameShortName}" "-Maps" ${Source}
!macroend

!macro AddLanguageSection GameShortName LangFullName LangShortName LangCommandParam Source
  !insertmacro AddSection Sec${GameShortName}Lang${LangShortName} "${LangFullName}" "${GameShortName}" "-Language ${LangCommandParam}" ${Source}
!macroend

!macro Add4LanguageSections GameShortName Source
  !insertmacro AddLanguageSection ${GameShortName} "French" "French" "french" ${Source}
  !insertmacro AddLanguageSection ${GameShortName} "German" "German" "german" ${Source}
  !insertmacro AddLanguageSection ${GameShortName} "Russian" "Russian" "russian" ${Source}
  !insertmacro AddLanguageSection ${GameShortName} "Spanish" "Spanish" "spanish" ${Source}
!macroend

!macro Add8LanguageSections GameShortName Source
  !insertmacro AddLanguageSection ${GameShortName} "French" "French" "french" ${Source}
  !insertmacro AddLanguageSection ${GameShortName} "German" "German" "german" ${Source}
  !insertmacro AddLanguageSection ${GameShortName} "Italian" "Italian" "italian" ${Source}
  !insertmacro AddLanguageSection ${GameShortName} "Koreana" "Koreana" "koreana" ${Source}
  !insertmacro AddLanguageSection ${GameShortName} "Russian" "Russian" "russian" ${Source}
  !insertmacro AddLanguageSection ${GameShortName} "Simplified Chinese" "SChinese" "schinese" ${Source}
  !insertmacro AddLanguageSection ${GameShortName} "Spanish" "Spanish" "spanish" ${Source}
  !insertmacro AddLanguageSection ${GameShortName} "Traditional Chinese" "TChinese" "tchinese" ${Source}
!macroend

!macro AddSectionGroupString NSISLang LangStringIDSuffix ContentFullName
  !ifndef UNINSTALLER
    LangString DESC_${LangStringIDSuffix} ${NSISLang} "Install ${ContentFullName}."
  !else
    LangString DESC_${LangStringIDSuffix} ${NSISLang} "Uninstall ${ContentFullName}."
  !endif
!macroend

!macro AddContentString NSISLang GameShortName ContentShortName ContentFullName
  !ifndef UNINSTALLER
    LangString DESC_${GameShortName}_${ContentShortName} ${NSISLang} "Install ${ContentFullName}."
  !else
    LangString DESC_${GameShortName}_${ContentShortName} ${NSISLang} "Uninstall ${ContentFullName}."
  !endif
!macroend

!macro AddBaseContentString NSISLang GameShortName GameFullName
  !ifndef UNINSTALLER
    LangString DESC_${GameShortName}_Base ${NSISLang} "Install ${GameFullName} Base content."
  !else
    LangString DESC_${GameShortName}_Base ${NSISLang} "Uninstall ${GameFullName} Base content."
  !endif
!macroend

!macro AddMapsContentString NSISLang GameShortName GameFullName
  !ifndef UNINSTALLER
    LangString DESC_${GameShortName}_Maps ${NSISLang} "Install ${GameFullName} Maps content."
  !else
    LangString DESC_${GameShortName}_Maps ${NSISLang} "Uninstall ${GameFullName} Maps content."
  !endif
!macroend

!macro AddLanguageString NSISLang GameShortName GameFullName LangShortName LangFullName
  !ifndef UNINSTALLER
    LangString DESC_${GameShortName}_Lang_${LangShortName} ${NSISLang} "Install ${GameFullName} ${LangFullName} content."
  !else
    LangString DESC_${GameShortName}_Lang_${LangShortName} ${NSISLang} "Uninstall ${GameFullName} ${LangFullName} content."
  !endif
!macroend

!macro Add4LanguageStrings NSISLang GameShortName GameFullName
  !insertmacro AddLanguageString ${NSISLang} "${GameShortName}" "${GameFullName}" "French" "French"
  !insertmacro AddLanguageString ${NSISLang} "${GameShortName}" "${GameFullName}" "German" "German"
  !insertmacro AddLanguageString ${NSISLang} "${GameShortName}" "${GameFullName}" "Russian" "Russian"
  !insertmacro AddLanguageString ${NSISLang} "${GameShortName}" "${GameFullName}" "Spanish" "Spanish"
!macroend

!macro Add8LanguageStrings NSISLang GameShortName GameFullName
  !insertmacro AddLanguageString ${NSISLang} "${GameShortName}" "${GameFullName}" "French" "French"
  !insertmacro AddLanguageString ${NSISLang} "${GameShortName}" "${GameFullName}" "German" "German"
  !insertmacro AddLanguageString ${NSISLang} "${GameShortName}" "${GameFullName}" "Italian" "Italian"
  !insertmacro AddLanguageString ${NSISLang} "${GameShortName}" "${GameFullName}" "Koreana" "Koreana"
  !insertmacro AddLanguageString ${NSISLang} "${GameShortName}" "${GameFullName}" "Russian" "Russian"
  !insertmacro AddLanguageString ${NSISLang} "${GameShortName}" "${GameFullName}" "SChinese" "Simplified Chinese"
  !insertmacro AddLanguageString ${NSISLang} "${GameShortName}" "${GameFullName}" "Spanish" "Spanish"
  !insertmacro AddLanguageString ${NSISLang} "${GameShortName}" "${GameFullName}" "TChinese" "Traditional Chinese"
!macroend

!macro AddSectionGroupDescription SecGroupID LangStringIDSuffix
  !insertmacro MUI_DESCRIPTION_TEXT ${SecGroupID} $(DESC_${LangStringIDSuffix})
!macroend

!macro AddContentDescription GameShortName ContentShortName
  !insertmacro MUI_DESCRIPTION_TEXT ${Sec${GameShortName}${ContentShortName}} $(DESC_${GameShortName}_${ContentShortName})
!macroend

!macro AddBaseContentDescription GameShortName
  !insertmacro MUI_DESCRIPTION_TEXT ${Sec${GameShortName}Base} $(DESC_${GameShortName}_Base)
!macroend

!macro AddMapsContentDescription GameShortName
  !insertmacro MUI_DESCRIPTION_TEXT ${Sec${GameShortName}Maps} $(DESC_${GameShortName}_Maps)
!macroend

!macro AddLanguageDescription GameShortName LangShortName
  !insertmacro MUI_DESCRIPTION_TEXT ${Sec${GameShortName}Lang${LangShortName}} $(DESC_${GameShortName}_Lang_${LangShortName})
!macroend

!macro Add4LanguageDescriptions GameShortName
  !insertmacro AddLanguageDescription ${GameShortName} "French"
  !insertmacro AddLanguageDescription ${GameShortName} "German"
  !insertmacro AddLanguageDescription ${GameShortName} "Russian"
  !insertmacro AddLanguageDescription ${GameShortName} "Spanish"
!macroend

!macro Add8LanguageDescriptions GameShortName
  !insertmacro AddLanguageDescription ${GameShortName} "French"
  !insertmacro AddLanguageDescription ${GameShortName} "German"
  !insertmacro AddLanguageDescription ${GameShortName} "Italian"
  !insertmacro AddLanguageDescription ${GameShortName} "Koreana"
  !insertmacro AddLanguageDescription ${GameShortName} "Russian"
  !insertmacro AddLanguageDescription ${GameShortName} "SChinese"
  !insertmacro AddLanguageDescription ${GameShortName} "Spanish"
  !insertmacro AddLanguageDescription ${GameShortName} "TChinese"
!macroend

!macro EnableSection SecName
  !insertmacro ClearSectionFlag ${SecName} ${SF_RO}
!macroend

!macro DisableSection SecName
  !insertmacro ClearSectionFlag ${SecName} ${SF_SELECTED}
  !insertmacro SetSectionFlag ${SecName} ${SF_RO}
!macroend

!macro DisableSectionGroup SecGroupID
  !insertmacro SetSectionFlag ${SecGroupID} ${SF_RO}
!macroend

!macro DisableContentSection GameShortName ContentShortName
  !insertmacro ClearSectionFlag ${Sec${GameShortName}${ContentShortName}} ${SF_SELECTED}
  !insertmacro SetSectionFlag ${Sec${GameShortName}${ContentShortName}} ${SF_RO}
!macroend

!macro DisableBaseContentSection GameShortName
  !insertmacro DisableContentSection ${GameShortName} "Base"
!macroend

!macro DisableMapsContentSection GameShortName
  !insertmacro DisableContentSection ${GameShortName} "Maps"
!macroend

!macro DisableLanguageSection GameShortName LangShortName
  !insertmacro DisableContentSection ${GameShortName} "Lang${LangShortName}"
!macroend

!macro Disable4LanguageSections GameShortName
  !insertmacro DisableLanguageSection ${GameShortName} "French"
  !insertmacro DisableLanguageSection ${GameShortName} "German"
  !insertmacro DisableLanguageSection ${GameShortName} "Russian"
  !insertmacro DisableLanguageSection ${GameShortName} "Spanish"
!macroend

!macro Disable8LanguageSections GameShortName
  !insertmacro DisableLanguageSection ${GameShortName} "French"
  !insertmacro DisableLanguageSection ${GameShortName} "German"
  !insertmacro DisableLanguageSection ${GameShortName} "Italian"
  !insertmacro DisableLanguageSection ${GameShortName} "Koreana"
  !insertmacro DisableLanguageSection ${GameShortName} "Russian"
  !insertmacro DisableLanguageSection ${GameShortName} "SChinese"
  !insertmacro DisableLanguageSection ${GameShortName} "Spanish"
  !insertmacro DisableLanguageSection ${GameShortName} "TChinese"
!macroend

!macro DisableUnavailableLanguageInLanguageSection GameShortName LangShortName VPKFilePath
  ${IfNot} ${FileExists} "${VPKFilePath}"
    !insertmacro DisableLanguageSection "${GameShortName}" "${LangShortName}"
  ${EndIf}
!macroend

!macro DisableUnavailableLanguagesIn4LanguageSections GameShortName VPKDir VPKNamePrefix
  !insertmacro DisableUnavailableLanguageInLanguageSection ${GameShortName} "French" "${VPKDir}\${VPKNamePrefix}_french_dir.vpk"
  !insertmacro DisableUnavailableLanguageInLanguageSection ${GameShortName} "German" "${VPKDir}\${VPKNamePrefix}_german_dir.vpk"
  !insertmacro DisableUnavailableLanguageInLanguageSection ${GameShortName} "Russian" "${VPKDir}\${VPKNamePrefix}_russian_dir.vpk"
  !insertmacro DisableUnavailableLanguageInLanguageSection ${GameShortName} "Spanish" "${VPKDir}\${VPKNamePrefix}_spanish_dir.vpk"
!macroend

!macro DisableUnavailableLanguagesIn8LanguageSections GameShortName VPKDir VPKNamePrefix
  !insertmacro DisableUnavailableLanguageInLanguageSection ${GameShortName} "French" "${VPKDir}\${VPKNamePrefix}_french_dir.vpk"
  !insertmacro DisableUnavailableLanguageInLanguageSection ${GameShortName} "German" "${VPKDir}\${VPKNamePrefix}_german_dir.vpk"
  !insertmacro DisableUnavailableLanguageInLanguageSection ${GameShortName} "Italian" "${VPKDir}\${VPKNamePrefix}_italian_dir.vpk"
  !insertmacro DisableUnavailableLanguageInLanguageSection ${GameShortName} "Koreana" "${VPKDir}\${VPKNamePrefix}_koreana_dir.vpk"
  !insertmacro DisableUnavailableLanguageInLanguageSection ${GameShortName} "Russian" "${VPKDir}\${VPKNamePrefix}_russian_dir.vpk"
  !insertmacro DisableUnavailableLanguageInLanguageSection ${GameShortName} "SChinese" "${VPKDir}\${VPKNamePrefix}_schinese_dir.vpk"
  !insertmacro DisableUnavailableLanguageInLanguageSection ${GameShortName} "Spanish" "${VPKDir}\${VPKNamePrefix}_spanish_dir.vpk"
  !insertmacro DisableUnavailableLanguageInLanguageSection ${GameShortName} "TChinese" "${VPKDir}\${VPKNamePrefix}_tchinese_dir.vpk"
!macroend

!define CSS_SHORT_NAME "CSS"
!define CSS_FULL_NAME "Counter-Strike: Source"

!define DOD_SHORT_NAME "DOD"
!define DOD_FULL_NAME "Day of Defeat: Source"

!define HL1_SHORT_NAME "HL1"
!define HL1_FULL_NAME "Half-Life: Source"

!define HL1MP_SHORT_NAME "HL1MP"
!define HL1MP_FULL_NAME "Half-Life Deathmatch: Source"

!define HL2_SHORT_NAME "HL2"
!define HL2_FULL_NAME "Half-Life 2"

!define HL2EP1_SHORT_NAME "HL2EP1"
!define HL2EP1_FULL_NAME "Half-Life 2: Episode One"

!ifdef SOURCE2007
  !define HL2EP2_SHORT_NAME "HL2EP2"
  !define HL2EP2_FULL_NAME "Half-Life 2: Episode Two"
!endif

!define HL2MP_SHORT_NAME "HL2MP"
!define HL2MP_FULL_NAME "Half-Life 2: Deathmatch"

!define LOSTCOAST_SHORT_NAME "LostCoast"
!define LOSTCOAST_FULL_NAME "Half-Life 2: Lost Coast"

!ifdef SOURCE2007
  !define PORTAL_SHORT_NAME "Portal"
  !define PORTAL_FULL_NAME "Portal"
!endif

!define SDK2013MP_HL2MP_SHORT_NAME "SDK2013MP_HL2MP"
!define SDK2013MP_HL2MP_FULL_NAME "Source SDK Base 2013 Multiplayer"

!ifdef SOURCE2007
  !define SDK2013SP_HL2EP2_SHORT_NAME "SDK2013SP_HL2EP2"
  !define SDK2013SP_HL2EP2_FULL_NAME "Source SDK Base 2013 Singleplayer"
!endif

!ifndef UNINSTALLER
  Var /GLOBAL CSTRIKE_DIR
  Var /GLOBAL HL1_DIR
  Var /GLOBAL HL2_DIR
!endif

!ifdef SOURCE2007
  !ifndef UNINSTALLER
    Var /GLOBAL PORTAL_DIR
    Section /o "EP2 Teaser" SecEP2Teaser
      !insertmacro RunContentInstallationScript "Install_EP2_Teaser" "" true
    SectionEnd
  !endif
!endif

SectionGroup "CS:S" SecGroupCSS
  !insertmacro AddBaseContentSection ${CSS_SHORT_NAME} ${SOURCE_ARGS}
  !insertmacro AddMapsContentSection ${CSS_SHORT_NAME} ${SOURCE_ARGS}
  
  SectionGroup "Localisation" SecGroupCSSLang
    !insertmacro AddLanguageSection ${CSS_SHORT_NAME} "French" "French" "french" ${SOURCE_ARGS}
    !insertmacro AddLanguageSection ${CSS_SHORT_NAME} "German" "German" "german" ${SOURCE_ARGS}
    !insertmacro AddLanguageSection ${CSS_SHORT_NAME} "Italian" "Italian" "italian" ${SOURCE_ARGS}
    !insertmacro AddLanguageSection ${CSS_SHORT_NAME} "Japanese" "Japanese" "japanese" ${SOURCE_ARGS}
    !insertmacro AddLanguageSection ${CSS_SHORT_NAME} "Koreana" "Koreana" "koreana" ${SOURCE_ARGS}
    !insertmacro AddLanguageSection ${CSS_SHORT_NAME} "Russian" "Russian" "russian" ${SOURCE_ARGS}
    !insertmacro AddLanguageSection ${CSS_SHORT_NAME} "Simplified Chinese" "SChinese" "schinese" ${SOURCE_ARGS}
    !insertmacro AddLanguageSection ${CSS_SHORT_NAME} "Spanish" "Spanish" "spanish" ${SOURCE_ARGS}
    !insertmacro AddLanguageSection ${CSS_SHORT_NAME} "Traditional Chinese" "TChinese" "tchinese" ${SOURCE_ARGS}
    !insertmacro AddLanguageSection ${CSS_SHORT_NAME} "Thai" "Thai" "thai" ${SOURCE_ARGS}
  SectionGroupEnd
SectionGroupEnd

SectionGroup "DOD:S" SecGroupDOD
  !insertmacro AddBaseContentSection ${DOD_SHORT_NAME} ${SOURCE_ARGS}
  !insertmacro AddMapsContentSection ${DOD_SHORT_NAME} ${SOURCE_ARGS}
SectionGroupEnd

SectionGroup "HL:S" SecGroupHL1
  !insertmacro AddBaseContentSection ${HL1_SHORT_NAME} ${SOURCE_ARGS}
  !insertmacro AddSection SecHL1HD "HD" "HL1" "-HD" ${SOURCE_ARGS}
  !insertmacro AddMapsContentSection ${HL1_SHORT_NAME} ${SOURCE_ARGS}
  SectionGroup "Localisation" SecGroupHL1Lang
    !insertmacro Add8LanguageSections ${HL1_SHORT_NAME} ${SOURCE_ARGS}
  SectionGroupEnd
SectionGroupEnd

SectionGroup "HLDM:S" SecGroupHL1MP
  !insertmacro AddBaseContentSection ${HL1MP_SHORT_NAME} ${SOURCE_ARGS}
  !insertmacro AddSection SecHL1MPHL1 "HL1" "HL1MP" "-HL" ${SOURCE_ARGS}
  !insertmacro AddMapsContentSection ${HL1MP_SHORT_NAME} ${SOURCE_ARGS}
SectionGroupEnd

SectionGroup "HL2" SecGroupHL2
  SectionGroup "Localisation" SecGroupHL2Lang
    !insertmacro Add8LanguageSections ${HL2_SHORT_NAME} ${SOURCE_ARGS}
  SectionGroupEnd
SectionGroupEnd

SectionGroup "HL2:EP1" SecGroupHL2EP1
  SectionGroup "Localisation" SecGroupHL2EP1Lang
    !insertmacro Add8LanguageSections ${HL2EP1_SHORT_NAME} ${SOURCE_ARGS}
  SectionGroupEnd
SectionGroupEnd

!ifdef SOURCE2007
SectionGroup "HL2:EP2" SecGroupHL2EP2
  !insertmacro AddBaseContentSection ${HL2EP2_SHORT_NAME} "2007"
  SectionGroup "Localisation" SecGroupHL2EP2Lang
    !insertmacro Add4LanguageSections ${HL2EP2_SHORT_NAME} "2007"
  SectionGroupEnd
SectionGroupEnd
!endif

SectionGroup "HL2:DM" SecGroupHL2MP
  !insertmacro AddBaseContentSection ${HL2MP_SHORT_NAME} ${SOURCE_ARGS}
SectionGroupEnd

SectionGroup "Lost Coast" SecGroupLostCoast
  !insertmacro AddBaseContentSection ${LOSTCOAST_SHORT_NAME} ${SOURCE_ARGS}
  !insertmacro AddMapsContentSection ${LOSTCOAST_SHORT_NAME} ${SOURCE_ARGS}
  SectionGroup "Localisation" SecGroupLostCoastLang
    !insertmacro Add8LanguageSections ${LOSTCOAST_SHORT_NAME} ${SOURCE_ARGS}
  SectionGroupEnd
SectionGroupEnd

!ifdef SOURCE2007
SectionGroup "Portal" SecGroupPortal
  !insertmacro AddBaseContentSection ${PORTAL_SHORT_NAME} "2007"
  !insertmacro AddMapsContentSection ${PORTAL_SHORT_NAME} "2007"
  SectionGroup "Localisation" SecGroupPortalLang
    !insertmacro Add4LanguageSections ${PORTAL_SHORT_NAME} "2007"
  SectionGroupEnd
SectionGroupEnd
!endif

SectionGroup "SDK2013MP HL2:DM" SecGroupSDK2013MP_HL2MP
  !insertmacro AddBaseContentSection ${SDK2013MP_HL2MP_SHORT_NAME} ${SOURCE_ARGS}
SectionGroupEnd

!ifdef SOURCE2007
SectionGroup "SDK2013SP HL2:EP2" SecGroupSDK2013SP_HL2EP2
  !insertmacro AddBaseContentSection ${SDK2013SP_HL2EP2_SHORT_NAME} "2007"
SectionGroupEnd
!endif

Function .onInit

  !ifndef UNINSTALLER
    
    # Read game paths.
    ReadINIStr $CSTRIKE_DIR "${STEAMAPPSINI}" steamapps cstrike
    ReadINIStr $HL1_DIR "${STEAMAPPSINI}" steamapps hl1
    ReadINIStr $HL2_DIR "${STEAMAPPSINI}" steamapps hl2
    !ifdef SOURCE2007
      ReadINIStr $PORTAL_DIR "${STEAMAPPSINI}" steamapps portal
    !endif
  
    ReadRegDWORD $R0 HKCU Software\Valve\Steam\Apps\220 Installed
    
    !ifdef SOURCE2007
      ${If} $R0 == 0
        # Check if Source SDK Base 2013 Singleplayer is installed.
        ReadRegDWORD $R1 HKCU Software\Valve\Steam\Apps\243730 Installed
        ${If} $R1 == 0
          !insertmacro DisableSection ${SecEP2Teaser}
        ${Else}
          !insertmacro EnableSection ${SecEP2Teaser}
        ${EndIf}
      ${Else}
        !insertmacro EnableSection ${SecEP2Teaser}
      ${EndIf}
    !endif
    
    ${If} $R0 == 0
      # HL2 games unavailable
    
      # HL2
      !insertmacro DisableSectionGroup ${SecGroupHL2}
      !insertmacro DisableSectionGroup ${SecGroupHL2Lang}
      !insertmacro Disable8LanguageSections ${HL2_SHORT_NAME}
      # HL2EP1
      !insertmacro DisableSectionGroup ${SecGroupHL2EP1}
      !insertmacro DisableSectionGroup ${SecGroupHL2EP1Lang}
      !insertmacro Disable8LanguageSections ${HL2EP1_SHORT_NAME}
      !ifdef SOURCE2007
        # HL2EP2
        !insertmacro DisableSectionGroup ${SecGroupHL2EP2}
        !insertmacro DisableSectionGroup ${SecGroupHL2EP2Lang}
        !insertmacro DisableBaseContentSection ${HL2EP2_SHORT_NAME}
        !insertmacro Disable4LanguageSections ${HL2EP2_SHORT_NAME}
      !endif
      # Lost Coast
      !insertmacro DisableSectionGroup ${SecGroupLostCoast}
      !insertmacro DisableSectionGroup ${SecGroupLostCoastLang}
      !insertmacro DisableBaseContentSection ${LOSTCOAST_SHORT_NAME}
      !insertmacro DisableMapsContentSection ${LOSTCOAST_SHORT_NAME}
      !insertmacro Disable8LanguageSections ${LOSTCOAST_SHORT_NAME}
    ${Else}
      # HL2 games available
      !insertmacro DisableUnavailableLanguagesIn8LanguageSections ${HL2_SHORT_NAME} "$HL2_DIR\hl2" "hl2_sound_vo"
      !insertmacro DisableUnavailableLanguagesIn8LanguageSections ${HL2EP1_SHORT_NAME} "$HL2_DIR\episodic" "ep1_sound_vo"
      !ifdef SOURCE2007
        !insertmacro DisableUnavailableLanguagesIn4LanguageSections ${HL2EP2_SHORT_NAME} "$HL2_DIR\ep2" "ep2_sound_vo"
      !endif
      !insertmacro DisableUnavailableLanguagesIn8LanguageSections ${LOSTCOAST_SHORT_NAME} "$HL2_DIR\lostcoast" "lostcoast_sound_vo"
    ${EndIf}
    ReadRegDWORD $R0 HKCU Software\Valve\Steam\Apps\240 Installed
    ${If} $R0 == 0
      # CSS unavailable
      !insertmacro DisableSectionGroup ${SecGroupCSS}
      !insertmacro DisableSectionGroup ${SecGroupCSSLang}
      !insertmacro DisableBaseContentSection ${CSS_SHORT_NAME}
      !insertmacro DisableMapsContentSection ${CSS_SHORT_NAME}
      !insertmacro Disable8LanguageSections ${CSS_SHORT_NAME}
      !insertmacro DisableLanguageSection ${CSS_SHORT_NAME} "Japanese"
      !insertmacro DisableLanguageSection ${CSS_SHORT_NAME} "Thai"
    ${Else}
      # CSS available
      !insertmacro DisableUnavailableLanguagesIn8LanguageSections ${CSS_SHORT_NAME} "$CSTRIKE_DIR\cstrike" "cstrike"
      !insertmacro DisableUnavailableLanguageInLanguageSection ${CSS_SHORT_NAME} "Japanese" "$CSTRIKE_DIR\cstrike\cstrike_japanese_dir.vpk"
      !insertmacro DisableUnavailableLanguageInLanguageSection ${CSS_SHORT_NAME} "Thai" "$CSTRIKE_DIR\cstrike\cstrike_thai_dir.vpk"
    ${EndIf}
    ReadRegDWORD $R0 HKCU Software\Valve\Steam\Apps\280 Installed
    ${If} $R0 == 0
      # HL1 unavailable
      !insertmacro DisableSectionGroup ${SecGroupHL1}
      !insertmacro DisableSectionGroup ${SecGroupHL1Lang}
      !insertmacro DisableBaseContentSection ${HL1_SHORT_NAME}
      !insertmacro DisableContentSection ${HL1_SHORT_NAME} "HD"
      !insertmacro DisableMapsContentSection ${HL1_SHORT_NAME}
      !insertmacro Disable8LanguageSections ${HL1_SHORT_NAME}
    ${Else}
      # HL1 available
      !insertmacro DisableUnavailableLanguagesIn8LanguageSections ${HL1_SHORT_NAME} "$HL1_DIR\hl1" "hl1_sound_vo"
    ${EndIf}
    ReadRegDWORD $R0 HKCU Software\Valve\Steam\Apps\300 Installed
    ${If} $R0 == 0
      # DOD unavailable
      !insertmacro DisableSectionGroup ${SecGroupDOD}
      !insertmacro DisableBaseContentSection ${DOD_SHORT_NAME}
      !insertmacro DisableMapsContentSection ${DOD_SHORT_NAME}
    ${EndIf}
    ReadRegDWORD $R0 HKCU Software\Valve\Steam\Apps\320 Installed
    ${If} $R0 == 0
      # HL2MP unavailable
      !insertmacro DisableSectionGroup ${SecGroupHL2MP}
      !insertmacro DisableBaseContentSection ${HL2MP_SHORT_NAME}
    ${EndIf}
    ReadRegDWORD $R0 HKCU Software\Valve\Steam\Apps\360 Installed
    ${If} $R0 == 0
      # HL1MP unavailable
      !insertmacro DisableSectionGroup ${SecGroupHL1MP}
      !insertmacro DisableBaseContentSection ${HL1MP_SHORT_NAME}
      !insertmacro DisableContentSection ${HL1MP_SHORT_NAME} "HL1"
      !insertmacro DisableMapsContentSection ${HL1MP_SHORT_NAME}
    ${EndIf}
    !ifdef SOURCE2007
      ReadRegDWORD $R0 HKCU Software\Valve\Steam\Apps\400 Installed
      ${If} $R0 == 0
        # Portal unavailable
        !insertmacro DisableSectionGroup ${SecGroupPortal}
        !insertmacro DisableSectionGroup ${SecGroupPortalLang}
        !insertmacro DisableBaseContentSection ${PORTAL_SHORT_NAME}
        !insertmacro DisableMapsContentSection ${PORTAL_SHORT_NAME}
        !insertmacro Disable4LanguageSections ${PORTAL_SHORT_NAME}
      ${Else}
        # Portal available
        !insertmacro DisableUnavailableLanguagesIn4LanguageSections ${PORTAL_SHORT_NAME} "$PORTAL_DIR\portal" "portal_sound_vo"
      ${EndIf}
      ReadRegDWORD $R0 HKCU Software\Valve\Steam\Apps\243730 Installed
      ${If} $R0 == 0
        # SDK2013SP - HL2:EP2
        !insertmacro DisableSectionGroup ${SecGroupSDK2013SP_HL2EP2}
        !insertmacro DisableBaseContentSection ${SDK2013SP_HL2EP2_SHORT_NAME}
      ${EndIf}
    !endif
    ReadRegDWORD $R0 HKCU Software\Valve\Steam\Apps\243750 Installed
    ${If} $R0 == 0
      # SDK2013MP - HL2:MP
      !insertmacro DisableSectionGroup ${SecGroupSDK2013MP_HL2MP}
      !insertmacro DisableBaseContentSection ${SDK2013MP_HL2MP_SHORT_NAME}
    ${EndIf}
  !endif

FunctionEnd

!ifdef SOURCE2007
  !ifndef UNINSTALLER
    LangString DESC_EP2Teaser ${LANG_ENGLISH} "Install HL2:EP2 media teaser.$\r$\n$\r$\nRequires either Half-Life 2 or Source SDK Base 2013 Singleplayer installed."
  !endif
!endif

# CSS
!insertmacro AddSectionGroupString ${LANG_ENGLISH} ${CSS_SHORT_NAME} "${CSS_FULL_NAME} content"
!insertmacro AddSectionGroupString ${LANG_ENGLISH} ${CSS_SHORT_NAME}_LANG "${CSS_FULL_NAME} Localisation content"
!insertmacro AddBaseContentString ${LANG_ENGLISH} ${CSS_SHORT_NAME} "${CSS_FULL_NAME}"
!insertmacro AddMapsContentString ${LANG_ENGLISH} ${CSS_SHORT_NAME} "${CSS_FULL_NAME}"
!insertmacro Add8LanguageStrings ${LANG_ENGLISH} ${CSS_SHORT_NAME} "${CSS_FULL_NAME}"
!insertmacro AddLanguageString ${LANG_ENGLISH} ${CSS_SHORT_NAME} "${CSS_FULL_NAME}" "Japanese" "Japanese"
!insertmacro AddLanguageString ${LANG_ENGLISH} ${CSS_SHORT_NAME} "${CSS_FULL_NAME}" "Thai" "Thai"

# DOD
!insertmacro AddSectionGroupString ${LANG_ENGLISH} ${DOD_SHORT_NAME} "${DOD_FULL_NAME} content"
!insertmacro AddBaseContentString ${LANG_ENGLISH} ${DOD_SHORT_NAME} "${DOD_FULL_NAME}"
!insertmacro AddMapsContentString ${LANG_ENGLISH} ${DOD_SHORT_NAME} "${DOD_FULL_NAME}"

# HL1
!insertmacro AddSectionGroupString ${LANG_ENGLISH} ${HL1_SHORT_NAME} "${HL1_FULL_NAME} content"
!insertmacro AddSectionGroupString ${LANG_ENGLISH} ${HL1_SHORT_NAME}_LANG "${HL1_FULL_NAME} Localisation content"
!insertmacro AddBaseContentString ${LANG_ENGLISH} ${HL1_SHORT_NAME} "${HL1_FULL_NAME}"
!insertmacro AddContentString  ${LANG_ENGLISH} ${HL1_SHORT_NAME} "HD" "${HL1_FULL_NAME} HD"
!insertmacro AddMapsContentString ${LANG_ENGLISH} ${HL1_SHORT_NAME} "${HL1_FULL_NAME}"
!insertmacro Add8LanguageStrings ${LANG_ENGLISH} ${HL1_SHORT_NAME} "${HL1_FULL_NAME}"

# HL1MP
!insertmacro AddSectionGroupString ${LANG_ENGLISH} ${HL1MP_SHORT_NAME} "${HL1MP_FULL_NAME} content"
!insertmacro AddBaseContentString ${LANG_ENGLISH} ${HL1MP_SHORT_NAME} "${HL1MP_FULL_NAME}"
!insertmacro AddContentString  ${LANG_ENGLISH} ${HL1MP_SHORT_NAME} "HL1" "${HL1MP_FULL_NAME} HL1"
!insertmacro AddMapsContentString ${LANG_ENGLISH} ${HL1MP_SHORT_NAME} "${HL1MP_FULL_NAME}"

# HL2
!insertmacro AddSectionGroupString ${LANG_ENGLISH} ${HL2_SHORT_NAME} "${HL2_FULL_NAME} content"
!insertmacro AddSectionGroupString ${LANG_ENGLISH} ${HL2_SHORT_NAME}_LANG "${HL2_FULL_NAME} Localisation content"
!insertmacro Add8LanguageStrings ${LANG_ENGLISH} ${HL2_SHORT_NAME} "${HL2_FULL_NAME}"

# HL2EP1
!insertmacro AddSectionGroupString ${LANG_ENGLISH} ${HL2EP1_SHORT_NAME} "${HL2EP1_FULL_NAME} content"
!insertmacro AddSectionGroupString ${LANG_ENGLISH} ${HL2EP1_SHORT_NAME}_LANG "${HL2EP1_FULL_NAME} Localisation content"
!insertmacro Add8LanguageStrings ${LANG_ENGLISH} ${HL2EP1_SHORT_NAME} "${HL2EP1_FULL_NAME}"

!ifdef SOURCE2007
  # HL2EP2
  !insertmacro AddSectionGroupString ${LANG_ENGLISH} ${HL2EP2_SHORT_NAME} "${HL2EP2_FULL_NAME} content"
  !insertmacro AddSectionGroupString ${LANG_ENGLISH} ${HL2EP2_SHORT_NAME}_LANG "${HL2EP2_FULL_NAME} Localisation content"
  !insertmacro AddBaseContentString ${LANG_ENGLISH} ${HL2EP2_SHORT_NAME} "${HL2EP2_FULL_NAME}"
  !insertmacro Add4LanguageStrings ${LANG_ENGLISH} ${HL2EP2_SHORT_NAME} "${HL2EP2_FULL_NAME}"
!endif

# HL2MP
!insertmacro AddSectionGroupString ${LANG_ENGLISH} ${HL2MP_SHORT_NAME} "${HL2MP_FULL_NAME} content"
!insertmacro AddBaseContentString ${LANG_ENGLISH} ${HL2MP_SHORT_NAME} "${HL2MP_FULL_NAME}"

# LostCoast
!insertmacro AddSectionGroupString ${LANG_ENGLISH} ${LOSTCOAST_SHORT_NAME} "${LOSTCOAST_FULL_NAME} content"
!insertmacro AddSectionGroupString ${LANG_ENGLISH} ${LOSTCOAST_SHORT_NAME}_LANG "${LOSTCOAST_FULL_NAME} Localisation content"
!insertmacro AddBaseContentString ${LANG_ENGLISH} ${LOSTCOAST_SHORT_NAME} "${LOSTCOAST_FULL_NAME}"
!insertmacro AddMapsContentString ${LANG_ENGLISH} ${LOSTCOAST_SHORT_NAME} "${LOSTCOAST_FULL_NAME}"
!insertmacro Add8LanguageStrings ${LANG_ENGLISH} ${LOSTCOAST_SHORT_NAME} "${LOSTCOAST_FULL_NAME}"

!ifdef SOURCE2007
  # Portal
  !insertmacro AddSectionGroupString ${LANG_ENGLISH} ${PORTAL_SHORT_NAME} "${PORTAL_FULL_NAME} content"
  !insertmacro AddSectionGroupString ${LANG_ENGLISH} ${PORTAL_SHORT_NAME}_LANG "${PORTAL_FULL_NAME} Localisation content"
  !insertmacro AddBaseContentString ${LANG_ENGLISH} ${PORTAL_SHORT_NAME} "${PORTAL_FULL_NAME}"
  !insertmacro AddMapsContentString ${LANG_ENGLISH} ${PORTAL_SHORT_NAME} "${PORTAL_FULL_NAME}"
  !insertmacro Add4LanguageStrings ${LANG_ENGLISH} ${PORTAL_SHORT_NAME} "${PORTAL_FULL_NAME}"
!endif

# SDK2013MP - HL2MP
!insertmacro AddSectionGroupString ${LANG_ENGLISH} ${SDK2013MP_HL2MP_SHORT_NAME} "${SDK2013MP_HL2MP_FULL_NAME} content"
!insertmacro AddBaseContentString ${LANG_ENGLISH} ${SDK2013MP_HL2MP_SHORT_NAME} "${SDK2013MP_HL2MP_FULL_NAME}"

!ifdef SOURCE2007
  # SDK2013SP - HL2EP2
  !insertmacro AddSectionGroupString ${LANG_ENGLISH} ${SDK2013SP_HL2EP2_SHORT_NAME} "${SDK2013SP_HL2EP2_FULL_NAME} content"
  !insertmacro AddBaseContentString ${LANG_ENGLISH} ${SDK2013SP_HL2EP2_SHORT_NAME} "${SDK2013SP_HL2EP2_FULL_NAME}"
!endif

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN

  !ifdef SOURCE2007
    !ifndef UNINSTALLER
      !insertmacro MUI_DESCRIPTION_TEXT ${SecEP2Teaser} $(DESC_EP2Teaser)
    !endif
  !endif

  # CSS
  !insertmacro AddSectionGroupDescription ${SecGroupCSS} ${CSS_SHORT_NAME}
  !insertmacro AddSectionGroupDescription ${SecGroupCSSLang} ${CSS_SHORT_NAME}_LANG
  !insertmacro AddBaseContentDescription ${CSS_SHORT_NAME}
  !insertmacro AddMapsContentDescription ${CSS_SHORT_NAME}
  !insertmacro Add8LanguageDescriptions ${CSS_SHORT_NAME}
  !insertmacro AddLanguageDescription ${CSS_SHORT_NAME} "Japanese"
  !insertmacro AddLanguageDescription ${CSS_SHORT_NAME} "Thai"

  # DOD
  !insertmacro AddSectionGroupDescription ${SecGroupDOD} ${DOD_SHORT_NAME}
  !insertmacro AddBaseContentDescription ${DOD_SHORT_NAME}
  !insertmacro AddMapsContentDescription ${DOD_SHORT_NAME}

  # HL1
  !insertmacro AddSectionGroupDescription ${SecGroupHL1} ${HL1_SHORT_NAME}
  !insertmacro AddSectionGroupDescription ${SecGroupHL1Lang} ${HL1_SHORT_NAME}_LANG
  !insertmacro AddBaseContentDescription ${HL1_SHORT_NAME}
  !insertmacro AddContentDescription ${HL1_SHORT_NAME} "HD"
  !insertmacro AddMapsContentDescription ${HL1_SHORT_NAME}
  !insertmacro Add8LanguageDescriptions ${HL1_SHORT_NAME}

  # HL1MP
  !insertmacro AddSectionGroupDescription ${SecGroupHL1MP} ${HL1MP_SHORT_NAME}
  !insertmacro AddBaseContentDescription ${HL1MP_SHORT_NAME}
  !insertmacro AddContentDescription ${HL1MP_SHORT_NAME} "HL1"
  !insertmacro AddMapsContentDescription ${HL1MP_SHORT_NAME}

  # HL2
  !insertmacro AddSectionGroupDescription ${SecGroupHL2} ${HL2_SHORT_NAME}
  !insertmacro AddSectionGroupDescription ${SecGroupHL2Lang} ${HL2_SHORT_NAME}_LANG
  !insertmacro Add8LanguageDescriptions ${HL2_SHORT_NAME}

  # HL2EP1
  !insertmacro AddSectionGroupDescription ${SecGroupHL2EP1} ${HL2EP1_SHORT_NAME}
  !insertmacro AddSectionGroupDescription ${SecGroupHL2EP1Lang} ${HL2EP1_SHORT_NAME}_LANG
  !insertmacro Add8LanguageDescriptions ${HL2EP1_SHORT_NAME}

  !ifdef SOURCE2007
    # HL2EP2
    !insertmacro AddSectionGroupDescription ${SecGroupHL2EP2} ${HL2EP2_SHORT_NAME}
    !insertmacro AddSectionGroupDescription ${SecGroupHL2EP2Lang} ${HL2EP2_SHORT_NAME}_LANG
    !insertmacro AddBaseContentDescription ${HL2EP2_SHORT_NAME}
    !insertmacro Add4LanguageDescriptions ${HL2EP2_SHORT_NAME}
  !endif

  # HL2MP
  !insertmacro AddSectionGroupDescription ${SecGroupHL2MP} ${HL2MP_SHORT_NAME}
  !insertmacro AddBaseContentDescription ${HL2MP_SHORT_NAME}

  # LostCoast
  !insertmacro AddSectionGroupDescription ${SecGroupLostCoast} ${LOSTCOAST_SHORT_NAME}
  !insertmacro AddSectionGroupDescription ${SecGroupLostCoastLang} ${LOSTCOAST_SHORT_NAME}_LANG
  !insertmacro AddBaseContentDescription ${LOSTCOAST_SHORT_NAME}
  !insertmacro AddMapsContentDescription ${LOSTCOAST_SHORT_NAME}
  !insertmacro Add8LanguageDescriptions ${LOSTCOAST_SHORT_NAME}

  !ifdef SOURCE2007
    # Portal
    !insertmacro AddSectionGroupDescription ${SecGroupPortal} ${PORTAL_SHORT_NAME}
    !insertmacro AddSectionGroupDescription ${SecGroupPortalLang} ${PORTAL_SHORT_NAME}_LANG
    !insertmacro AddBaseContentDescription ${PORTAL_SHORT_NAME}
    !insertmacro AddMapsContentDescription ${PORTAL_SHORT_NAME}
    !insertmacro Add4LanguageDescriptions ${PORTAL_SHORT_NAME}
  !endif

  # SDK2013MP - HL2MP
  !insertmacro AddSectionGroupDescription ${SecGroupSDK2013MP_HL2MP} ${SDK2013MP_HL2MP_SHORT_NAME}
  !insertmacro AddBaseContentDescription ${SDK2013MP_HL2MP_SHORT_NAME}

  !ifdef SOURCE2007
    # SDK2013SP - HL2EP2
    !insertmacro AddSectionGroupDescription ${SecGroupSDK2013SP_HL2EP2} ${SDK2013SP_HL2EP2_SHORT_NAME}
    !insertmacro AddBaseContentDescription ${SDK2013SP_HL2EP2_SHORT_NAME}
  !endif

!insertmacro MUI_FUNCTION_DESCRIPTION_END
