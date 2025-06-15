BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions
}

Describe 'Import-SharedFolder' {
  BeforeEach {
    Clear-GlobalTestVariables
  }
  
  Context 'when shared folder file does not exist' {
      It 'throws an exception' {
        $global:SHARED_FOLDER_FILE = "<invalid>:\shared_folder.txt"
        { Import-SharedFolder } | Should -Throw -ExpectedMessage "<invalid>:\shared_folder.txt not found!"
      }
  }
  Context 'when shared folder file exists' {

    Context 'is empty' {
      It 'throws an exception' {
        $global:SHARED_FOLDER_FILE = "TestDrive:\shared_folder.txt"
        New-Item -ItemType File -Path $global:SHARED_FOLDER_FILE -Value "" -Force
        { Import-SharedFolder } | Should -Throw -ExpectedMessage "Shared folder is empty"
      }
    }
    
    Context 'is not empty' {
      It 'creates SHARED_FOLDER variable' {
        $global:SHARED_FOLDER_FILE = "TestDrive:\shared_folder.txt"
        New-Item -ItemType File -Path $global:SHARED_FOLDER_FILE -Value "C:\shared_folder" -Force
        Import-SharedFolder
        $global:SHARED_FOLDER | Should -Be "C:\shared_folder"
      }
    }
  }
}