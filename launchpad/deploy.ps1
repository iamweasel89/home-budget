# deploy.ps1 - Deployment script for Home Budget Core
param(
    [ValidateSet("Check", "Sync", "New")]
    [string]$Mode = "Check"
)

Write-Host "=== Home Budget Core - Deployment ===" -ForegroundColor Cyan
Write-Host "Mode: $Mode" -ForegroundColor Yellow

function Get-Config {
    $configPath = "templates\config.json"
    if (-not (Test-Path $configPath)) {
        Write-Host "❌ Config file not found: $configPath" -ForegroundColor Red
        Write-Host "Copy templates\config.json to project root and configure it." -ForegroundColor Yellow
        exit 1
    }
    
    try {
        $config = Get-Content $configPath -Raw | ConvertFrom-Json
        return $config
    }
    catch {
        Write-Host "❌ Failed to parse config.json: $_" -ForegroundColor Red
        exit 1
    }
}

function Test-Prerequisites {
    $errors = @()
    
    if (-not (Get-Command clasp -ErrorAction SilentlyContinue)) {
        $errors += "Clasp not installed. Run setup.ps1 first."
    }
    
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        $errors += "Node.js not installed."
    }
    
    if (-not (Test-Path "scripts\main.gs")) {
        $errors += "Main script (scripts\main.gs) not found."
    }
    
    if ($errors.Count -gt 0) {
        Write-Host "❌ Prerequisites check failed:" -ForegroundColor Red
        foreach ($err in $errors) {
            Write-Host "   - $err" -ForegroundColor Red
        }
        return $false
    }
    
    Write-Host "✅ Prerequisites OK" -ForegroundColor Green
    return $true
}

function Initialize-ClaspProject {
    param($config)
    
    if (Test-Path ".clasp.json") {
        Write-Host "✓ Clasp project already configured" -ForegroundColor Green
        return
    }
    
    Write-Host "Configuring Clasp project..." -ForegroundColor Yellow
    
    $sheetId = $config.spreadsheet_id
    if ([string]::IsNullOrWhiteSpace($sheetId)) {
        $sheetId = Read-Host "Enter Google Sheet ID"
    }
    
    $claspConfig = @{
        scriptId = $sheetId
        rootDir = "scripts"
    } | ConvertTo-Json
    
    [System.IO.File]::WriteAllText("$(Get-Location)\.clasp.json", $claspConfig, [System.Text.UTF8Encoding]::new($false))
    
    Write-Host "✅ Clasp project configured" -ForegroundColor Green
}

if (-not (Test-Prerequisites)) {
    exit 1
}

$config = Get-Config

switch ($Mode) {
    "Check" {
        Write-Host "`n📋 Checking project status..." -ForegroundColor Cyan
        
        if (Test-Path ".clasp.json") {
            Write-Host "✓ .clasp.json found" -ForegroundColor Green
            clasp status
        } else {
            Write-Host "⚠ .clasp.json not found (run with -Mode New to create)" -ForegroundColor Yellow
        }
        
        Write-Host "`n📊 Current configuration:" -ForegroundColor Cyan
        $config | Format-List | Out-String | Write-Host
    }
    
    "Sync" {
        Write-Host "`n🔄 Syncing changes to Google Sheets..." -ForegroundColor Cyan
        
        if (-not (Test-Path ".clasp.json")) {
            Write-Host "❌ .clasp.json not found. Run with -Mode New first." -ForegroundColor Red
            exit 1
        }
        
        clasp push -f
        
        Write-Host "`n✅ Sync completed!" -ForegroundColor Green
        Write-Host "Next: Refresh Google Sheets (F5) to see changes." -ForegroundColor Cyan
    }
    
    "New" {
        Write-Host "`n🚀 Full deployment (New installation)..." -ForegroundColor Cyan
        
        Initialize-ClaspProject -config $config
        
        if (-not (Test-Path "config.json")) {
            Copy-Item "templates\config.json" "config.json" -Force
            Write-Host "✓ Config copied to project root" -ForegroundColor Green
        }
        
        Write-Host "`n📤 Pushing scripts to Google Sheets..." -ForegroundColor Yellow
        clasp push -f
        
        Write-Host "`n🎉 DEPLOYMENT COMPLETE!" -ForegroundColor Green -BackgroundColor DarkBlue
        Write-Host "=========================================" -ForegroundColor Cyan
        Write-Host "Next steps in Google Sheets:" -ForegroundColor Cyan
        Write-Host "1. Open your Google Sheet:" -ForegroundColor Gray
        Write-Host "   https://docs.google.com/spreadsheets/d/$($config.spreadsheet_id)" -ForegroundColor White
        Write-Host "2. Refresh the page (F5)" -ForegroundColor Gray
        Write-Host "3. In the menu: 📊 Home Budget → Create Events Sheet" -ForegroundColor Gray
        Write-Host "4. Then: 📊 Home Budget → Add Initial Data" -ForegroundColor Gray
        Write-Host "=========================================" -ForegroundColor Cyan
    }
    
    default {
        Write-Host "❌ Unknown mode: $Mode" -ForegroundColor Red
        Write-Host "Available modes: Check, Sync, New" -ForegroundColor Yellow
    }
}
