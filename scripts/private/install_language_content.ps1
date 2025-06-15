param (
    [Parameter(Mandatory=$true)]
    [AllowEmptyString()]
    [string]$GamePath,

    [Parameter(Mandatory=$true)]
    [string]$GameSubFolder,

    [Parameter(Mandatory=$true)]
    [string]$InputVPKPrefix,

    [Parameter(Mandatory=$true)]
    [string]$OutputVPKPrefix,

    [Parameter(Mandatory=$true)]
    [string]$VPKRootFolder,
    
    [switch]$Uninstall = $false
)

$languages = @()

if ($All.IsPresent) {
  $languages += (Get-Variable "Language").Attributes.ValidValues
} else {
  $languages += $Language
}

$languages | % {
  . $PSScriptRoot\install_content.ps1 `
  -GamePath $GamePath `
  -GameSubFolder $GameSubFolder `
  -InputVPKName "$($InputVPKPrefix)_$($_.ToLower())_dir.vpk" `
  -OutputVPKBaseName "$($OutputVPKPrefix)_language_$($_.ToLower())_converted" `
  -VPKRootFolder $VPKRootFolder `
  -FilesToExtract @("^.*$") `
  -Uninstall:$Uninstall
}
