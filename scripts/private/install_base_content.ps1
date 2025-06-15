param (
    [Parameter(Mandatory=$true)]
    [AllowEmptyString()]
    [string]$GamePath,

    [Parameter(Mandatory=$true)]
    [string]$GameSubFolder,

    [Parameter(Mandatory=$true)]
    [string]$InputVPKName,

    [Parameter(Mandatory=$true)]
    [string]$OutputVPKBaseName,

    [Parameter(Mandatory=$true)]
    [string]$VPKRootFolder,

    [switch]$Uninstall = $false
)

. $PSScriptRoot\install_content.ps1 @PSBoundParameters `
  -FilesToExclude @(
    "^.*\.dll$",
    "^.*\.bin$",
    "^.*\.so$",
    "^.*\.dylib$",
    "^maps/.*$"
   )
