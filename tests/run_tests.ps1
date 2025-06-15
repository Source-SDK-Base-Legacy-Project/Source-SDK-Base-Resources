Import-Module Pester -PassThru -MinimumVersion 5.7.1

. $PSScriptRoot\test_utils.ps1

Invoke-Pester -Output Detailed $PSScriptRoot\*.Tests.ps1
