param (
   [switch]$Base = $false,
   [switch]$Maps = $false,

   [Parameter(Mandatory=$false)]
   [ValidateSet("french", "german", "italian", "koreana", "russian", "schinese",  "spanish", "tchinese")]
   [string]$Language,

   [switch]$All = $false,
   [switch]$Uninstall = $false,
   
  [Parameter(Mandatory=$false)]
  [ValidateSet("2006", "2007", "both")]
  [string]$Source = "both"
)

. "$PSScriptRoot\private\install_start.ps1" -Source $Source

if (-not ($Uninstall.IsPresent))
{
  if (-not (Test-SteamAppInstalled 220))
  {
    throw "Half-Life 2 not installed!"
  }

  if (-not (Test-DirectoryExists -Path $HL2))
  {
    throw "Half-Life 2 path not found!"
  }
}

if ($All.IsPresent -or $Base.IsPresent) {
  if (-not $Uninstall.IsPresent) {
    . "$PSScriptRoot\private\copy_game_resources.ps1" `
      -GamePath $HL2 `
      -GameSubFolder lostcoast `
      -FilesOrFolders @('resource') `
      -Source $Source
  }

  . "$PSScriptRoot\private\install_base_content.ps1" `
      -GamePath $HL2 `
      -GameSubFolder lostcoast `
      -InputVPKName "lostcoast_pak_dir.vpk" `
      -OutputVPKBaseName "lostcoast_base_converted" `
      -VPKRootFolder lostcoast `
      -Uninstall:$Uninstall
}

if ($All.IsPresent -or $Maps.IsPresent) {
  . "$PSScriptRoot\private\install_maps_content.ps1" `
    -GamePath $HL2 `
    -GameSubFolder lostcoast `
    -InputVPKName "lostcoast_pak_dir.vpk" `
    -OutputVPKBaseName "lostcoast_maps_converted" `
    -VPKRootFolder lostcoast `
    -Uninstall:$Uninstall `
    -Source $Source
}

if ($All.IsPresent -or $Language) {
  . "$PSScriptRoot\private\install_language_content.ps1" `
    -GamePath $HL2 `
    -GameSubFolder lostcoast `
    -InputVPKPrefix lostcoast_sound_vo `
    -OutputVPKprefix lostcoast `
    -VPKRootFolder lostcoast `
    -Uninstall:$Uninstall
}

. "$PSScriptRoot\private\install_end.ps1" -Source $Source
