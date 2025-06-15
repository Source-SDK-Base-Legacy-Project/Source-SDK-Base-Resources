. $PSScriptRoot\load_paths.ps1

if ($null -eq $local:bImportSharedFolderLoaded) {
  Import-SharedFolder
  $local:bImportSharedFolderLoaded = $true
}

if (-not (Test-DirectoryExists -Path $SHARED_FOLDER))
{
  Write-Host "Creating shared directory at ""$SHARED_FOLDER""" -ForegroundColor Yellow
  Initialize-SharedFolder | Out-Null
}
