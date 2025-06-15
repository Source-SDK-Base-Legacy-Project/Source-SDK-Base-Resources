BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions
}

Describe 'Assert-SourceSDKBase2006IsInstalled' {
  
  BeforeEach {
    Clear-GlobalTestVariables

    $global:SDKBASE2006 = "TestDrive:\Source SDK Base"
    New-Item -ItemType Directory -Path $global:SDKBASE2006 -Force
  }
  
  Context 'when Source SDK Base 2006 is not installed' {
    BeforeEach {
      Mock Test-SteamAppInstalled { if ($SteamAppID -eq 215) { $false } else { $true } }
    }
    It 'throws an exception' {
      { Assert-SourceSDKBase2006IsInstalled } | Should -Throw -ExpectedMessage "Source SDK Base 2006 not installed!"
    }
  }
  
  Context 'when Source SDK Base 2006 path does not exist' {
    BeforeEach {
      Mock Test-SteamAppInstalled { if ($SteamAppID -eq 215) { $true } else { $true } }
    }
    It 'throws an exception' {
      Remove-Item -Path $global:SDKBASE2006 -Recurse
      { Assert-SourceSDKBase2006IsInstalled } | Should -Throw -ExpectedMessage "Source SDK Base 2006 path not found!"
    }
  }
}