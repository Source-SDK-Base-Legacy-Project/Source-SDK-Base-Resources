BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions
  Mock Import-PathsINI {}
  Mock Import-SteamAppsINI {}
  Mock Update-SteamAppsINI {}
  
  function Invoke-UpdateSteamApps {
    . "$PSScriptRoot\..\scripts\private\update_steamapps.ps1"
  }
}

Describe 'update_steamapps' {
  BeforeEach {
    Clear-GlobalTestVariables
  }

  It 'calls Update-SteamAppsINI exactly 1 time' {
    Invoke-UpdateSteamApps
    Should -Invoke -CommandName Update-SteamAppsINI -Exactly -Times 1
  }
}