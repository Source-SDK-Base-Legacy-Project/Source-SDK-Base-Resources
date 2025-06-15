param (
  [Parameter(Mandatory=$true)]
  [string]$GamePath,

  [Parameter(Mandatory=$true)]
  [string]$GameSubFolder,

  [Parameter(Mandatory=$true)]
  [string[]]$FilesOrFolders,

  [Parameter(Mandatory=$false)]
  [string]$Source
)

. $PSScriptRoot\utils.ps1

if (-not (Test-DirectoryExists -Path $GamePath))
{
  throw "Path ""$GamePath"" not found!"
}

if (-not (Test-DirectoryExists -Path "$GamePath\$GameSubFolder"))
{
  throw "Path ""$GamePath\$GameSubFolder"" not found!"
}

if (("2006" -eq $Source.ToLower()) -or ("both" -eq $Source.ToLower()))
{
  Assert-SourceSDKBase2006IsInstalled
  $FilesOrFolders | % {
    Write-Host "Copying ""$GamePath/$GameSubFolder/$($_)"
    New-Item -ItemType Directory -Path "$SDKBASE2006\$GameSubFolder\$($_)" -Force | Out-Null
    Copy-Item "$GamePath\$GameSubFolder\$($_)" -Destination "$SDKBASE2006\$GameSubFolder" -Recurse -Force
  }
}

if (("2007" -eq $Source.ToLower()) -or ("both" -eq $Source.ToLower()))
{
  Assert-SourceSDKBase2007IsInstalled
  $FilesOrFolders | % {
    Write-Host "Copying ""$GamePath/$GameSubFolder/$($_)"
    New-Item -ItemType Directory -Path "$SDKBASE2007\$GameSubFolder\$($_)" -Force | Out-Null
    Copy-Item "$GamePath\$GameSubFolder\$($_)" -Destination "$SDKBASE2007\$GameSubFolder" -Recurse -Force
  }
}
