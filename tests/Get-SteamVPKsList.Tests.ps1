BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions

  $source2006Default = Get-Content "$PSScriptRoot\data\Get-SteamVPKsList\source2006_default_vpks.txt"
  $source2006Mid = Get-Content "$PSScriptRoot\data\Get-SteamVPKsList\source2006_mid.txt"
  $source2006Patches = Get-Content "$PSScriptRoot\data\Get-SteamVPKsList\source2006_patch_vpks.txt"

  $source2007Default = Get-Content "$PSScriptRoot\data\Get-SteamVPKsList\source2007_default_vpks.txt"
  $source2007Mid = Get-Content "$PSScriptRoot\data\Get-SteamVPKsList\source2007_mid.txt"
  $source2007Patches = Get-Content "$PSScriptRoot\data\Get-SteamVPKsList\source2007_patch_vpks.txt"

  $dummy = Get-Content "$PSScriptRoot\data\Get-SteamVPKsList\dummy.txt"
}

Describe 'Get-SteamVPKsList' {
  BeforeEach {
    Clear-GlobalTestVariables
  }

  Context 'Source 2006' {
    It 'returns the sorted list of Steam vpks' {
      $sharedFolder = 'TestDrive:\'

      ($dummy + $source2006Mid) | % {
        New-Item -ItemType File -Path "$sharedFolder$($_)" -Force
      }

      # Fetch all VPKs, keeping only the test root path.
      $actual = (Get-SteamVPKsList $sharedFolder) | % { ($_).Replace((Get-PSDrive TestDrive).Root + '\', "") }
      $expected = ($source2006Default + $source2006Mid + $source2006Patches)
      
      @(,$actual) | Should -Be @(,$expected)
    }
  }
  
  Context 'Source 2007' {
    It 'returns the sorted list of Steam vpks' {
      $sharedFolder = 'TestDrive:\'

      ($dummy + $source2007Mid) | % {
        New-Item -ItemType File -Path "$sharedFolder$($_)" -Force
      }

      # Fetch all VPKs, keeping only the test root path.
      $actual = (Get-SteamVPKsList $sharedFolder -Source2007) | % { ($_).Replace((Get-PSDrive TestDrive).Root + '\', "") }
      $expected = ($source2007Default + $source2007Mid + $source2007Patches)
      
      @(,$actual) | Should -Be @(,$expected)
    }
  }
}
