param (
   [switch]$Base = $false,
   [switch]$Maps = $false,

   [Parameter(Mandatory=$false)]
   [ValidateSet("french", "german", "russian", "spanish")]
   [string]$Language,

   [switch]$All = $false,
   [switch]$Uninstall = $false,
   
  [Parameter(Mandatory=$false)]
  [ValidateSet("2007")]
  [string]$Source = "2007"
)

. "$PSScriptRoot\private\install_start.ps1" -Source $Source

if (-not ($Uninstall.IsPresent))
{
  if (-not (Test-SteamAppInstalled 400))
  {
    throw "Portal not installed!"
  }

  if (-not (Test-DirectoryExists -Path $PORTAL))
  {
    throw "Portal path not found!"
  }
}

if ($All.IsPresent -or $Base.IsPresent) {
  if (-not $Uninstall.IsPresent) {
    . "$PSScriptRoot\private\copy_game_resources.ps1" `
      -GamePath $PORTAL `
      -GameSubFolder portal `
      -FilesOrFolders @('resource') `
      -Source $Source
  }

  . "$PSScriptRoot\private\install_base_content.ps1" `
      -GamePath $PORTAL `
      -GameSubFolder portal `
      -InputVPKName "portal_pak_dir.vpk" `
      -OutputVPKBaseName "portal_base_converted" `
      -VPKRootFolder portal `
      -Uninstall:$Uninstall
}

if ($All.IsPresent -or $Maps.IsPresent) {
  . "$PSScriptRoot\private\install_maps_content.ps1" `
    -GamePath $PORTAL `
    -GameSubFolder portal `
    -InputVPKName "portal_pak_dir.vpk" `
    -OutputVPKBaseName "portal_maps_converted" `
    -VPKRootFolder portal `
    -Uninstall:$Uninstall `
    -Source $Source
}

if ($All.IsPresent -or $Language) {
  . "$PSScriptRoot\private\install_language_content.ps1" `
    -GamePath $PORTAL `
    -GameSubFolder portal `
    -InputVPKPrefix portal_sound_vo `
    -OutputVPKprefix portal `
    -VPKRootFolder portal `
    -Uninstall:$Uninstall
}

. "$PSScriptRoot\private\install_end.ps1" -Source $Source
