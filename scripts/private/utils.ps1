function Test-FileExists {
  param ([string]$Path)
  
  if ([string]::IsNullOrEmpty($Path.Trim())) {
    return $false
  }

  return (Test-Path -Path $Path -PathType Leaf)
}

function Test-DirectoryExists {
  param ([string]$Path)
  
  if ([string]::IsNullOrEmpty($Path.Trim())) {
    return $false
  }

  return (Test-Path -Path $Path)
}

function Get-PathsINIPath {
  return "$PSScriptRoot\paths.ini"
}

function Import-PathsINI {
  $PATHS_FILE = Get-PathsINIPath
  
  if (-not (Test-FileExists -Path $PATHS_FILE))
  {
    throw "Path to $PATHS_FILE not found!"
  }

  # Skip [paths] section.
  $lines = Get-Content $PATHS_FILE | Select-Object -Skip 1

  $lines | % {
    if (-not ([string]::IsNullOrEmpty($_))) {
      $tokens = $_ -split "="
      Set-Variable -Name $(($tokens[0]).Trim().ToUpper()) -Value $(($tokens[1]).Trim()) -Scope Global
    }
  }
}

function Import-SteamAppsINI {
  if (-not (Test-FileExists -Path $STEAMAPPSINI))
  {
    throw "Path to steamapps.ini not found!"
  }

  # Skip [steamapps] section.
  $lines = Get-Content $STEAMAPPSINI | Select-Object -Skip 1

  $lines | % {
    if (-not ([string]::IsNullOrEmpty($_))) {
      $tokens = $_ -split "="
      Set-Variable -Name $(($tokens[0]).Trim().ToUpper()) -Value $(($tokens[1]).Trim()) -Scope Global
    }
  }
}

function Update-SteamAppsINI {
  if (-not (Test-FileExists -Path $STEAMAPPS)) {
    throw "Path to SteamApps.exe not found!"
  }

  & "$STEAMAPPS" -o "$STEAMAPPSINI"
}

function Test-SteamAppInstalled {
  param (
    [parameter(Position=0)]
    [int]$SteamAppID
  )
  return ((Get-ItemPropertyValue -Path HKCU:\Software\Valve\Steam\Apps\$SteamAppID -Name Installed) -eq 1)
}

function Import-SharedFolder {
  if (Test-FileExists -Path $SHARED_FOLDER_FILE) {
    $temp = Get-Content $SHARED_FOLDER_FILE -First 1
    if (-not ([string]::IsNullOrEmpty($temp))) {
      Set-Variable -Name SHARED_FOLDER -Value $temp -Scope Global
    }
    else {
      throw "Shared folder is empty";
    }
  }
  else {
    throw "$SHARED_FOLDER_FILE not found!";
  }
}

function Initialize-SharedFolder {
  New-Item -ItemType Directory -Path $SHARED_FOLDER -Force | Out-Null
}

