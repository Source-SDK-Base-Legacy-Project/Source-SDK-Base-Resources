param (
   [switch]$Base = $false,
   [switch]$HD = $false,
   [switch]$Maps = $false,

   [Parameter(Mandatory=$false)]
   [ValidateSet("french", "german", "italian", "koreana", "russian", "schinese", "spanish", "tchinese")]
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
  if (-not (Test-SteamAppInstalled 280))
  {
    throw "Half-Life: Source not installed!"
  }

  if (-not (Test-DirectoryExists -Path $HL1))
  {
    throw "Half-Life: Source path not found!"
  }
}

if ($All.IsPresent -or $Base.IsPresent) {
  if (-not $Uninstall.IsPresent) {
    . "$PSScriptRoot\private\copy_game_resources.ps1" `
      -GamePath $HL1 `
      -GameSubFolder hl1 `
      -FilesOrFolders @('resource') `
      -Source $Source
  }

  . "$PSScriptRoot\private\install_base_content.ps1" `
      -GamePath $HL1 `
      -GameSubFolder hl1 `
      -InputVPKName "hl1_pak_dir.vpk" `
      -OutputVPKBaseName "hl1_base_1_converted" `
      -VPKRootFolder hl1 `
      -Uninstall:$Uninstall
}

if ($All.IsPresent -or $HD.IsPresent) {
  . "$PSScriptRoot\private\install_base_content.ps1" `
    -GamePath $HL1 `
    -GameSubFolder hl1_hd `
    -InputVPKName "hl1_hd_pak_dir.vpk" `
    -OutputVPKBaseName "hl1_base_2_hd_converted" `
    -VPKRootFolder hl1_hd `
    -Uninstall:$Uninstall
}

if ($All.IsPresent -or $Maps.IsPresent) {
  . "$PSScriptRoot\private\install_maps_content.ps1" `
    -GamePath $HL1 `
    -GameSubFolder hl1 `
    -InputVPKName "hl1_pak_dir.vpk" `
    -OutputVPKBaseName "hl1_maps_converted" `
    -VPKRootFolder hl1 `
    -Uninstall:$Uninstall `
    -Source $Source
}

if ($All.IsPresent -or $Language) {
  . "$PSScriptRoot\private\install_language_content.ps1" `
    -GamePath $HL1 `
    -GameSubFolder hl1 `
    -InputVPKPrefix hl1_sound_vo `
    -OutputVPKprefix hl1 `
    -VPKRootFolder hl1 `
    -Uninstall:$Uninstall
}

. "$PSScriptRoot\private\install_end.ps1" -Source $Source
