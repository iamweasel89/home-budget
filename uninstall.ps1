# uninstall.ps1 - Remove Home Budget Core project
param([switch]$Force)

Write-Host "=== Home Budget Core - Uninstall ===" -ForegroundColor Cyan

$ProjectPath = "$HOME\Documents\GitHub\home-budget"

if (-not (Test-Path $ProjectPath)) {
    Write-Host "Project not found at: $ProjectPath" -ForegroundColor Yellow
    exit 0
}

if (-not $Force) {
    $confirm = Read-Host "Remove project folder and config? (y/N)"
    if ($confirm -ne "y") {
        Write-Host "Cancelled." -ForegroundColor Yellow
        exit 0
    }
}

# Delete via separate process to avoid lock
Start-Process powershell -ArgumentList "-Command Remove-Item -LiteralPath '$ProjectPath' -Recurse -Force -ErrorAction SilentlyContinue" -Wait -NoNewWindow

if (-not (Test-Path $ProjectPath)) {
    Write-Host "[1] Project folder removed." -ForegroundColor Green
} else {
    Write-Host "[1] ❌ Could not remove folder (may be locked). Try manual deletion." -ForegroundColor Red
}

Write-Host "[2] To remove Google Clasp authorization, run: clasp logout" -ForegroundColor Gray
Write-Host "`n✅ Uninstall complete." -ForegroundColor Green
