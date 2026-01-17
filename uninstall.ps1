# uninstall.ps1 - Remove Home Budget Core project

param(
    [switch]$Force
)

Write-Host "=== Home Budget Core - Uninstall ===" -ForegroundColor Cyan

$ProjectPath = "$HOME\Documents\GitHub\home-budget"
$ConfigPath = "$HOME\Documents\GitHub\home-budget\templates\config.json"

if (-not (Test-Path $ProjectPath)) {
    Write-Host "Project not found at: $ProjectPath" -ForegroundColor Yellow
    exit 0
}

if (-not $Force) {
    $confirm = Read-Host "Remove project folder and config? (y/N)"
    if ($confirm -ne 'y') {
        Write-Host "Cancelled." -ForegroundColor Yellow
        exit 0
    }
}

# Remove project folder
Remove-Item -Path $ProjectPath -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "[1] Project folder removed." -ForegroundColor Green

# Remove clasp auth (optional)
Write-Host "[2] To remove Google Clasp authorization, run: clasp logout" -ForegroundColor Gray

Write-Host "`n✅ Uninstall complete." -ForegroundColor Green
