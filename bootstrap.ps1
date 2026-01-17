<#  Этот блок комментария поглотит любые невидимые символы в начале файла #>

# bootstrap.ps1 - One-line installer
Write-Host "=== Home Budget Core - Bootstrap ===" -ForegroundColor Cyan
Write-Host "Downloading installer..." -ForegroundColor Yellow

$setupUrl = "https://raw.githubusercontent.com/iamweasel89/home-budget/main/launchpad/setup.ps1"
$tempFile = "$env:TEMP\setup_homebudget.ps1"

try {
    Invoke-WebRequest -Uri $setupUrl -OutFile $tempFile -ErrorAction Stop
    & $tempFile
} catch {
    Write-Host "❌ Failed to download installer." -ForegroundColor Red
    exit 1
}