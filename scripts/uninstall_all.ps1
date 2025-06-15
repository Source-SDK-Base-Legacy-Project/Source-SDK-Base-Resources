param (
  [Parameter(Mandatory=$false)]
  [ValidateSet("2006", "2007", "both")]
  [string]$Source = "both"
)

& .\CSS.ps1 -All -Uninstall -Source $Source
& .\DOD.ps1 -All -Uninstall -Source $Source
& .\HL1MP.ps1 -All -Uninstall -Source $Source
& .\HL1.ps1 -All -Uninstall -Source $Source
& .\HL2.ps1 -All -Uninstall -Source $Source
& .\HL2MP.ps1 -All -Uninstall -Source $Source
& .\HL2EP1.ps1 -All -Uninstall -Source $Source
& .\LostCoast.ps1 -All -Uninstall -Source $Source
& .\SDK2013MP_HL2MP.ps1 -All -Uninstall -Source $Source

if ("2006" -ne $Source) {
  & .\HL2EP2.ps1 -All -Uninstall
  & .\Portal.ps1 -All -Uninstall
  & .\SDK2013SP_HL2EP2.ps1 -All -Uninstall
}
