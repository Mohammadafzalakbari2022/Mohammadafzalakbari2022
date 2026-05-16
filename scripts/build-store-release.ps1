# Build release artifacts for Play Store, App Store, and Web.
# Usage:
#   .\scripts\build-store-release.ps1 -ApiBaseUrl "https://pride-api.onrender.com"

param(
    [Parameter(Mandatory = $true)]
    [string] $ApiBaseUrl
)

$ErrorActionPreference = "Stop"
$apiDefine = "API_BASE_URL=$ApiBaseUrl"

Push-Location (Join-Path $PSScriptRoot "..")
try {
    flutter pub get
    flutter gen-l10n

    Write-Host "Building Android App Bundle (Play Store)..."
    flutter build appbundle --release --dart-define=$apiDefine

    Write-Host "Building Web (Cloudflare Pages / static host)..."
    flutter build web --release --dart-define=$apiDefine

    Write-Host "Done. Android: build\app\outputs\bundle\release\app-release.aab"
    Write-Host "Web: build\web\"
    Write-Host "iOS (macOS): flutter build ipa --release --dart-define=$apiDefine"
}
finally {
    Pop-Location
}
