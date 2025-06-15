param (
  [Parameter(Mandatory=$false)]
  [ValidateSet("2006", "2007", "both")]
  [string]$Source = "both"
)

. $PSScriptRoot\update_steam_vpks.ps1 -Source $Source

Write-Host "Finished" -ForegroundColor Green
