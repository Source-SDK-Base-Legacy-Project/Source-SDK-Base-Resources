BeforeAll {
  . "$PSScriptRoot\..\scripts\private\utils.ps1"
  Disable-WriteFunctions
  Mock Get-PathsINIPath { return "$PSScriptRoot\data\Import-PathsINI\paths.ini" }
}

Describe 'Import-PathsINI' {
  BeforeEach {
    Clear-GlobalTestVariables
  }
  
  It 'Given paths.ini, it should create path variables' {
    $global:EXTRACTVPK | Should -Be $null
    $global:SHARED_FOLDER_FILE | Should -Be $null
    $global:STEAMAPPS | Should -Be $null
    $global:STEAMAPPSINI | Should -Be $null
    $global:VPKEDITCLI | Should -Be $null

    Import-PathsINI

    $global:EXTRACTVPK | Should -Be 'custom_extractvpk'
    $global:SHARED_FOLDER_FILE | Should -Be 'custom_shared_folder_file'
    $global:STEAMAPPS | Should -Be 'custom_steamapps'
    $global:STEAMAPPSINI | Should -Be 'custom_steamappsini'
    $global:VPKEDITCLI | Should -Be 'custom_vpkeditcli'
  }
}
