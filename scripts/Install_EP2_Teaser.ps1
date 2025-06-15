param (
  [Parameter(Mandatory=$false)]
  [ValidateSet("2007")]
  [string]$Source = "2007"
)

. "$PSScriptRoot\private\install_start.ps1" -Source $Source

if ((-not (Test-SteamAppInstalled 220)) -and (-not (Test-SteamAppInstalled 243730)))
{
  throw "Half-Life 2 / Source SDK Base 2013 Singleplayer not installed!"
}

if ((-not (Test-DirectoryExists -Path $HL2)) -and (-not (Test-DirectoryExists -Path $SDKBASE2013SP)))
{
  throw "Half-Life 2 / Source SDK Base 2013 Singleplayer path not found!"
}

$sourcePath = ""
$targetPath = "$SDKBASE2007\episodic_2007\media"

if (Test-DirectoryExists -Path $HL2) {
  $sourcePath = "$HL2\hl2_complete\media\ep2_teaser.bik"
} 
elseif (Test-DirectoryExists -Path $SDKBASE2013SP) {
  $sourcePath = "$SDKBASE2013SP\episodic\media\ep2_teaser.bik"
}

Write-Host "Copying $sourcePath to $targetPath"
New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
Copy-Item $sourcePath -Destination $targetPath -Recurse -Force

. "$PSScriptRoot\private\install_end.ps1" -Source "2007"
