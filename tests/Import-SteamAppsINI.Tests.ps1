BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions

  function Assert-GlobalTestVariablesAreNull {
    $global:CSTRIKE | Should -Be $null
    $global:DOD | Should -Be $null
    $global:HL1 | Should -Be $null
    $global:HL1MP | Should -Be $null
    $global:HL2 | Should -Be $null
    $global:HL2MP | Should -Be $null
    $global:PORTAL | Should -Be $null
    $global:SDKBASE2006 | Should -Be $null
    $global:SDKBASE2007 | Should -Be $null
    $global:SDKBASE2013MP | Should -Be $null
    $global:SDKBASE2013SP | Should -Be $null
  }
  
  function Assert-AllEmptyExcept {
    param(
      [Parameter(Mandatory=$false)]
      [switch]$cstrike,
      [Parameter(Mandatory=$false)]
      [switch]$dod,
      [Parameter(Mandatory=$false)]
      [switch]$hl1,
      [Parameter(Mandatory=$false)]
      [switch]$hl1mp,
      [Parameter(Mandatory=$false)]
      [switch]$hl2,
      [Parameter(Mandatory=$false)]
      [switch]$hl2mp,
      [Parameter(Mandatory=$false)]
      [switch]$portal,
      [Parameter(Mandatory=$false)]
      [switch]$sdkbase2006,
      [Parameter(Mandatory=$false)]
      [switch]$sdkbase2007,
      [Parameter(Mandatory=$false)]
      [switch]$sdkbase2013mp,
      [Parameter(Mandatory=$false)]
      [switch]$sdkbase2013sp
    )
    if (-not ($cstrike.IsPresent)) { $global:CSTRIKE | Should -Be "" }
    if (-not ($dod.IsPresent)) { $global:DOD | Should -Be "" }
    if (-not ($hl1.IsPresent)) { $global:HL1 | Should -Be "" }
    if (-not ($hl1mp.IsPresent)) { $global:HL1MP | Should -Be "" }
    if (-not ($hl2.IsPresent)) { $global:HL2 | Should -Be "" }
    if (-not ($hl2mp.IsPresent)) { $global:HL2MP | Should -Be "" }
    if (-not ($portal.IsPresent)) { $global:PORTAL | Should -Be "" }
    if (-not ($sdkbase2006.IsPresent)) { $global:SDKBASE2006 | Should -Be "" }
    if (-not ($sdkbase2007.IsPresent)) { $global:SDKBASE2007 | Should -Be "" }
    if (-not ($sdkbase2013mp.IsPresent)) { $global:SDKBASE2013MP | Should -Be "" }
    if (-not ($sdkbase2013sp.IsPresent)) { $global:SDKBASE2013SP | Should -Be "" }
  }
}

