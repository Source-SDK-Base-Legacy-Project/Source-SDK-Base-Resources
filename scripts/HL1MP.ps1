param (
   [switch]$Base = $false,
   [switch]$HL = $false,
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
  if (-not (Test-SteamAppInstalled 360))
  {
    throw "Half-Life Deathmatch: Source not installed!"
  }

  if (-not (Test-DirectoryExists -Path $HL1MP))
  {
    throw "Half-Life Deathmatch: Source path not found!"
  }
}

if ($All.IsPresent -or $Base.IsPresent) {
  . "$PSScriptRoot\private\install_base_content.ps1" `
      -GamePath $HL1MP `
      -GameSubFolder hl1mp `
      -InputVPKName "hl1mp_pak_dir.vpk" `
      -OutputVPKBaseName "hl1mp_base_1_converted" `
      -VPKRootFolder hl1mp `
      -Uninstall:$Uninstall
}

if ($All.IsPresent -or $HL.IsPresent) {
  if (-not $Uninstall.IsPresent) {
    . "$PSScriptRoot\private\copy_game_resources.ps1" `
      -GamePath $HL1MP `
      -GameSubFolder hl1 `
      -FilesOrFolders @('resource') `
      -Source $Source
  }
  
  . "$PSScriptRoot\private\install_base_content.ps1" `
    -GamePath $HL1MP `
    -GameSubFolder hl1 `
    -InputVPKName "hl1_pak_dir.vpk" `
    -OutputVPKBaseName "hl1mp_base_2_hl1_converted" `
    -VPKRootFolder hl1 `
    -Uninstall:$Uninstall
}

if ($All.IsPresent -or $Maps.IsPresent) {
  . "$PSScriptRoot\private\install_maps_content.ps1" `
    -GamePath $HL1MP `
    -GameSubFolder hl1mp `
    -InputVPKName "hl1mp_pak_dir.vpk" `
    -OutputVPKBaseName "hl1mp_maps_converted" `
    -VPKRootFolder hl1mp `
    -Uninstall:$Uninstall `
    -Source $Source
}

. "$PSScriptRoot\private\install_end.ps1" -Source $Source
