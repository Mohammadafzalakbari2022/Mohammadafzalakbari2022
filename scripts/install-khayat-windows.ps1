# Install Khayat Windows MSIX for sideload (no Microsoft Store).
# Run once as Administrator before installing Khayat-windows.msix.
#
# Usage (elevated PowerShell):
#   .\scripts\install-khayat-windows.ps1
#   .\scripts\install-khayat-windows.ps1 -MsixPath ".\Khayat-windows.msix"
#   .\scripts\install-khayat-windows.ps1 -Replace   # force remove old package first

param(
    [string] $MsixPath = "",
    [switch] $Replace
)

$ErrorActionPreference = "Stop"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$storeDir = Join-Path $Root "microsoft store ready files"
$cerPath = Join-Path $storeDir "Khayat-msix-dev-cert.cer"
$packageName = "pridev3.khayat"

function Test-IsAdmin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-InstalledKhayatPackages {
    @(Get-AppxPackage -Name $packageName -ErrorAction SilentlyContinue)
}

function Remove-InstalledKhayatPackages {
    $installed = Get-InstalledKhayatPackages
    if ($installed.Count -eq 0) { return }
    Write-Host "Removing $($installed.Count) existing Khayat package(s)..." -ForegroundColor Cyan
    foreach ($pkg in $installed) {
        Write-Host "  $($pkg.PackageFullName)" -ForegroundColor DarkGray
        Remove-AppxPackage -Package $pkg.PackageFullName
    }
}

function Install-KhayatMsixPackage {
    param([string] $Path)
    $installed = Get-InstalledKhayatPackages
    if ($installed.Count -gt 0) {
        $versions = ($installed | ForEach-Object { $_.Version.ToString() }) -join ", "
        Write-Host "Installed Khayat version(s): $versions" -ForegroundColor DarkGray
    }

    if ($Replace) {
        Remove-InstalledKhayatPackages
        Add-AppxPackage -Path $Path
        return
    }

    try {
        Add-AppxPackage -Path $Path -ForceApplicationShutdown -ErrorAction Stop
        return
    } catch {
        $msg = $_.Exception.Message
        if ($msg -notmatch "80073cfb|same identity|already-installed package") {
            throw
        }
        Write-Host ""
        Write-Host "Windows blocked install: same package version but different build (0x80073cfb)." -ForegroundColor Yellow
        Write-Host "Removing the old package and reinstalling..." -ForegroundColor Yellow
    }

    Remove-InstalledKhayatPackages
    Add-AppxPackage -Path $Path
}

if (-not (Test-IsAdmin)) {
    Write-Host "Re-launching as Administrator..." -ForegroundColor Yellow
    $argList = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $PSCommandPath)
    if ($MsixPath) { $argList += "-MsixPath"; $argList += $MsixPath }
    if ($Replace) { $argList += "-Replace" }
    Start-Process powershell.exe -Verb RunAs -ArgumentList $argList
    exit 0
}

if (-not (Test-Path $cerPath)) {
    throw "Certificate not found: $cerPath. Run .\scripts\build-windows-msix.ps1 first."
}

Write-Host "Installing Khayat MSIX dev certificate to Trusted Root..." -ForegroundColor Cyan
certutil -addstore Root $cerPath | Out-Null
if ($LASTEXITCODE -ne 0) { throw "certutil failed (exit $LASTEXITCODE)" }

if (-not $MsixPath) {
    foreach ($candidate in @(
            (Join-Path $Root "Khayat-windows.msix"),
            (Join-Path $storeDir "Khayat-windows.msix")
        )) {
        if (Test-Path $candidate) { $MsixPath = $candidate; break }
    }
}

if ($MsixPath -and (Test-Path $MsixPath)) {
    Write-Host "Installing $MsixPath ..." -ForegroundColor Cyan
    Install-KhayatMsixPackage -Path $MsixPath
    Write-Host "Khayat installed successfully." -ForegroundColor Green
} else {
    Write-Host "Certificate installed. Double-click Khayat-windows.msix to finish setup." -ForegroundColor Green
}
