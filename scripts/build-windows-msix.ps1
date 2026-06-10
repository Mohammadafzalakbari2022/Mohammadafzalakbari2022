# Build Windows release + MSIX package for Microsoft Store upload.
# Usage:
#   .\scripts\build-windows-msix.ps1
#   .\scripts\build-windows-msix.ps1 -Environment prod
#
# Requires:
#   - Flutter + Visual Studio 2022 (Desktop C++)
#   - config/msix_publisher.txt with Partner Center publisher CN (see .example)

param(
    [string] $Environment = "prod"
)

$ErrorActionPreference = "Stop"
$Root = Join-Path $PSScriptRoot ".."
$helper = Join-Path $PSScriptRoot "build-flutter-with-defines.ps1"
$publisherFile = Join-Path $Root "config\msix_publisher.txt"
$storeDir = Join-Path $Root "microsoft store ready files"

Push-Location $Root
try {
    $env:Path = "C:\flutter\bin;" + $env:Path

    $storeUpload = $false
    $publisher = $null
    if (Test-Path $publisherFile) {
        $publisher = (Get-Content $publisherFile -Raw).Trim()
        if ($publisher.StartsWith("#")) {
            $publisher = ($publisher -split "`n" | Where-Object { $_ -notmatch '^\s*#' -and $_.Trim() -ne '' } | Select-Object -First 1).Trim()
        }
        if ($publisher -match '^CN=') {
            $storeUpload = $true
        } else {
            Write-Host "Warning: config/msix_publisher.txt ignored (must start with CN=). Building sideload MSIX." -ForegroundColor Yellow
            $publisher = $null
        }
    } else {
        Write-Host "Note: config/msix_publisher.txt not found - building signed sideload MSIX (not Partner Center upload)." -ForegroundColor Yellow
        Write-Host "      For Store upload, copy config/msix_publisher.txt.example and add your Publisher ID." -ForegroundColor Yellow
    }

    $versionLine = (Select-String -Path "pubspec.yaml" -Pattern '^version:\s*').Line
    if (-not $versionLine) { throw "Could not read version from pubspec.yaml" }
    $versionPart = ($versionLine -replace '^version:\s*', '').Trim()
    $name, $build = $versionPart -split '\+', 2
    $msixVersion = "$name.$build"
    Write-Host "MSIX version: $msixVersion" -ForegroundColor Cyan

    flutter pub get

    Write-Host "== Windows release build ==" -ForegroundColor Cyan
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

    if ($storeUpload) {
        Write-Host "== MSIX package (Microsoft Store upload) ==" -ForegroundColor Cyan
        dart run msix:create --store --publisher $publisher --version $msixVersion --install-certificate false
    } else {
        Write-Host "== MSIX package (sideload / QA) ==" -ForegroundColor Cyan
        dart run msix:create --version $msixVersion --install-certificate false
    }
    if ($LASTEXITCODE -ne 0) { throw "msix:create failed (exit $LASTEXITCODE)" }

    $outRoot = Join-Path $Root "Khayat-windows.msix"
    if (-not (Test-Path $outRoot)) {
        throw "No Khayat-windows.msix in repo root after msix:create"
    }

    if (-not (Test-Path $storeDir)) {
        New-Item -ItemType Directory -Path $storeDir | Out-Null
    }

    $outStore = Join-Path $storeDir "Khayat-windows.msix"
    Copy-Item $outRoot $outStore -Force

    if (-not $storeUpload) {
        Write-Host "== Sideload certificate ==" -ForegroundColor Cyan
        $pubCache = if ($env:PUB_CACHE) { $env:PUB_CACHE } else { Join-Path $env:LOCALAPPDATA "Pub\Cache" }
        $msixDirs = Get-ChildItem (Join-Path $pubCache "hosted\pub.dev") -Filter "msix-*" -Directory -ErrorAction SilentlyContinue |
            Sort-Object Name -Descending
        $pfxSource = if ($msixDirs) {
            Join-Path $msixDirs[0].FullName "lib\assets\test_certificate.pfx"
        } else {
            $null
        }
        if ($pfxSource -and (Test-Path $pfxSource)) {
            $pfxDest = Join-Path $storeDir "Khayat-msix-dev-cert.pfx"
            $cerDest = Join-Path $storeDir "Khayat-msix-dev-cert.cer"
            Copy-Item $pfxSource $pfxDest -Force
            $pwd = ConvertTo-SecureString -String "1234" -AsPlainText -Force
            $cert = Import-PfxCertificate -FilePath $pfxDest -Password $pwd -CertStoreLocation Cert:\CurrentUser\My -Exportable
            Export-Certificate -Cert $cert -FilePath $cerDest -Force | Out-Null
            Write-Host "Exported $cerDest (install before MSIX on each PC)"
        } else {
            Write-Host "Warning: could not export sideload cert; run scripts\install-khayat-windows.ps1 as Admin" -ForegroundColor Yellow
        }
    }

    $zipPath = Join-Path $Root "Khayat-windows-x64.zip"
    if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
    Compress-Archive -Path (Join-Path $winRelease "*") -DestinationPath $zipPath
    Copy-Item $zipPath (Join-Path $storeDir "Khayat-windows-x64.zip") -Force

    Write-Host ""
    Write-Host "Done - Microsoft Store upload:" -ForegroundColor Green
    Get-Item $outRoot, $outStore, $zipPath | Format-Table Name, Length, LastWriteTime
    if ($storeUpload) {
        Write-Host "Upload Khayat-windows.msix in Partner Center -> Packages"
    } else {
        Write-Host "Sideload install (each PC, once as Admin): .\scripts\install-khayat-windows.ps1"
        Write-Host "For Microsoft Store: add config/msix_publisher.txt and re-run this script."
    }
    Write-Host "Sideload folder (all DLLs): $winRelease"
}
finally {
    Pop-Location
}
