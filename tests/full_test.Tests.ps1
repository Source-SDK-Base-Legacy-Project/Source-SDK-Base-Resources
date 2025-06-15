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
  Mock Assert-SharedFolderExists {}
  Mock Test-SteamAppInstalled { $true }

  Mock Invoke-ExtractVPK { New-Item -ItemType Directory -Path $outputExtractDir -Force }
  Mock Invoke-VPKEditCLI { New-Item -ItemType File -Path $outputVPKPath -Force }
  
  function Initialize-TestPaths {
    # Create Source SDK Base Path
    $global:SDKBASE2006 = "TestDrive:\Steam\steamapps\common\Source SDK Base"
    New-Item -ItemType Directory -Path $global:SDKBASE2006 -Force
    $global:SDKBASE2007 = "TestDrive:\Steam\steamapps\common\Source SDK Base 2007"
    New-Item -ItemType Directory -Path $global:SDKBASE2007 -Force
    
    # Create shared folder
    $global:SHARED_FOLDER = "TestDrive:\shared_folder"
    New-Item -ItemType Directory -Path $global:SHARED_FOLDER -Force
  }
  
  function Clear-TestPaths {
    Remove-Item -Path $global:SHARED_FOLDER -ErrorAction Ignore -Force -Recurse
    Remove-Item -Path $global:SDKBASE2006 -ErrorAction Ignore -Force -Recurse
    Remove-Item -Path $global:SDKBASE2007 -ErrorAction Ignore -Force -Recurse
  }
    
  function Initialize-TestInputs {
    param(
      [string]$TestGamePath,
      [string]$TestGameSubFolder,
      [string]$TestDataFolder
    )
    
    (Get-ChildItem -Path "$PSScriptRoot\data\full_test\$TestDataFolder" -Filter "inputs.txt" -File -Recurse | % { 
      (Get-Content $_.FullName) | % {
        $directoryPath = Split-Path $TestGamePath\$TestGameSubFolder\$_
        if (-not (Test-Path $directoryPath)) {
          New-Item -ItemType Directory -Path $directoryPath -Force
        }
        New-Item -ItemType File -Path $TestGamePath\$TestGameSubFolder\$_ -Force
      }
    })
  }
  
  function Assert-GameOutputsInstalled {
    param(
      [string]$DataFolder,
      [string]$ContentFolder
    )
    
    $allOutputs = (Get-ChildItem -Path "$PSScriptRoot\data\full_test\$DataFolder" -Filter "outputs.txt"  -File -Recurse | % { Get-Content $_.FullName })
    $allSharedOutputs = (Get-ChildItem -Path "$PSScriptRoot\data\full_test\$DataFolder" -Filter "output_shared_folder.txt"  -File -Recurse | % { Get-Content $_.FullName })

    $expectedOutputs = Get-Content "$PSScriptRoot\data\full_test\$DataFolder\$ContentFolder\outputs.txt"
    $expectedSharedFolderOutputs = Get-Content "$PSScriptRoot\data\full_test\$DataFolder\$ContentFolder\output_shared_folder.txt"
    
    $notExpectedOutputs = $allOutputs | Where { $_ -notin $expectedOutputs }
    $notExpectedSharedFolderOutputs = $allSharedOutputs | Where { $_ -notin $expectedSharedFolderOutputs }
    
    $expectedSharedFolderOutputs  | % { "$global:SHARED_FOLDER\$_"  | Should -Exist }
    $notExpectedSharedFolderOutputs | % { "$global:SHARED_FOLDER\$_"  | Should -Not -Exist }
   
    $notExpectedOutputs | % { 
      "$global:SDKBASE2006\$GameSubFolder\$_" | Should -Not -Exist
      "$global:SDKBASE2007\$GameSubFolder\$_" | Should -Not -Exist
    } 
    
    if ($source -eq '2006') {
      "$global:SDKBASE2006\steam_vpks.vdf" | Should -Exist
      "$global:SDKBASE2007\steam_vpks.vdf" | Should -Not -Exist
      
      $expectedOutputs | % { 
        "$global:SDKBASE2006\$GameSubFolder\$_" | Should -Exist
        "$global:SDKBASE2007\$GameSubFolder\$_" | Should -Not -Exist
      }
    }
    elseif ($source -eq '2007') {
      "$global:SDKBASE2006\steam_vpks.vdf" | Should -Not -Exist
      "$global:SDKBASE2007\steam_vpks.vdf" | Should -Exist
      
      $expectedOutputs | % { 
        "$global:SDKBASE2006\$GameSubFolder\$_" | Should -Not -Exist
        "$global:SDKBASE2007\$GameSubFolder\$_" | Should -Exist
      }
    }
    elseif ($source -eq 'both') {
      "$global:SDKBASE2006\steam_vpks.vdf" | Should -Exist
      "$global:SDKBASE2007\steam_vpks.vdf" | Should -Exist
      
      $expectedOutputs | % { 
        "$global:SDKBASE2006\$GameSubFolder\$_" | Should -Exist
        "$global:SDKBASE2007\$GameSubFolder\$_" | Should -Exist
      }
    }
  }
  
  function Initialize-TestSharedFolderOutputs {
    param(
      [string]$TestDataFolder
    )
    (Get-ChildItem -Path "$PSScriptRoot\data\full_test\$TestDataFolder" -Filter "output_shared_folder.txt" -File -Recurse | % { 
      (Get-Content $_.FullName) | % {
        $directoryPath = Split-Path $global:SHARED_FOLDER\$_
        if (-not (Test-Path $directoryPath)) {
          New-Item -ItemType Directory -Path $directoryPath -Force
        }
        New-Item -ItemType File -Path $global:SHARED_FOLDER\$_ -Force
      }
    })
  }
  
  function Assert-SharedFolderOutputsUninstalled {
    param(
      [string]$DataFolder,
      [string]$ContentFolder
    )
    
    $allSharedOutputs = (Get-ChildItem -Path "$PSScriptRoot\data\full_test\$DataFolder" -Filter "output_shared_folder.txt"  -File -Recurse | % { Get-Content $_.FullName })
    $expectedSharedFolderOutputs = Get-Content "$PSScriptRoot\data\full_test\$DataFolder\$ContentFolder\output_shared_folder.txt"
    $notExpectedSharedFolderOutputs = $allSharedOutputs | Where { $_ -notin $expectedSharedFolderOutputs }
    
    $expectedSharedFolderOutputs  | % { "$global:SHARED_FOLDER\$_"  | Should -Not -Exist }
    $notExpectedSharedFolderOutputs | % { "$global:SHARED_FOLDER\$_"  | Should -Exist }
  }
  
  function Invoke-InstallEP2Teaser {
    . "$PSScriptRoot\..\scripts\Install_EP2_Teaser.ps1"
  }
}

