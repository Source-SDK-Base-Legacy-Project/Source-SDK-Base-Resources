BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions
  Mock Invoke-ExtractVPK { 
    New-Item -ItemType Directory -Path $outputExtractDir
  }
  Mock Invoke-VPKEditCLI {
    New-Item -ItemType File -Path $outputVPKPath -Force
  }

  function Invoke-InstallContent {
    param([switch]$Uninstall)
    . "$PSScriptRoot\..\scripts\private\install_content.ps1" `
      -GamePath $GamePath `
      -GameSubFolder $GameSubFolder `
      -InputVPKName $InputVPKName `
      -OutputVPKBaseName $OutputVPKBaseName `
      -VPKRootFolder $VPKRootFolder `
      -Uninstall:$Uninstall
  }
}

Describe 'install_content' {
  BeforeEach {
    Clear-GlobalTestVariables
    Initialize-ToolsPaths
    
    # Create shared folder
    $global:SHARED_FOLDER = "TestDrive:\shared_folder"
    New-Item -ItemType Directory -Path $global:SHARED_FOLDER -Force

    # Create game path
    $GamePath = "TestDrive:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Source"
    New-Item -ItemType Directory -Path $GamePath -Force
    
    # Create game path + subfolder
    $GameSubFolder = "cstrike"
    New-Item -ItemType Directory -Path $GamePath\$GameSubFolder -Force
    
    # Create input VPK
    $InputVPKName = "cstrike_pak_dir.vpk"
    New-Item -ItemType File -Path $GamePath\$GameSubFolder\$InputVPKName -Force
    
    # Define output VPK.
    $OutputVPKBaseName = "cstrike_base_converted"
    $OutputVPKPath = $global:SHARED_FOLDER + "\$($OutputVPKBaseName)_dir.vpk"
    
    # Remove any previously created output VPK.
    Remove-Item -Path $OutputVPKPath -ErrorAction Ignore -Force

    # Define output VPK root folder.
    $VPKRootFolder = "cstrike"
  }
  
  Context 'when shared folder does not exist' {
    It 'throws an exception' {
      Remove-Item -Path $global:SHARED_FOLDER -Recurse
      { Invoke-InstallContent } | Should -Throw -ExpectedMessage "Path to shared folder not found!"
    }
  }

  Context 'when installing content' {

    Context 'when ExtractVPK.exe does not exist' {
      It 'throws an exception' {
        Remove-Item -Path $global:EXTRACTVPK
        { Invoke-InstallContent }  | Should -Throw -ExpectedMessage "Path to ExtractVPK.exe not found!"
      }
    }
    
    Context 'when vpkeditcli.exe does not exist' {
      It 'throws an exception' {
        Remove-Item -Path $global:VPKEDITCLI
        { Invoke-InstallContent }  | Should -Throw -ExpectedMessage "Path to vpkeditcli.exe not found!"
      }
    }
    
    Context 'when game path does not exist' {
      It 'throws an exception' {
        Remove-Item -Path $GamePath -Recurse
        { Invoke-InstallContent }  | Should -Throw -ExpectedMessage "Path ""$GamePath"" not found!"
      }
    }
    
    Context 'when game subfolder does not exist' {
      It 'throws an exception' {
        Remove-Item -Path "$GamePath\$GameSubFolder" -Recurse
        { Invoke-InstallContent }  | Should -Throw -ExpectedMessage "Path ""$GamePath\$GameSubFolder"" not found!"
      }
    }
    
    Context 'when input VPK does not exist' {
      It 'throws an exception' {
        Remove-Item -Path "$GamePath\$GameSubFolder\$InputVPKName" -Recurse
        { Invoke-InstallContent }  | Should -Throw -ExpectedMessage "VPK file ""$GamePath\$GameSubFolder\$InputVPKName"" not found!"
      }
    }
    
    Context 'when output VPK does not already exist' {
      It 'it creates a new VPK archive' {
        $OutputVPKPath | Should -Not -Exist
        Invoke-InstallContent
        $OutputVPKPath | Should -Exist
      }
    }
    
    Context 'when output VPKs already exist' {
      It 'removes the old VPKs, then creates a new VPK archive' {
        New-Item -ItemType File -Path $OutputVPKPath -Force
        $OutputVPKPath | Should -Exist
        Invoke-InstallContent
        $OutputVPKPath | Should -Exist
      }
    }
  }
  
  Context 'when uninstalling content' {
    Context 'when output VPKs already exist' {
      It 'removes the old VPKs' {
        New-Item -ItemType File -Path $OutputVPKPath -Force
        $OutputVPKPath | Should -Exist
        Invoke-InstallContent -Uninstall
        $OutputVPKPath | Should -Not -Exist
      }
    }
    Context 'when output VPKs does not already exist' {
      It 'removes the old VPKs' {
        $OutputVPKPath | Should -Not -Exist
        Invoke-InstallContent -Uninstall
        $OutputVPKPath | Should -Not -Exist
      }
    }
  }
}