param (
  [Parameter(Mandatory=$true)]
  [ValidateSet("2006", "2007", "both")]
  [string]$Source
)

. $PSScriptRoot\load_paths.ps1

# Update steamapps.ini
. $PSScriptRoot\update_steamapps.ps1

. $PSScriptRoot\load_shared_folder.ps1

if ("2006" -eq $Source.ToLower() -or "both" -eq $Source.ToLower())
{
  Assert-SourceSDKBase2006IsInstalled
}

if ("2007" -eq $Source.ToLower() -or "both" -eq $Source.ToLower())
{
  Assert-SourceSDKBase2007IsInstalled
}
