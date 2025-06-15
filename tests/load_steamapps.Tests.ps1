BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions
  Mock Import-PathsINI {}
  Mock Import-SteamAppsINI {}
  
  function Invoke-LoadSteamApps {
    . "$PSScriptRoot\..\scripts\private\load_steamapps.ps1"
  }
}

Describe 'load_steamapps' {
  BeforeEach {
    Clear-GlobalTestVariables
  }
  
  It 'calls Import-SteamAppsINI exactly 1 time' {
    Invoke-LoadSteamApps
    Should -Invoke -CommandName Import-SteamAppsINI -Exactly -Times 1
  }
}