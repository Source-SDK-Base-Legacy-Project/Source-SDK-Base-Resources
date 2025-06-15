BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions
  Mock Import-PathsINI {}
  Mock Import-SteamAppsINI {}
  Mock Update-SteamAppsINI {}
  Mock Import-SharedFolder {}
  Mock Initialize-SharedFolder {}
  Mock Assert-SourceSDKBase2006IsInstalled {}
  Mock Assert-SourceSDKBase2007IsInstalled {}
  
  function Invoke-InstallStart {
    param([string]$Source)
    . "$PSScriptRoot\..\scripts\private\install_start.ps1" -Source $Source
  }
}

Describe 'install_start' {
  BeforeEach {
    Clear-GlobalTestVariables
    
    $global:SHARED_FOLDER = "TestDrive:\shared_folder"
    New-Item -ItemType Directory -Path $global:SHARED_FOLDER -Force
  }

  It 'calls Update-SteamAppsINI exactly 1 time' {
    Invoke-InstallStart -Source "both"
    Should -Invoke -CommandName Update-SteamAppsINI -Exactly -Times 1
  }
  
  It 'calls Import-SteamAppsINI exactly 1 time' {
    Invoke-InstallStart -Source "both"
    Should -Invoke -CommandName Import-SteamAppsINI -Exactly -Times 1
  }

  It 'calls Import-SharedFolder exactly 1 time' {
    Invoke-InstallStart -Source "both"
    Should -Invoke -CommandName Import-SharedFolder -Times 1
  }
  Context 'when source 2006 is specified' {
    It 'calls Assert-SourceSDKBase2006IsInstalled exactly 1 time' {
      Invoke-InstallStart -Source "2006"
      Should -Invoke -CommandName Assert-SourceSDKBase2006IsInstalled -Times 1
      Should -Invoke -CommandName Assert-SourceSDKBase2007IsInstalled -Times 0
    }
  }
  Context 'when source 2007 is specified' {
    It 'calls Assert-SourceSDKBase2007IsInstalled exactly 1 time' {
      Invoke-InstallStart -Source "2007"
      Should -Invoke -CommandName Assert-SourceSDKBase2006IsInstalled -Times 0
      Should -Invoke -CommandName Assert-SourceSDKBase2007IsInstalled -Times 1
    }
  }
  Context 'when both is specified' {
    It 'calls Assert-SourceSDKBase2006IsInstalled and Assert-SourceSDKBase2007IsInstalled  exactly 1 time' {
      Invoke-InstallStart -Source "both"
      Should -Invoke -CommandName Assert-SourceSDKBase2006IsInstalled -Times 1
      Should -Invoke -CommandName Assert-SourceSDKBase2007IsInstalled -Times 1
    }
  }
}
