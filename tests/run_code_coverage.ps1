Import-Module Pester -PassThru -MinimumVersion 5.7.1

. $PSScriptRoot\test_utils.ps1

$config = New-PesterConfiguration
$config.Run.Path = "$PSScriptRoot"
$config.CodeCoverage.Enabled = $true
$config.CodeCoverage.Path = "$PSScriptRoot\..\scripts\*.ps1"
Invoke-Pester -Configuration $config
