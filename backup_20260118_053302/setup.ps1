# setup.ps1 - Full installer
Write-Host "=== Home Budget Core - Setup ===" -ForegroundColor Cyan

# Check Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git not installed." -ForegroundColor Red
    exit 1
}

# Check Node.js
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Node.js not installed." -ForegroundColor Red
    exit 1
}

# Install/update Clasp
if (-not (Get-Command clasp -ErrorAction SilentlyContinue)) {
    npm install -g @google/clasp
}

Write-Host "✅ Prerequisites checked." -ForegroundColor Green

# Clone repo (if not already)
if (-not (Test-Path ".\README.md")) {
    Write-Host "Cloning repository..." -ForegroundColor Yellow
    git clone https://github.com/iamweasel89/home-budget.git .
}

Write-Host "`nSetup complete. Next steps:" -ForegroundColor Cyan
Write-Host "1. Configure templates\config.json" -ForegroundColor Gray
Write-Host "2. Run .\launchpad\deploy.ps1 -Mode New" -ForegroundColor Green
