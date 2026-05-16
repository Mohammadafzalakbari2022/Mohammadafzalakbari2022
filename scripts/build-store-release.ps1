# Build release artifacts for Play Store, App Store, and Web.
# Usage:
#   .\scripts\build-store-release.ps1
#   .\scripts\build-store-release.ps1 -DefinesFile config\dart_defines_prod.json

param(
    [string] $DefinesFile = "config\dart_defines_prod.json"
)

$ErrorActionPreference = "Stop"
$definesPath = Join-Path (Join-Path $PSScriptRoot "..") $DefinesFile

if (-not (Test-Path $definesPath)) {
    throw "Defines file not found: $definesPath"
}

Push-Location (Join-Path $PSScriptRoot "..")
try {
    flutter pub get
    flutter gen-l10n

    Write-Host "Building Android App Bundle (Play Store) with $DefinesFile ..."
    flutter build appbundle --release --dart-define-from-file=$DefinesFile

    Write-Host "Building Web (Cloudflare Pages / static host)..."
    flutter build web --release --dart-define-from-file=$DefinesFile

    Write-Host "Done. Android: build\app\outputs\bundle\release\app-release.aab"
    Write-Host "Web: build\web\"
    Write-Host "iOS (macOS): ./scripts/build-ios-release.sh  (see ios/DEPLOY.md)"
}
finally {
    Pop-Location
}
