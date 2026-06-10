# Install Khayat Windows MSIX for sideload (no Microsoft Store).
# Run once as Administrator before installing Khayat-windows.msix.
#
# Usage (elevated PowerShell):
#   .\scripts\install-khayat-windows.ps1
#   .\scripts\install-khayat-windows.ps1 -MsixPath ".\Khayat-windows.msix"

param(
    [string] $MsixPath = ""
)

$ErrorActionPreference = "Stop"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$storeDir = Join-Path $Root "microsoft store ready files"
$pfxPath = Join-Path $storeDir "Khayat-msix-dev-cert.pfx"
$cerPath = Join-Path $storeDir "Khayat-msix-dev-cert.cer"

function Test-IsAdmin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsAdmin)) {
    Write-Host "Re-launching as Administrator..." -ForegroundColor Yellow
    $argList = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $PSCommandPath)
    if ($MsixPath) { $argList += "-MsixPath"; $argList += $MsixPath }
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
    Add-AppxPackage -Path $MsixPath
    Write-Host "Khayat installed successfully." -ForegroundColor Green
} else {
    Write-Host "Certificate installed. Double-click Khayat-windows.msix to finish setup." -ForegroundColor Green
}
