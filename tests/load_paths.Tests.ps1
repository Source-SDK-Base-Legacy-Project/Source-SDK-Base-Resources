BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions
  Mock Import-PathsINI {}
  
  function Invoke-LoadPaths {
    . "$PSScriptRoot\..\scripts\private\load_paths.ps1"
  }
}

Describe 'load_paths' {
  BeforeEach {
    Clear-GlobalTestVariables
  }
  
  It 'calls Import-PathsINI exactly 1 time' {
    Invoke-LoadPaths
    Should -Invoke -CommandName Import-PathsINI -Exactly -Times 1
  }
}