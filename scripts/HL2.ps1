param (
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

if ($All.IsPresent -or $Language) {
  . "$PSScriptRoot\private\install_language_content.ps1" `
    -GamePath $HL2 `
    -GameSubFolder hl2 `
    -InputVPKPrefix hl2_sound_vo `
    -OutputVPKprefix hl2 `
    -VPKRootFolder hl2 `
    -Uninstall:$Uninstall
}

. "$PSScriptRoot\private\install_end.ps1" -Source $Source
