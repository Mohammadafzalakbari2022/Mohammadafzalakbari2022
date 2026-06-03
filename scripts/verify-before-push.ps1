# Pre-push verification: Flutter (all targets compile-check via analyze/test) + Nest API.
# Run from repo root: .\scripts\verify-before-push.ps1
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

Write-Host '== Flutter pub get ==' -ForegroundColor Cyan
flutter pub get

Write-Host '== flutter gen-l10n ==' -ForegroundColor Cyan
flutter gen-l10n

Write-Host '== flutter analyze (errors only) ==' -ForegroundColor Cyan
$prevEap = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
$analyzeOut = (flutter analyze 2>&1 | Out-String)
$analyzeExit = $LASTEXITCODE
$ErrorActionPreference = $prevEap
if ($analyzeOut -match 'error -') {
    Write-Host $analyzeOut
    exit 1
}
if ($analyzeOut -match '(\d+) issues found') {
    Write-Host "Analyzer: $($Matches[1]) issues (no errors; warnings/infos only)"
}

Write-Host '== flutter test ==' -ForegroundColor Cyan
flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host '== API: npm ci + build + tests ==' -ForegroundColor Cyan
Push-Location api
try {
  npm ci
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  npx prisma generate
  npm run build
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  npm test
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  npm run test:e2e
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} finally {
  Pop-Location
}

Write-Host 'OK - safe to commit and push (run platform builds separately if releasing).' -ForegroundColor Green
