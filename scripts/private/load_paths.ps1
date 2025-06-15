. $PSScriptRoot\utils.ps1

if ($null -eq $local:bImportPathsINILoaded) {
  Import-PathsINI
  $local:bImportPathsINILoaded = $true
}
