param (
   [switch]$Base = $false,
   [switch]$Maps = $false,

   [switch]$All = $false,
   [switch]$Uninstall = $false,
   
  [Parameter(Mandatory=$false)]
  [ValidateSet("2006", "2007", "both")]
  [string]$Source = "both"
)

. "$PSScriptRoot\private\install_start.ps1" -Source $Source

if (-not ($Uninstall.IsPresent))
{
  if (-not (Test-SteamAppInstalled 300))
  {
    throw "Day of Defeat: Source not installed!"
  }

  if (-not (Test-DirectoryExists -Path $DOD))
  {
    throw "Day of Defeat: Source path not found!"
  }
}

if ($All.IsPresent -or $Base.IsPresent) {
  if (-not $Uninstall.IsPresent) {
    . "$PSScriptRoot\private\copy_game_resources.ps1" `
      -GamePath $DOD `
      -GameSubFolder dod `
      -FilesOrFolders @('resource') `
      -Source $Source
  }

  . "$PSScriptRoot\private\install_base_content.ps1" `
      -GamePath $DOD `
      -GameSubFolder dod `
      -InputVPKName "dod_pak_dir.vpk" `
      -OutputVPKBaseName "dod_base_converted" `
      -VPKRootFolder dod `
      -Uninstall:$Uninstall
}

if ($All.IsPresent -or $Maps.IsPresent) {
  . "$PSScriptRoot\private\install_maps_content.ps1" `
    -GamePath $DOD `
    -GameSubFolder dod `
    -InputVPKName "dod_pak_dir.vpk" `
    -OutputVPKBaseName "dod_maps_converted" `
    -VPKRootFolder dod `
    -Uninstall:$Uninstall `
    -Source $Source
}

. "$PSScriptRoot\private\install_end.ps1" -Source $Source
