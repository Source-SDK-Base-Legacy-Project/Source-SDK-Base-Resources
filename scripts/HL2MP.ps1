param (
   [switch]$Base = $false,

   [switch]$All = $false,
   [switch]$Uninstall = $false,
   
  [Parameter(Mandatory=$false)]
  [ValidateSet("2006", "2007", "both")]
  [string]$Source = "both"
)

. "$PSScriptRoot\private\install_start.ps1" -Source $Source

if (-not ($Uninstall.IsPresent))
{
  if (-not (Test-SteamAppInstalled 320))
  {
    throw "Half-Life 2: Deathmatch not installed!"
  }

  if (-not (Test-DirectoryExists -Path $HL2MP))
  {
    throw "Half-Life 2: Deathmatch path not found!"
  }
}

if ($All.IsPresent -or $Base.IsPresent) {
  if (-not $Uninstall.IsPresent) {
    . "$PSScriptRoot\private\copy_game_resources.ps1" `
      -GamePath $HL2MP `
      -GameSubFolder hl2mp `
      -FilesOrFolders @('resource') `
      -Source $Source
  }

  . "$PSScriptRoot\private\install_base_content.ps1" `
    -GamePath $HL2MP `
    -GameSubFolder hl2mp `
    -InputVPKName "hl2mp_pak_dir.vpk" `
    -OutputVPKBaseName "hl2mp_base_converted" `
    -VPKRootFolder hl2mp `
    -Uninstall:$Uninstall
}

. "$PSScriptRoot\private\install_end.ps1" -Source $Source
