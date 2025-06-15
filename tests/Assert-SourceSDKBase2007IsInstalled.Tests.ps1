BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions
}

Describe 'Assert-SourceSDKBase2007IsInstalled' {
  
  BeforeEach {
    Clear-GlobalTestVariables

    $global:SDKBASE2007 = "TestDrive:\Source SDK Base 2007"
    New-Item -ItemType Directory -Path $global:SDKBASE2007 -Force
  }
  
  Context 'when Source SDK Base 2007 is not installed' {
    BeforeEach {
      Mock Test-SteamAppInstalled { if ($SteamAppID -eq 218) { $false } else { $true } }
    }
    It 'throws an exception' {
      { Assert-SourceSDKBase2007IsInstalled } | Should -Throw -ExpectedMessage "Source SDK Base 2007 not installed!"
    }
  }
  
  Context 'when Source SDK Base 2007 path does not exist' {
    BeforeEach {
      Mock Test-SteamAppInstalled { if ($SteamAppID -eq 218) { $true } else { $true } }
    }
    It 'throws an exception' {
      Remove-Item -Path $global:SDKBASE2007 -Recurse
      { Assert-SourceSDKBase2007IsInstalled } | Should -Throw -ExpectedMessage "Source SDK Base 2007 path not found!"
    }
  }
}