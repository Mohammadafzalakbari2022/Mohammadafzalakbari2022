# Build release artifacts for Play Store, App Store, and Web.
# Usage:
#   .\scripts\build-store-release.ps1
#   .\scripts\build-store-release.ps1 -Environment staging

param(
    [string] $Environment = "prod"
)

$ErrorActionPreference = "Stop"
$helper = Join-Path $PSScriptRoot "build-flutter-with-defines.ps1"

Push-Location (Join-Path $PSScriptRoot "..")
try {
    flutter pub get
    flutter gen-l10n

    Write-Host "Building Android App Bundle (Play Store), environment=$Environment ..."
    if ($Environment -eq "prod") {
        & $helper build appbundle --release
    } else {
        & $helper $Environment build appbundle --release
    }

    Write-Host "Building Web (Cloudflare Pages via GitHub Actions) ..."
    if ($Environment -eq "prod") {
        & $helper build web --release
    } else {
        & $helper $Environment build web --release
    }

    Write-Host "Done. Android: build\app\outputs\bundle\release\app-release.aab"
    Write-Host "Web: build\web\"
    Write-Host "iOS (macOS): ./scripts/build-ios-release.sh $Environment"
}
finally {
    Pop-Location
}