Describe 'Install_EP2_Teaser' {
  BeforeEach {
    Clear-GlobalTestVariables
    Initialize-ToolsPaths
    Initialize-TestPaths
  }

  AfterEach {
    Clear-TestPaths
  }

  Context 'when HL2 and SDKBASE2013SP are not installed' {
    It 'returns with exit code = 1' {
      Mock Test-SteamAppInstalled { $false }
      {
        Invoke-InstallEP2Teaser
        $LASTEXITCODE | Should -Be 1
      }
    }
  }
  
  Context "when HL2 and SDKBASE2013SP are installed but the install paths don't exist" {
    It 'returns with exit code = 1' {
      Mock Test-SteamAppInstalled { $true }
      Mock Test-DirectoryExists { $false }
      {
        Invoke-InstallEP2Teaser
        $LASTEXITCODE | Should -Be 1
      }
    }
  }
  
  Context 'when Half-Life 2 is installed' {
    It 'installs ep2_teaser.bik to Source SDK Base 2007' {
      $global:HL2 = "TestDrive:\Steam\steamapps\common\Half-Life 2"
      New-Item -ItemType Directory -Path $global:HL2\hl2_complete\media -Force
      New-Item -ItemType File -Path $global:HL2\hl2_complete\media\ep2_teaser.bik -Force

      Invoke-InstallEP2Teaser 

      "$SDKBASE2007\episodic_2007\media\ep2_teaser.bik" | Should -Exist
    }
  }

  Context 'when Source SDK 2013 Singleplayer is installed' {
    It 'installs ep2_teaser.bik to Source SDK Base 2007' {
      $global:SDKBASE2013SP = "TestDrive:\Steam\steamapps\common\Source SDK Base 2013 Singleplayer"
      New-Item -ItemType Directory -Path $global:SDKBASE2013SP\episodic\media -Force
      New-Item -ItemType File -Path $global:SDKBASE2013SP\episodic\media\ep2_teaser.bik -Force

      Invoke-InstallEP2Teaser 

      "$SDKBASE2007\episodic_2007\media\ep2_teaser.bik" | Should -Exist
    }
  }
}

