. $PSScriptRoot\load_paths.ps1

if ($null -eq $local:bUpdateSteamAppsLoaded) {
  Write-Host "Updating $STEAMAPPSINI" -ForegroundColor Cyan
  Update-SteamAppsINI
  $local:bUpdateSteamAppsLoaded = $true
}

. $PSScriptRoot\load_steamapps.ps1
