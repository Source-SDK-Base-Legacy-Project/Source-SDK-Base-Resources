BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions
  Mock Import-PathsINI {}
  Mock Import-SharedFolder {}
  Mock Initialize-SharedFolder {}
  
  function Invoke-LoadSharedFolder {
    . "$PSScriptRoot\..\scripts\private\load_shared_folder.ps1"
  }
}

Describe 'load_shared_folder' {
  BeforeEach {
    Clear-GlobalTestVariables
    
    $global:SHARED_FOLDER = "TestDrive:\shared_folder"
    New-Item -ItemType Directory -Path $global:SHARED_FOLDER -Force
  }
  
  Context 'when shared folder does not exist' {
    It 'calls Initialize-SharedFolder exactly 1 time' {
      Remove-Item -Path $global:SHARED_FOLDER -Recurse
      Invoke-LoadSharedFolder
      Should -Invoke -CommandName Initialize-SharedFolder -Exactly -Times 1
    }
  }

  Context 'when shared folder already exists' {
    It 'never calls Initialize-SharedFolder' {
      Invoke-LoadSharedFolder
      Should -Invoke -CommandName Initialize-SharedFolder -Exactly -Times 0
    }
  }
}