Describe "<name>" -ForEach @(
  @{ 
    Name = "Counter-Strike: Source";
    Sources = @(@{ Source = '2006' }, @{ Source = '2007' }, @{ Source = 'both' });
    GamePathVarName = "CSTRIKE"; 
    GameFolder = "Counter-Strike Source";
    GameSubFolder = "cstrike";
    DataFolder = "cstrike";
    InstallScript = "CSS";
    Contents = @('base', 'maps');
    Languages = @(
      @{ Language = 'french' }
      @{ Language = 'german' }
      @{ Language = 'italian' }
      @{ Language = 'japanese' }
      @{ Language = 'koreana' }
      @{ Language = 'russian' }
      @{ Language = 'schinese' }
      @{ Language = 'spanish' }
      @{ Language = 'tchinese' }
      @{ Language = 'thai' }
    );
  }
  @{ 
    Name = "Day of Defeat: Source";
    Sources = @(@{ Source = '2006' }, @{ Source = '2007' }, @{ Source = 'both' });
    GamePathVarName = "DOD"; 
    GameFolder = "Day of Defeat Source";
    GameSubFolder = "dod";
    DataFolder = "dod";
    InstallScript = "DOD";
    Contents = @('base', 'maps');
  }
  @{ 
    Name = "Half-Life: Source";
    Sources = @(@{ Source = '2006' }, @{ Source = '2007' }, @{ Source = 'both' });
    GamePathVarName = "HL1"; 
    GameFolder = "Half-Life 2";
    GameSubFolder = "hl1";
    DataFolder = "hl1";
    InstallScript = "HL1";
    Contents = @('base', 'maps');
    Languages = @(
      @{ Language = 'french' }
      @{ Language = 'german' }
      @{ Language = 'italian' }
      @{ Language = 'koreana' }
      @{ Language = 'russian' }
      @{ Language = 'schinese' }
      @{ Language = 'spanish' }
      @{ Language = 'tchinese' }
    );
  }
  @{ 
    Name = "Half-Life: Source (HD Content)";
    Sources = @(@{ Source = '2006' }, @{ Source = '2007' }, @{ Source = 'both' });
    GamePathVarName = "HL1"; 
    GameFolder = "Half-Life 2";
    GameSubFolder = "hl1_hd";
    DataFolder = "hl1";
    InstallScript = "HL1";
    Contents = @('hd');
  }
  @{ 
    Name = "Half-Life Deathmatch: Source";
    Sources = @(@{ Source = '2006' }, @{ Source = '2007' }, @{ Source = 'both' });
    GamePathVarName = "HL1MP"; 
    GameFolder = "Half-Life 1 Source Deathmatch";
    GameSubFolder = "hl1mp";
    DataFolder = "hl1mp";
    InstallScript = "HL1MP";
    Contents = @('base', 'maps');
  }
  @{ 
    Name = "Half-Life Deathmatch: Source (HL)";
    Sources = @(@{ Source = '2006' }, @{ Source = '2007' }, @{ Source = 'both' });
    GamePathVarName = "HL1MP"; 
    GameFolder = "Half-Life 1 Source Deathmatch";
    GameSubFolder = "hl1";
    DataFolder = "hl1mp";
    InstallScript = "HL1MP";
    Contents = @('hl');
  }
  @{ 
    Name = "Half-Life 2";
    Sources = @(@{ Source = '2006' }, @{ Source = '2007' }, @{ Source = 'both' });
    GamePathVarName = "HL2"; 
    GameFolder = "Half-Life 2";
    GameSubFolder = "hl2";
    DataFolder = "hl2";
    InstallScript = "HL2";
    Languages = @(
      @{ Language = 'french' }
      @{ Language = 'german' }
      @{ Language = 'italian' }
      @{ Language = 'koreana' }
      @{ Language = 'russian' }
      @{ Language = 'schinese' }
      @{ Language = 'spanish' }
      @{ Language = 'tchinese' }
    );
  }
  @{ 
    Name = "Half-Life 2: Episode One";
    Sources = @(@{ Source = '2006' }, @{ Source = '2007' }, @{ Source = 'both' });
    GamePathVarName = "HL2"; 
    GameFolder = "Half-Life 2";
    GameSubFolder = "episodic";
    DataFolder = "hl2ep1";
    InstallScript = "HL2EP1";
    Languages = @(
      @{ Language = 'french' }
      @{ Language = 'german' }
      @{ Language = 'italian' }
      @{ Language = 'koreana' }
      @{ Language = 'russian' }
      @{ Language = 'schinese' }
      @{ Language = 'spanish' }
      @{ Language = 'tchinese' }
    );
  }
  @{ 
    Name = "Half-Life 2: Episode Two";
    Sources = @(@{ Source = '2007' });
    GamePathVarName = "HL2"; 
    GameFolder = "Half-Life 2";
    GameSubFolder = "ep2";
    DataFolder = "hl2ep2";
    InstallScript = "HL2EP2";
    Contents = @('base');
    Languages = @(
      @{ Language = 'french' }
      @{ Language = 'german' }
      @{ Language = 'russian' }
      @{ Language = 'spanish' }
    );
  }
  @{ 
    Name = "Half-Life 2: Deathmatch";
    Sources = @(@{ Source = '2006' }, @{ Source = '2007' }, @{ Source = 'both' });
    GamePathVarName = "HL2MP"; 
    GameFolder = "Half-Life 2 Deathmatch";
    GameSubFolder = "hl2mp";
    DataFolder = "hl2mp";
    InstallScript = "HL2MP";
    Contents = @('base');
  }
  @{ 
    Name = "Half-Life 2: Lost Coast";
    Sources = @(@{ Source = '2006' }, @{ Source = '2007' }, @{ Source = 'both' });
    GamePathVarName = "HL2"; 
    GameFolder = "Half-Life 2";
    GameSubFolder = "lostcoast";
    DataFolder = "lostcoast";
    InstallScript = "LostCoast";
    Contents = @('base', 'maps');
    Languages = @(
      @{ Language = 'french' }
      @{ Language = 'german' }
      @{ Language = 'italian' }
      @{ Language = 'koreana' }
      @{ Language = 'russian' }
      @{ Language = 'schinese' }
      @{ Language = 'spanish' }
      @{ Language = 'tchinese' }
    );
  }
  @{ 
    Name = "Portal";
    Sources = @(@{ Source = '2007' });
    GamePathVarName = "PORTAL"; 
    GameFolder = "Portal";
    GameSubFolder = "portal";
    DataFolder = "portal";
    InstallScript = "Portal";
    Contents = @('base', 'maps');
    Languages = @(
      @{ Language = 'french' }
      @{ Language = 'german' }
      @{ Language = 'russian' }
      @{ Language = 'spanish' }
    );
  }
  @{ 
    Name = "Source SDK Base 2013 Multiplayer (HL2MP)";
    Sources = @(@{ Source = '2006' }, @{ Source = '2007' }, @{ Source = 'both' });
    GamePathVarName = "SDKBASE2013MP"; 
    GameFolder = "Source SDK Base 2013 Multiplayer";
    GameSubFolder = "hl2mp";
    DataFolder = "sdk2013mp_hl2mp";
    InstallScript = "SDK2013MP_HL2MP";
    Contents = @('base');
  }
  @{ 
    Name = "Source SDK Base 2013 Singleplayer (HL2EP2)";
    Sources = @(@{ Source = '2007' });
    GamePathVarName = "SDKBASE2013SP"; 
    GameFolder = "Source SDK Base 2013 Singleplayer";
    GameSubFolder = "ep2";
    DataFolder = "sdk2013sp_hl2ep2";
    InstallScript = "SDK2013SP_HL2EP2";
    Contents = @('base');
  }
) {

  BeforeEach {
    Mock Test-SteamAppInstalled { $true }
    
    Clear-GlobalTestVariables
    Initialize-ToolsPaths
    Initialize-TestPaths
    
    # Create game path
    Set-Variable -Name $GamePathVarName -Value "TestDrive:\Program Files (x86)\Steam\steamapps\common\$GameFolder" -Scope Global

    # Initializes test inputs. 
    Initialize-TestInputs (Get-Variable -Name $GamePathVarName -Scope Global -ValueOnly) $GameSubFolder $DataFolder
  }
  
  AfterEach {
    Clear-TestPaths
  }
  
  Context "when uninstalling with -Source=<source>" -ForEach $Sources {
    
    BeforeEach {
      Initialize-TestSharedFolderOutputs $DataFolder
    }
    
    if ($null -ne $Contents) {
      if ($Contents.Contains('base')) {
        It 'uninstalls -Base' {
          . "$PSScriptRoot\..\scripts\$InstallScript.ps1" -Base -Uninstall -Source $source
          Assert-SharedFolderOutputsUninstalled $DataFolder "base"
        }
      }
      
      if ($Contents.Contains('hd')) {
        It 'uninstalls -HD' {
          . "$PSScriptRoot\..\scripts\$InstallScript.ps1" -HD -Uninstall -Source $source
          Assert-SharedFolderOutputsUninstalled $DataFolder "hd"
        }
      }
      
      if ($Contents.Contains('hl')) {
        It 'uninstalls -HL' {
          . "$PSScriptRoot\..\scripts\$InstallScript.ps1" -HL -Uninstall -Source $source
          Assert-SharedFolderOutputsUninstalled $DataFolder "hl"
        }
      }
      
      if ($Contents.Contains('maps')) {
        It 'uninstalls -Maps' {
          . "$PSScriptRoot\..\scripts\$InstallScript.ps1" -Maps -Uninstall -Source $source
          Assert-SharedFolderOutputsUninstalled $DataFolder "maps"
        }
      }
    }
    
    if ($null -ne $Languages) {
      It 'uninstalls -Language="<language>"' -ForEach $Languages {
        . "$PSScriptRoot\..\scripts\$InstallScript.ps1" -Language $language -Uninstall -Source $source
        Assert-SharedFolderOutputsUninstalled $DataFolder $language
      }
    }
  }
  
  Context "when installing with -Source=<source>" -ForEach $Sources {
    
    AfterEach {
      Clear-TestPaths
    }
    
    if ($null -ne $Contents) {
      if ($Contents.Contains('base')) {
        It 'installs -Base' {
          . "$PSScriptRoot\..\scripts\$InstallScript.ps1" -Base -Source $source
          Assert-GameOutputsInstalled $DataFolder "base"
        }
      }
      
      if ($Contents.Contains('hd')) {
        It 'installs -HD' {
          . "$PSScriptRoot\..\scripts\$InstallScript.ps1" -HD -Source $source
          Assert-GameOutputsInstalled $DataFolder "hd"
        }
      }
      
      if ($Contents.Contains('hl')) {
        It 'installs -HL' {
          . "$PSScriptRoot\..\scripts\$InstallScript.ps1" -HL -Source $source
          Assert-GameOutputsInstalled $DataFolder "hl"
        }
      }
      
      if ($Contents.Contains('maps')) {
        It 'installs -Maps' {
          . "$PSScriptRoot\..\scripts\$InstallScript.ps1" -Maps -Source $source
          Assert-GameOutputsInstalled $DataFolder "maps"
        }
      }
    }
    
    if ($null -ne $Languages) {
      It 'installs -Language="<language>"' -ForEach $Languages {
        . "$PSScriptRoot\..\scripts\$InstallScript.ps1" -Language $language -Source $source
        Assert-GameOutputsInstalled $DataFolder $language
      }
    }
  }
}
