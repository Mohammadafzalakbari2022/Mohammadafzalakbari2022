# Upload a locally built APK to GitHub Releases (when CI fails or for a hotfix).
# Prerequisite: gh auth login
# Usage:
#   .\scripts\build-apk-release.ps1
#   .\scripts\upload-apk-release.ps1
#   .\scripts\upload-apk-release.ps1 -Tag v1.0.1

param(
    [string] $Tag = "v1.0.1",
    [string] $ApkPath = "build\app\outputs\flutter-apk\app-release.apk"
)

$ErrorActionPreference = "Stop"
$root = Join-Path $PSScriptRoot ".."
$apk = Join-Path $root $ApkPath
$asset = Join-Path $root "Pride-android.apk"

if (-not (Test-Path $apk)) {
    throw "APK not found. Run: .\scripts\build-apk-release.ps1`nExpected: $apk"
}

Copy-Item -Force $apk $asset
Push-Location $root
try {
    gh release view $Tag 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Updating release $Tag ..."
        gh release upload $Tag $asset --clobber
    } else {
        Write-Host "Creating release $Tag ..."
        gh release create $Tag $asset `
            --title "Pride $Tag" `
            --notes-file docs/RELEASE_NOTES_TEMPLATE.md
    }
    Write-Host "Done. Customers can download:"
    Write-Host "https://github.com/Mohammadafzalakbari2022/Mohammadafzalakbari2022/releases/latest/download/Pride-android.apk"
}
finally {
    Pop-Location
    if (Test-Path $asset) { Remove-Item -Force $asset }
}
