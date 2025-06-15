BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions
}

Describe 'Test-DirectoryExists' {
  It 'Given an empty string, it returns false' {
    Test-DirectoryExists -Path "" | Should -BeFalse $
  }
  It 'Given a white space, it returns false' {
    Test-DirectoryExists -Path " " | Should -BeFalse $
  }
  It 'Given $null, it returns false' {
    Test-DirectoryExists -Path $null | Should -BeFalse $
  }
  It 'Given a non-existing directory, it returns false' {
    Test-DirectoryExists -Path "<invalid>:\" | Should -BeFalse $
  }
  It 'Given an existing directory, it returns true' {
    Test-DirectoryExists -Path "$PSScriptRoot" | Should -BeTrue $
  }
}
