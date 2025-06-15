param (
   [switch]$Base = $false,

   [switch]$All = $false,
   [switch]$Uninstall = $false,
   
  [Parameter(Mandatory=$false)]
  [ValidateSet("2007")]
  [string]$Source = "2007"
)

. "$PSScriptRoot\private\install_start.ps1" -Source $Source

if (-not ($Uninstall.IsPresent))
{
  if (-not (Test-SteamAppInstalled 243730))
  {
    throw "Source SDK Base 2013 Singleplayer not installed!"
  }

  if (-not (Test-DirectoryExists -Path $SDKBASE2013SP))
  {
    throw "Source SDK Base 2013 Singleplayer path not found!"
  }
}

if ($All.IsPresent -or $Base.IsPresent) {
  . "$PSScriptRoot\private\install_content.ps1" `
    -GamePath $SDKBASE2013SP `
    -GameSubFolder ep2 `
    -InputVPKName "ep2_pak_dir.vpk" `
    -OutputVPKBaseName "sdkbase2013sp_ep2_language_english_converted" `
    -VPKRootFolder ep2 `
    -FilesToExtract @("^sound/vo/.*$") `
    -Uninstall:$Uninstall
}

. "$PSScriptRoot\private\install_end.ps1" -Source $Source
