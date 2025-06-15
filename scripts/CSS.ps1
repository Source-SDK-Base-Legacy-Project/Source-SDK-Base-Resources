param (
   [switch]$Base = $false,
   [switch]$Maps = $false,
   
   [Parameter(Mandatory=$false)]
   [ValidateSet("french", "german", "italian", "japanese", "koreana", "russian", "schinese", "spanish", "tchinese", "thai")]
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
  if (-not (Test-SteamAppInstalled 240))
  {
    throw "Counter-Strike: Source not installed!"
  }

  if (-not (Test-DirectoryExists -Path $CSTRIKE))
  {
    throw "Counter-Strike: Source path not found!"
  }
}

if ($All.IsPresent -or $Base.IsPresent) {

  if (-not $Uninstall.IsPresent) {
    . "$PSScriptRoot\private\copy_game_resources.ps1" `
      -GamePath $CSTRIKE `
      -GameSubFolder cstrike `
      -FilesOrFolders @('resource') `
      -Source $Source
  }

  . "$PSScriptRoot\private\install_base_content.ps1" `
      -GamePath $CSTRIKE `
      -GameSubFolder cstrike `
      -InputVPKName "cstrike_pak_dir.vpk" `
      -OutputVPKBaseName "cstrike_base_converted" `
      -VPKRootFolder cstrike `
      -Uninstall:$Uninstall
}

if ($All.IsPresent -or $Maps.IsPresent) {
  . "$PSScriptRoot\private\install_maps_content.ps1" `
    -GamePath $CSTRIKE `
    -GameSubFolder cstrike `
    -InputVPKName "cstrike_pak_dir.vpk" `
    -OutputVPKBaseName "cstrike_maps_converted" `
    -VPKRootFolder cstrike `
    -Uninstall:$Uninstall `
    -Source $Source
}

if ($All.IsPresent -or $Language) {
  . "$PSScriptRoot\private\install_language_content.ps1" `
    -GamePath $CSTRIKE `
    -GameSubFolder cstrike `
    -InputVPKPrefix cstrike `
    -OutputVPKPrefix cstrike `
    -VPKRootFolder cstrike `
    -Uninstall:$Uninstall
}

. "$PSScriptRoot\private\install_end.ps1" -Source $Source
