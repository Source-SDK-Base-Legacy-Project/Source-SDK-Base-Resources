. $PSScriptRoot\load_paths.ps1

if ($null -eq $local:bImportSteamAppsLoaded) {
  Import-SteamAppsINI
  $local:bImportSteamAppsLoaded = $true
}