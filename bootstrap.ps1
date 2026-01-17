# bootstrap.ps1 - One-step installer for Home Budget Core
# Run this in PowerShell on a clean machine.

Write-Host "=== Home Budget Core - Bootstrap ===" -ForegroundColor Cyan
Write-Host "Downloading the full installer...`n" -ForegroundColor White

# 1. Download setup.ps1 from GitHub
$TempDir = "$env:TEMP\home-budget-bootstrap"
New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
Set-Location $TempDir

$SetupUrl = "https://raw.githubusercontent.com/iamweasel89/home-budget/main/launchpad/setup.ps1"
$SetupPath = "$TempDir\setup.ps1"

try {
    Invoke-WebRequest -Uri $SetupUrl -OutFile $SetupPath -ErrorAction Stop
    Write-Host "[1] Installer downloaded." -ForegroundColor Green
} catch {
    Write-Host "[1] ❌ Download failed. Check internet." -ForegroundColor Red
    exit 1
}

# 2. Run setup.ps1
Write-Host "[2] Launching installer..." -ForegroundColor Yellow
Write-Host "   It will check/install prerequisites and clone the project.`n" -ForegroundColor Gray
Start-Sleep -Seconds 1
.\setup.ps1

# 3. Final instructions
Write-Host "`n=== Bootstrap complete ===" -ForegroundColor Cyan
Write-Host "Project installed in: C:\Users\$env:USERNAME\Documents\GitHub\home-budget" -ForegroundColor White
Write-Host "`nNext:" -ForegroundColor Yellow
Write-Host "   cd 'C:\Users\$env:USERNAME\Documents\GitHub\home-budget'" -ForegroundColor Gray
Write-Host "   .\launchpad\deploy.ps1 -Mode New" -ForegroundColor Green
