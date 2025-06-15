param (
   [switch]$Base = $false,

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
  . "$PSScriptRoot\private\install_content.ps1" `
    -GamePath $HL2 `
    -GameSubFolder ep2 `
    -InputVPKName "ep2_pak_dir.vpk" `
    -OutputVPKBaseName "ep2_language_english_converted" `
    -VPKRootFolder ep2 `
    -FilesToExtract @("^sound/vo/.*$") `
    -Uninstall:$Uninstall
}

if ($All.IsPresent -or $Language) {
  . "$PSScriptRoot\private\install_language_content.ps1" `
    -GamePath $HL2 `
    -GameSubFolder ep2 `
    -InputVPKPrefix ep2_sound_vo `
    -OutputVPKprefix ep2 `
    -VPKRootFolder ep2 `
    -Uninstall:$Uninstall
}

. "$PSScriptRoot\private\install_end.ps1" -Source $Source
