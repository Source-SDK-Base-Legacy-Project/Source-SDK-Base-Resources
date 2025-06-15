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

    [Parameter(Mandatory=$false)]
    [string[]]$FilesToExclude = $null,

    [Parameter(Mandatory=$false)]
    [string[]]$FilesToExtract = $null,

    [switch]$Uninstall = $false
)

Assert-SharedFolderExists

Function Remove-VPKs {
  (Get-ChildItem -Path $SHARED_FOLDER -Filter "$($OutputVPKBaseName)*.vpk" -File -Recurse | % {
    Write-Host "Removing $($_.FullName)" -ForegroundColor White
    Remove-Item "$($_.FullName)" -Force
  })
}

if ($Uninstall.IsPresent) {

  # Uninstall
  Remove-VPKs

} else {

  # Install

  if (-not (Test-FileExists -Path $EXTRACTVPK))
  {
    throw "Path to ExtractVPK.exe not found!"
  }

  if (-not (Test-FileExists -Path $VPKEDITCLI))
  {
    throw "Path to vpkeditcli.exe not found!"
  }

  if (-not (Test-DirectoryExists -Path $GamePath))
  {
    throw "Path ""$GamePath"" not found!"
  }

  if (-not (Test-DirectoryExists -Path "$GamePath\$GameSubFolder"))
  {
    throw "Path ""$GamePath\$GameSubFolder"" not found!"
  }

  $inputVPKPath = "$GamePath\$GameSubFolder\$InputVPKName"
  if (-not (Test-FileExists -Path $inputVPKPath))
  {
    throw "VPK file ""$inputVPKPath"" not found!"
  }

  # Remove previously created VPKs.
  Remove-VPKs

  $outputVPKFullName = $OutputVPKBaseName + "_dir.vpk"
  $outputVPKPath = "$SHARED_FOLDER\$outputVPKFullName"

  $extractDir = $outputVPKPath.Replace(".vpk", "")

  Write-Host "Extracting $InputVPKName" -ForegroundColor Cyan
  Invoke-ExtractVPK $inputVPKPath "$extractDir\$VPKRootFolder" $FilesToExclude $FilesToExtract | Out-Null
  Write-Host "Done" -ForegroundColor Green

  Write-Host "Creating new VPK archive $outputVPKFullName" -ForegroundColor Cyan
  Invoke-VPKEditCLI "$extractDir" $outputVPKPath | Out-Null
  Write-Host "Done" -ForegroundColor Green

  Write-Host "Removing $extractDir"
  Remove-Item -Path "$extractDir" -Recurse -Force
}