function Write-SteamVPKs {
    param(
        [string]$outPath,
        [string[]]$vpks
    )
   
    New-Item -Path $outPath -ItemType File -Force | Out-Null
    Add-Content -Path $outPath -Value """does_this_even_matter"""
    Add-Content -Path $outPath -Value "{"
    Add-Content -Path $outPath -Value "`t""spewfileio"" ""false"""
    Add-Content -Path $outPath -Value "`t""mount"""
    Add-Content -Path $outPath -Value "`t{"

    $vpks | % {
      $pathWithoutDirAndExtension = ($_).Replace("_dir.vpk", "").Replace("\\", "/").Replace('\', '/')
      Add-Content -Path $outPath -Value "`t`t""vpk"" ""$pathWithoutDirAndExtension"""
    }
    Add-Content -Path $outPath -Value "`t}"
    Add-Content -Path $outPath -Value "}"
}

function Get-OrderedVPKs { 
 param(
    [string]$dir,
    [string[]]$names,
    [string[]]$types
  )
  $names | % {
    $name = $_
    $types | % {
      (Get-ChildItem -Path $dir -Filter "$($name)_*$($_)*_dir.vpk" -File -Recurse | % { $_.FullName })
    }
  }
}

$local:source2006DefaultVPKs = @(
  "vpks/depot_206",
  "vpks/depot_207",
  "vpks/depot_208",
  "vpks/depot_212",
  "vpks/depot_213",
  "vpks/depot_215",
  "vpks/depot_381"
)

$local:source2007DefaultVPKs = @(
  "vpks/depot_206",
  "vpks/depot_207",
  "vpks/depot_208",
  "vpks/depot_213",
  "vpks/depot_215",
  "vpks/depot_381",
  "vpks/depot_216",
  "vpks/depot_218",
  "vpks/depot_305",
  "vpks/depot_306",
  "vpks/depot_307",
  "vpks/depot_308",
  "vpks/depot_309",
  "vpks/depot_421",
  "vpks/depot_422",
  "vpks/depot_423"
)

$local:contentTypes = @('base', 'maps', 'language')

function Get-SteamVPKsList {
  param(
    [string]$dir,
    [switch]$Source2007
  )
  
  if (-not $Source2007.IsPresent) {
    # Source 2006
    $steamVPKsNames2006 = @('hl2', 'ep1', 'sdkbase2013mp', 'hl2mp', 'lostcoast', 'cstrike', 'dod', 'hl1', 'hl1mp')

    $source2006OnlyVPKs = @()
    $source2006OnlyVPKs += Get-OrderedVPKs $dir $steamVPKsNames2006 $contentTypes
    # Add source 2006 patches
    $source2006OnlyVPKs += "vpks/source2006_patches"
    
    ($source2006DefaultVPKs + $source2006OnlyVPKs)
  } else {
    # Source 2007
    $steamVPKsNames2007 = @('hl2', 'ep1', 'sdkbase2013sp', 'ep2', 'sdkbase2013mp', 'hl2mp', 'lostcoast', 'cstrike', 'dod', 'hl1', 'hl1mp', 'portal')

    $source2007OnlyVPKs = @()
    $source2007OnlyVPKs += Get-OrderedVPKs $dir $steamVPKsNames2007 $contentTypes
    # Add source 2007 patches
    $source2007OnlyVPKs += "vpks/source2007_patches"
    
    ($source2007DefaultVPKs + $source2007OnlyVPKs)
  }
}

function Invoke-ExtractVPK {
  param(
    [Parameter(Mandatory=$true)]
    [string]$inputVPKPath,
    
    [Parameter(Mandatory=$true)]
    [string]$outputExtractDir,
    
    [Parameter(Mandatory=$false)]
    [string[]]$FilesToExclude = $null,
    
    [Parameter(Mandatory=$false)]
    [string[]]$FilesToExtract = $null
  )

  if ($null -ne $FilesToExtract -and $null -ne $FilesToExclude) {
    & "$EXTRACTVPK" -i $inputVPKPath -o "$outputExtractDir" -e @FilesToExtract -x @FilesToExclude
  }
  elseif ($null -ne $FilesToExtract) {
    & "$EXTRACTVPK" -i $inputVPKPath -o "$outputExtractDir" -e @FilesToExtract
  }
  else {
    & "$EXTRACTVPK" -i $inputVPKPath -o "$outputExtractDir" -x @FilesToExclude
  }
}

function Invoke-VPKEditCLI {
  param(
    [string]$inputDir,
    [string]$outputVPKPath
  )
  & "$VPKEDITCLI" -c 100 -o $outputVPKPath $inputDir
}

function Assert-SharedFolderExists {
  if (-not (Test-DirectoryExists -Path $SHARED_FOLDER))
  {
    throw "Path to shared folder not found!"
  }
}

function Assert-SourceSDKBase2006IsInstalled {
  if (-not (Test-SteamAppInstalled 215)) {
    throw "Source SDK Base 2006 not installed!"
  }
  if (-not (Test-DirectoryExists -Path $SDKBASE2006)) {
    throw "Source SDK Base 2006 path not found!"
  }
}

function Assert-SourceSDKBase2007IsInstalled {
  if (-not (Test-SteamAppInstalled 218)) {
    throw "Source SDK Base 2007 not installed!"
  }
  if (-not (Test-DirectoryExists -Path $SDKBASE2007)) {
    throw "Source SDK Base 2007 path not found!"
  }
}