Describe 'Import-SteamAppsINI' {
  BeforeEach {
    Clear-GlobalTestVariables
    Assert-GlobalTestVariablesAreNull
  }

  It 'Given cstrike_only.ini, only CSTRIKE should be non-empty' {
    $global:STEAMAPPSINI = "$PSScriptRoot\data\Import-SteamAppsINI\cstrike_only.ini" 
    Import-SteamAppsINI

    $global:CSTRIKE | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Source"
    Assert-AllEmptyExcept -cstrike
  }
  
  It 'Given dod_only.ini, only DOD should be non-empty' {
    $global:STEAMAPPSINI = "$PSScriptRoot\data\Import-SteamAppsINI\dod_only.ini" 
    Import-SteamAppsINI
    
    $global:DOD | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Day of Defeat Source"
    Assert-AllEmptyExcept -dod
  }
  
  It 'Given hl1_only.ini, only HL1 should be non-empty' {
    $global:STEAMAPPSINI = "$PSScriptRoot\data\Import-SteamAppsINI\hl1_only.ini" 
    Import-SteamAppsINI
    
    $global:HL1 | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Half-Life 2"
    Assert-AllEmptyExcept -hl1
  }
  
  It 'Given hl1mp_only.ini, only HL1MP should be non-empty' {
    $global:STEAMAPPSINI = "$PSScriptRoot\data\Import-SteamAppsINI\hl1mp_only.ini" 
    Import-SteamAppsINI
    
    $global:HL1MP | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Half-Life 1 Source Deathmatch"
    Assert-AllEmptyExcept -hl1mp
  }

  It 'Given hl2_only.ini, only HL2 should be non-empty' {
    $global:STEAMAPPSINI = "$PSScriptRoot\data\Import-SteamAppsINI\hl2_only.ini" 
    Import-SteamAppsINI
    
    $global:HL2 | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Half-Life 2"
    Assert-AllEmptyExcept -hl2
  }
  
  It 'Given hl2mp_only.ini, only HL2MP should be non-empty' {
    $global:STEAMAPPSINI = "$PSScriptRoot\data\Import-SteamAppsINI\hl2mp_only.ini" 
    Import-SteamAppsINI
    
    $global:HL2MP | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Half-Life 2 Deathmatch"
    Assert-AllEmptyExcept -hl2mp
  }

  It 'Given portal_only.ini, only PORTAL should be non-empty' {
    $global:STEAMAPPSINI = "$PSScriptRoot\data\Import-SteamAppsINI\portal_only.ini" 
    Import-SteamAppsINI
    
    $global:PORTAL | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Portal"
    Assert-AllEmptyExcept -portal
  }

  It 'Given sdkbase2006_only.ini, only SDKBASE2006 should be non-empty' {
    $global:STEAMAPPSINI = "$PSScriptRoot\data\Import-SteamAppsINI\sdkbase2006_only.ini" 
    Import-SteamAppsINI
    
    $global:SDKBASE2006 | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Source SDK Base"
    Assert-AllEmptyExcept -sdkbase2006
  }

  It 'Given sdkbase2007_only.ini, only SDKBASE2007 should be non-empty' {
    $global:STEAMAPPSINI = "$PSScriptRoot\data\Import-SteamAppsINI\sdkbase2007_only.ini" 
    Import-SteamAppsINI
    
    $global:SDKBASE2007 | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Source SDK Base 2007"
    Assert-AllEmptyExcept -sdkbase2007
  }

  It 'Given sdkbase2013mp_only.ini, only SDKBASE2013MP should be non-empty' {
    $global:STEAMAPPSINI = "$PSScriptRoot\data\Import-SteamAppsINI\sdkbase2013mp_only.ini" 
    Import-SteamAppsINI
    
    $global:SDKBASE2013MP | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Source SDK Base 2013 Multiplayer"
    Assert-AllEmptyExcept -sdkbase2013mp
  }

  It 'Given sdkbase2013sp_only.ini, only SDKBASE2013SP should be non-empty' {
    $global:STEAMAPPSINI = "$PSScriptRoot\data\Import-SteamAppsINI\sdkbase2013sp_only.ini" 
    Import-SteamAppsINI
    
    $global:SDKBASE2013SP | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Source SDK Base 2013 Singleplayer"
    Assert-AllEmptyExcept -sdkbase2013sp
  }
  
  It 'Given all.ini, none should be empty' {
    $global:STEAMAPPSINI = "$PSScriptRoot\data\Import-SteamAppsINI\all.ini" 
    Import-SteamAppsINI
    
    $global:CSTRIKE | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Source"
    $global:DOD | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Day of Defeat Source"
    $global:HL1 | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Half-Life 2"
    $global:HL1MP | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Half-Life 1 Source Deathmatch"
    $global:HL2 | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Half-Life 2"
    $global:HL2MP | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Half-Life 2 Deathmatch"
    $global:PORTAL | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Portal"
    $global:SDKBASE2006 | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Source SDK Base"
    $global:SDKBASE2007 | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Source SDK Base 2007"
    $global:SDKBASE2013MP | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Source SDK Base 2013 Multiplayer"
    $global:SDKBASE2013SP | Should -Be "C:\Program Files (x86)\Steam\steamapps\common\Source SDK Base 2013 Singleplayer"
  }
}
