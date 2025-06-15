param (
  [Parameter(Mandatory=$true)]
  [string]$Source
)

. $PSScriptRoot\load_paths.ps1
. $PSScriptRoot\load_steamapps.ps1
. $PSScriptRoot\load_shared_folder.ps1

if (("2006" -eq $Source.ToLower()) -or ("both" -eq $Source.ToLower()))
{
  Assert-SourceSDKBase2006IsInstalled
  Assert-SharedFolderExists

  Write-Host "Updating $SDKBASE2006/steam_vpks.vdf" -ForegroundColor Cyan
  Write-SteamVPKs "$SDKBASE2006/steam_vpks.vdf" (Get-SteamVPKsList $SHARED_FOLDER)
}

if (("2007" -eq $Source.ToLower()) -or ("both" -eq $Source.ToLower()))
{
  Assert-SourceSDKBase2007IsInstalled
  Assert-SharedFolderExists
  
  Write-Host "Updating $SDKBASE2007/steam_vpks.vdf" -ForegroundColor Cyan
  Write-SteamVPKs "$SDKBASE2007/steam_vpks.vdf" (Get-SteamVPKsList $SHARED_FOLDER -Source2007)
}

Write-Host "Done" -ForegroundColor Green
