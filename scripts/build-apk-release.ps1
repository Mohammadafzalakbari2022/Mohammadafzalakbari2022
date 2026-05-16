# Release APK with production API (Render). Output: build\app\outputs\flutter-apk\app-release.apk
# Usage:
#   .\scripts\build-apk-release.ps1
#   .\scripts\build-apk-release.ps1 -DefinesFile config\dart_defines_prod.json

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
    Write-Host "Building release APK with $DefinesFile ..."
    flutter build apk --release --dart-define-from-file=$DefinesFile
    Write-Host "Done: build\app\outputs\flutter-apk\app-release.apk"
}
finally {
    Pop-Location
}
