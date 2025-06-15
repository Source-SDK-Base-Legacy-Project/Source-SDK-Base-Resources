BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions
}

Describe 'Test-FileExists' {
  It 'Given an empty string, it returns false' {
    Test-FileExists -Path "" | Should -BeFalse $
  }
  It 'Given a white space, it returns false' {
    Test-FileExists -Path " " | Should -BeFalse $
  }
  It 'Given $null, it returns false' {
    Test-FileExists -Path $null | Should -BeFalse $
  }
  It 'Given a non-existing file path, it returns false' {
    Test-FileExists -Path "<invalid>:\file1.txt" | Should -BeFalse $
  }
  It 'Given an existing file path, it returns true' {
    Test-FileExists -Path "$PSCommandPath" | Should -BeTrue $
  }
}
