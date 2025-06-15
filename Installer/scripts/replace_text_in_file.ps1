param (
   [Parameter(Mandatory=$true, Position=0)]
   [string]$textToReplace,
   [Parameter(Mandatory=$true, Position=1)]
   [string]$newText,
   [Parameter(Mandatory=$true, Position=2)]
   [string]$filePath
)

if (-not (Test-Path -Path "$filePath" -PathType Leaf))
{
  throw "$filePath not found!"
}

$content = Get-Content "$filePath" -Raw
$content = $content.Replace($textToReplace, $newText)

Set-Content -Path "$filePath" -Value $content -NoNewline
