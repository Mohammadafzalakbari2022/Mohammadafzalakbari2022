# Apply all Prisma migrations to the production/staging Postgres (Supabase or other).
# Usage (PowerShell):
#   $env:DATABASE_URL = "postgresql://..."
#   .\scripts\migrate-production-db.ps1

$ErrorActionPreference = "Stop"

if (-not $env:DATABASE_URL) {
    Write-Error "Set DATABASE_URL to your Postgres connection string (Supabase Session pooler URI recommended)."
}

Push-Location (Join-Path $PSScriptRoot "..\api")
try {
    npm run prisma:migrate
    Write-Host "Migrations applied successfully."
}
finally {
    Pop-Location
}
