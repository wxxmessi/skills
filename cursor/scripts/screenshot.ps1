[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$Html,   # input HTML file path
  [Parameter(Mandatory = $true)][string]$Out,    # output PNG path (non-ASCII dir OK)
  [int]$Width  = 1080,
  [int]$Height = 1440,
  [int]$Scale  = 2
)
$ErrorActionPreference = "Stop"

$candidates = @(
  "C:\Program Files\Google\Chrome\Application\chrome.exe",
  "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
  "C:\Program Files\Microsoft\Edge\Application\msedge.exe",
  "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
)
$browser = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $browser) { Write-Error "No Chrome/Edge found. Install one."; exit 1 }

# Stage via ASCII temp paths to avoid non-ASCII path issues during capture
$stem    = [guid]::NewGuid().ToString("N")
$tmpHtml = Join-Path $env:TEMP "card_$stem.html"
$tmpPng  = Join-Path $env:TEMP "card_$stem.png"
Copy-Item -LiteralPath $Html -Destination $tmpHtml -Force

$uri     = ([System.Uri]$tmpHtml).AbsoluteUri
$profile = Join-Path $env:TEMP "chrome_shot_$stem"   # isolated profile: avoid clashing with running Chrome

# Chrome prints a "bytes written" line to stderr; under EAP=Stop that would
# terminate. Drop to Continue around the native call and rely on Test-Path.
$prevEAP = $ErrorActionPreference
$ErrorActionPreference = "Continue"
& $browser --headless=new --disable-gpu --hide-scrollbars --no-first-run --no-default-browser-check `
  --user-data-dir="$profile" --force-device-scale-factor=$Scale --window-size="$Width,$Height" `
  --screenshot="$tmpPng" "$uri" 2>$null | Out-Null
$ErrorActionPreference = $prevEAP
Remove-Item -LiteralPath $profile -Recurse -Force -ErrorAction SilentlyContinue

if (-not (Test-Path $tmpPng)) { Write-Error "Screenshot failed."; exit 1 }

$outDir = Split-Path -Parent $Out
if ($outDir -and -not (Test-Path $outDir)) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
Move-Item -LiteralPath $tmpPng -Destination $Out -Force
Remove-Item -LiteralPath $tmpHtml -Force -ErrorAction SilentlyContinue
Write-Output "OK $Out"
