function Clear-GlobalTestVariables {
  Remove-Variable -Name EXTRACTVPK -Scope Global -ErrorAction Ignore
  Remove-Variable -Name SHARED_FOLDER_FILE -Scope Global -ErrorAction Ignore
  Remove-Variable -Name STEAMAPPS -Scope Global -ErrorAction Ignore
  Remove-Variable -Name STEAMAPPSINI -Scope Global -ErrorAction Ignore
  Remove-Variable -Name VPKEDITCLI -Scope Global -ErrorAction Ignore

  Remove-Variable -Name CSTRIKE -Scope Global -ErrorAction Ignore
  Remove-Variable -Name DOD -Scope Global -ErrorAction Ignore
  Remove-Variable -Name HL1 -Scope Global -ErrorAction Ignore
  Remove-Variable -Name HL1MP -Scope Global -ErrorAction Ignore
  Remove-Variable -Name HL2 -Scope Global -ErrorAction Ignore
  Remove-Variable -Name HL2MP -Scope Global -ErrorAction Ignore
  Remove-Variable -Name PORTAL -Scope Global -ErrorAction Ignore
  Remove-Variable -Name SDKBASE2006 -Scope Global -ErrorAction Ignore
  Remove-Variable -Name SDKBASE2007 -Scope Global -ErrorAction Ignore
  Remove-Variable -Name SDKBASE2013MP -Scope Global -ErrorAction Ignore
  Remove-Variable -Name SDKBASE2013SP -Scope Global -ErrorAction Ignore
}

function Disable-WriteFunctions {
  Mock Write-Host {}
}

function Initialize-ToolsPaths {
  # Create tools directory
  New-Item -ItemType Directory -Path "TestDrive:\tools" -Force

  # Create ExtractVPK.exe
  $global:EXTRACTVPK = "TestDrive:\tools\ExtractVPK.exe"
  New-Item -ItemType File -Path $global:EXTRACTVPK -Force
  
  # Create vpkeditcli.exe
  $global:VPKEDITCLI = "TestDrive:\tools\vpkeditcli.exe"
  New-Item -ItemType File -Path $global:VPKEDITCLI -Force
}
