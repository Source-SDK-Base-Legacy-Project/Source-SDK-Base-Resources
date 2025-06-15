BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions
  function Get-TestSteamVPKsVDF {
    Get-Content "$PSScriptRoot\data\Write-SteamVPKs\steam_vpks.vdf" -Raw
  }
}

Describe 'Write-SteamVPKs' {
  BeforeEach {
    Clear-GlobalTestVariables
  }
  
  It 'Given a steam_vpks.vdf, it writes normally' {
    $outputPath = "TestDrive:\steam_vpks.vdf"
    
    $vpks = @(
      "vpks/depot_206",
      "vpks/depot_207",
      "vpks/depot_208",
      "vpks/depot_212",
      "vpks/depot_213",
      "vpks/depot_215",
      "vpks/depot_381"
    )
    
    Write-SteamVPKs $outputPath $vpks
    (Get-Content 'TestDrive:\steam_vpks.vdf' -Raw) | Should -Be (Get-TestSteamVPKsVDF)
  }
  
  It 'Given a steam_vpks.vdf containing *_dir.vpk, it removes all *_dir.vpk occurences' {
    $outputPath = "TestDrive:\steam_vpks.vdf"
    
    $vpks = @(
      "vpks/depot_206_dir.vpk",
      "vpks/depot_207_dir.vpk",
      "vpks/depot_208_dir.vpk",
      "vpks/depot_212_dir.vpk",
      "vpks/depot_213_dir.vpk",
      "vpks/depot_215_dir.vpk",
      "vpks/depot_381_dir.vpk"
    )
    
    Write-SteamVPKs $outputPath $vpks
    (Get-Content 'TestDrive:\steam_vpks.vdf' -Raw) | Should -Be (Get-TestSteamVPKsVDF)
  }
}
