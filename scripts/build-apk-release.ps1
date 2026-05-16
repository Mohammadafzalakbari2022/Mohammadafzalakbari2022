# Release APK with stacked dart-define-from-file. Output: build\app\outputs\flutter-apk\app-release.apk
# Usage:
#   .\scripts\build-apk-release.ps1
#   .\scripts\build-apk-release.ps1 -Environment staging

param(
    [string] $Environment = "prod"
)

$ErrorActionPreference = "Stop"
$helper = Join-Path $PSScriptRoot "build-flutter-with-defines.ps1"

Push-Location (Join-Path $PSScriptRoot "..")
try {
    flutter pub get
    flutter gen-l10n
    Write-Host "Building release APK, environment=$Environment ..."
    if ($Environment -eq "prod") {
        & $helper build apk --release
    } else {
        & $helper $Environment build apk --release
    }
    Write-Host "Done: build\app\outputs\flutter-apk\app-release.apk"
}
finally {
    Pop-Location
}
