# Release APK with stacked dart-define-from-file. Output: build\app\outputs\flutter-apk\Pride.apk
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
    if ($LASTEXITCODE -ne 0) {
        throw "flutter build apk failed (exit $LASTEXITCODE). Do not install an old APK from build\app\outputs\flutter-apk\."
    }
    $apk = "build\app\outputs\flutter-apk\Pride.apk"
    $fallback = "build\app\outputs\flutter-apk\app-release.apk"
    if (-not (Test-Path $fallback)) {
        throw "APK not found: $fallback"
    }
    Copy-Item -Force $fallback $apk
    Write-Host "Done: $apk"
}
finally {
    Pop-Location
}
