BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions
}

Describe 'Initialize-SharedFolder' {
  BeforeEach {
    Clear-GlobalTestVariables
  }
  
  It 'creates shared folder' {
    $global:SHARED_FOLDER = "TestDrive:\shared_folder"
    $global:SHARED_FOLDER | Should -Not -Exist $
    Initialize-SharedFolder
    $global:SHARED_FOLDER | Should -Exist $
  }
}