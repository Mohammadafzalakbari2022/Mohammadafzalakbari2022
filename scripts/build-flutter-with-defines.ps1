# Run flutter with stacked --dart-define-from-file (plan-20). No .env files.
# Optional third layer: config/dart_defines_secrets.json (gitignored; copy from
# dart_defines_secrets.json.example for PRIDE_SENTRY_DSN and PRIDE_OWNER_PASSWORD_SHA256).
# Usage:
#   .\scripts\build-flutter-with-defines.ps1 build web --release
#   .\scripts\build-flutter-with-defines.ps1 staging build web --release

$ErrorActionPreference = "Stop"
$validEnvs = @("prod", "staging", "dev")

$environment = "prod"
$flutterArgs = @($args)
if ($args.Count -gt 0 -and $args[0] -in $validEnvs) {
    $environment = $args[0]
    $flutterArgs = @($args | Select-Object -Skip 1)
}

if ($flutterArgs.Count -eq 0) {
    throw @"
Pass a flutter command, e.g.
  .\scripts\build-flutter-with-defines.ps1 build web --release
  .\scripts\build-flutter-with-defines.ps1 staging build web --release
"@
}

$root = Join-Path $PSScriptRoot ".."
$configDir = Join-Path $root "config"

$files = @(
    (Join-Path $configDir "dart_defines_base.json")
    (Join-Path $configDir "dart_defines_$environment.json")
)

$secretsFile = Join-Path $configDir "dart_defines_secrets.json"
if (Test-Path $secretsFile) {
    $files += $secretsFile
}

foreach ($f in $files) {
    if (-not (Test-Path $f)) {
        throw "Defines file not found: $f (copy dart_defines_staging.json.example for staging)"
    }
}

# Merge stacked define files (same order as --dart-define-from-file) for build-time hooks.
$mergedDefines = @{}
foreach ($f in $files) {
    $layer = Get-Content -Raw -Path $f | ConvertFrom-Json
    foreach ($prop in $layer.PSObject.Properties) {
        $mergedDefines[$prop.Name] = [string]$prop.Value
    }
}

$defineArgs = foreach ($f in $files) {
    "--dart-define-from-file=$f"
}

# Windows: sentry_flutter always builds sentry-native; crashpad/breakpad need extra git
# fetches at configure time. When PRIDE_SENTRY_DSN is empty (default), skip native crash
# backend so release builds work offline (plan-20: no DSN => no Sentry init).
$isWindowsBuild = ($flutterArgs -join " ") -match '(?i)(^|\s)windows(\s|$)'
$sentryDsn = if ($mergedDefines.ContainsKey("PRIDE_SENTRY_DSN")) { $mergedDefines["PRIDE_SENTRY_DSN"].Trim() } else { "" }
if ($isWindowsBuild -and [string]::IsNullOrWhiteSpace($sentryDsn)) {
    $env:SENTRY_NATIVE_BACKEND = "none"
    Write-Host "PRIDE_SENTRY_DSN is empty: SENTRY_NATIVE_BACKEND=none for Windows native build."
}
if ($isWindowsBuild) {
    # CMake 4+ rejects legacy pdfium/pdfx DownloadProject scripts without this.
    $env:CMAKE_POLICY_VERSION_MINIMUM = "3.5"
}

Push-Location $root
try {
    $prevEap = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    & flutter @flutterArgs @defineArgs 2>&1 | ForEach-Object { $_ }
    $exit = $LASTEXITCODE
    $ErrorActionPreference = $prevEap
    if ($exit -ne 0) { exit $exit }
}
finally {
    Pop-Location
}
