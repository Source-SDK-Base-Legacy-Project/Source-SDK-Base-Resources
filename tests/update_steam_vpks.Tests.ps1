BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions
  Mock Import-PathsINI {}
  Mock Import-SteamAppsINI {}
  Mock Import-SharedFolder {}
  Mock Initialize-SharedFolder {}
  Mock Assert-SourceSDKBase2006IsInstalled {}
  Mock Assert-SourceSDKBase2007IsInstalled {}
  Mock Assert-SharedFolderExists {}
  Mock Write-SteamVPKs {}

  function Invoke-UpdateSteamVPKs {
    param([string]$Source)
    . "$PSScriptRoot\..\scripts\private\update_steam_vpks.ps1" -Source $Source
  }
}

Describe 'update_steam_vpks' {
  BeforeEach {
    Clear-GlobalTestVariables
  }
  
  Context 'when source 2006 is specified' {
    It 'calls Write-SteamVPKs exactly 1 time' {
      Invoke-UpdateSteamVPKs -Source "2006"
      Should -Invoke -CommandName Write-SteamVPKs -Times 1
    }
  }
  Context 'when source 2007 is specified' {
    It 'calls Write-SteamVPKs exactly 1 time' {
      Invoke-UpdateSteamVPKs -Source "2007"
      Should -Invoke -CommandName Write-SteamVPKs -Times 1
    }
  }
  Context 'when both is specified' {
    It 'calls Write-SteamVPKs exactly 2 times' {
      Invoke-UpdateSteamVPKs -Source "both"
      Should -Invoke -CommandName Write-SteamVPKs -Times 2
    }
  }
}
