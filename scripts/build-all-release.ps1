# Full release build: Android APK + AAB + Windows desktop (Khayat branding).
# Requires: Flutter on PATH, Android SDK, Visual Studio 2022 (Desktop C++ workload) for Windows.
# Usage:
#   .\scripts\build-all-release.ps1
#   .\scripts\build-all-release.ps1 -SkipTests

param(
    [string] $Environment = "prod",
    [switch] $SkipTests
)

$ErrorActionPreference = "Stop"
$Root = Join-Path $PSScriptRoot ".."
$helper = Join-Path $PSScriptRoot "build-flutter-with-defines.ps1"
$verify = Join-Path $PSScriptRoot "verify-before-push.ps1"

Push-Location $Root
try {
    $env:Path = "C:\flutter\bin;" + $env:Path

    if (-not $SkipTests) {
        Write-Host "== Pre-build verification (Flutter + API) ==" -ForegroundColor Cyan
        & $verify
    }

    flutter pub get
    flutter gen-l10n

    Write-Host "== Android App Bundle (Play Store) ==" -ForegroundColor Cyan
    if ($Environment -eq "prod") {
        & $helper build appbundle --release
    } else {
        & $helper $Environment build appbundle --release
    }
    Copy-Item "build\app\outputs\bundle\release\app-release.aab" "Khayat-release.aab" -Force

    Write-Host "== Android APK (side-load) ==" -ForegroundColor Cyan
    if ($Environment -eq "prod") {
        & $helper build apk --release
    } else {
        & $helper $Environment build apk --release
    }
    Copy-Item "build\app\outputs\flutter-apk\app-release.apk" "Khayat-android.apk" -Force

    Write-Host "== Windows desktop (x64) ==" -ForegroundColor Cyan
    if (Test-Path "build\windows") { Remove-Item "build\windows" -Recurse -Force }
    if ($Environment -eq "prod") {
        & $helper build windows --release
    } else {
        & $helper $Environment build windows --release
    }
    if ($LASTEXITCODE -ne 0) { throw "Windows build failed (exit $LASTEXITCODE)" }

    $winRelease = Join-Path $Root "build\windows\x64\runner\Release"
    if (-not (Test-Path $winRelease)) {
        throw "Windows build output not found at $winRelease"
    }
    $exe = Join-Path $winRelease "pride_v3.exe"
    if (-not (Test-Path $exe) -or (Get-Item $exe).Length -lt 1MB) {
        throw "Windows release exe missing or too small ($exe)"
    }

    $zipPath = Join-Path $Root "Khayat-windows-x64.zip"
    if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
    Compress-Archive -Path (Join-Path $winRelease "*") -DestinationPath $zipPath

    Write-Host ""
    Write-Host "Done:" -ForegroundColor Green
    Get-Item "Khayat-android.apk", "Khayat-release.aab", $zipPath | Format-Table Name, Length, LastWriteTime
    Write-Host "Windows folder: $winRelease"
    if (-not (Test-Path "android\key.properties")) {
        Write-Host "Note: android\key.properties missing - AAB/APK are debug-signed (not for Play upload)." -ForegroundColor Yellow
    }
}
finally {
    Pop-Location
}
