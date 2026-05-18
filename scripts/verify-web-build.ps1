# Verify build/web is ready for Cloudflare Pages (files at deploy root).
$ErrorActionPreference = "Stop"
$root = Join-Path $PSScriptRoot "..\build\web" | Resolve-Path -ErrorAction SilentlyContinue
if (-not $root) {
    throw "Missing build/web. Run: .\scripts\build-flutter-with-defines.ps1 build web --release"
}

$required = @(
    "index.html",
    "flutter_bootstrap.js",
    "main.dart.js",
    "flutter_service_worker.js",
    "manifest.json",
    "_redirects"
)

Write-Host "Checking $root"
$fail = $false
foreach ($name in $required) {
    $path = Join-Path $root $name
    if (Test-Path $path) {
        $size = (Get-Item $path).Length
        Write-Host "  OK  $name ($size bytes)"
    } else {
        Write-Host "  MISSING  $name"
        $fail = $true
    }
}

$html = Get-Content (Join-Path $root "index.html") -Raw
if ($html -match '\$FLUTTER_BASE_HREF') {
    Write-Host "  FAIL  index.html still has `$FLUTTER_BASE_HREF — you uploaded source web/, not a flutter build."
    $fail = $true
} elseif ($html -notmatch '<base href="/">') {
    Write-Host "  WARN  index.html base href is not '/'. Check --base-href if not deploying to domain root."
} else {
    Write-Host "  OK  index.html base href is /"
}

$mainJs = Join-Path $root "main.dart.js"
if ((Test-Path $mainJs) -and (Get-Item $mainJs).Length -lt 100000) {
    Write-Host "  WARN  main.dart.js looks too small — build may be incomplete."
    $fail = $true
}

if ($fail) { exit 1 }
Write-Host "`nbuild/web looks deployable. Upload THIS folder's contents (not the parent build/ folder)."
