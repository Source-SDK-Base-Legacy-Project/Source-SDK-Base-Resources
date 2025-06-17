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

    [switch]$Uninstall = $false,

  [Parameter(Mandatory=$false)]
  [string]$Source
)

. $PSScriptRoot\install_content.ps1 `
    -GamePath $GamePath `
    -GameSubFolder $GameSubFolder `
    -InputVPKName $InputVPKName `
    -OutputVPKBaseName $OutputVPKBaseName `
    -VPKRootFolder $VPKRootFolder `
    -FilesToExtract @("^maps/.*$") `
    -Uninstall:$Uninstall

if (-not ($Uninstall.IsPresent))
{
  # Install
  if ($true -eq (Test-DirectoryExists -Path $SDKBASE2006) -and ($Source -eq "2006" -or $Source -eq "both")) {
    Write-Host "Copying ""$GamePath/$GameSubFolder/maps"" files to ""$SDKBASE2006/$GameSubFolder/maps"""
    New-Item -ItemType Directory -Path "$SDKBASE2006\$GameSubFolder\maps" -Force | Out-Null
    Copy-Item -Path "$GamePath\$GameSubFolder\maps\*" -Destination "$SDKBASE2006\$GameSubFolder\maps" -Recurse -Force
  }

  if ($true -eq (Test-DirectoryExists -Path $SDKBASE2007) -and ($Source -eq "2007" -or $Source -eq "both")) {
    Write-Host "Copying ""$GamePath/$GameSubFolder/maps"" files to ""$SDKBASE2007/$GameSubFolder/maps"""
    New-Item -ItemType Directory -Path "$SDKBASE2007\$GameSubFolder\maps" -Force | Out-Null
    Copy-Item -Path "$GamePath\$GameSubFolder\maps\*" -Destination "$SDKBASE2007\$GameSubFolder\maps" -Recurse -Force
  }
}