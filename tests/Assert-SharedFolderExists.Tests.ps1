BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions
}

Describe 'Assert-SharedFolderExists' {
  BeforeEach {
    Clear-GlobalTestVariables
    
    $global:SHARED_FOLDER = "TestDrive:\shared_folder"
    New-Item -ItemType Directory -Path $global:SHARED_FOLDER -Force
  }

  Context 'when shared folder does not exist' {
    It 'throws an exception' {
      Remove-Item -Path $global:SHARED_FOLDER -Recurse
      { Assert-SharedFolderExists } | Should -Throw -ExpectedMessage "Path to shared folder not found!"
    }
  }

  Context 'when shared folder exists' {
    It 'does not throw an exception' {
      { Assert-SharedFolderExists } | Should -Not -Throw
    }
  }
}

