# scripts/get-table-info.ps1
# ÐÐ°Ð·Ð½Ð°Ñ‡ÐµÐ½Ð¸Ðµ: ÐŸÐ¾Ð»ÑƒÑ‡ÐµÐ½Ð¸Ðµ Ð¼ÐµÑ‚Ð°Ð´Ð°Ð½Ð½Ñ‹Ñ… Google Ð¢Ð°Ð±Ð»Ð¸Ñ†Ñ‹
# Ð ÐµÐ¶Ð¸Ð¼Ñ‹: Summary (ÑÐ²Ð¾Ð´ÐºÐ°), Sheets (Ñ‚Ð¾Ð»ÑŒÐºÐ¾ Ð¸Ð¼ÐµÐ½Ð°), Full (Ð¿Ð¾Ð»Ð½Ð¾)
# Ð˜ÑÐ¿Ð¾Ð»ÑŒÐ·Ð¾Ð²Ð°Ð½Ð¸Ðµ: .\scripts\get-table-info.ps1 [-Mode Summary|Sheets|Full] [-Sheet Ð˜Ð¼ÑÐ›Ð¸ÑÑ‚Ð°]

param(
    [string]$Sheet,
    [ValidateSet("Summary", "Sheets", "Full")]
    [string]$Mode = "Summary"
)

Write-Host "=== ÐœÐ•Ð¢ÐÐ”ÐÐÐÐ«Ð• Ð¢ÐÐ‘Ð›Ð˜Ð¦Ð« ===" -ForegroundColor Cyan

try {
    # Ð—Ð°Ð³Ñ€ÑƒÐ¶Ð°ÐµÐ¼ ÐºÐ¾Ð½Ñ„Ð¸Ð³
    $configPath = Join-Path (Get-Location) "config.json"
    if (-not (Test-Path $configPath)) {
        throw "config.json Ð½Ðµ Ð½Ð°Ð¹Ð´ÐµÐ½!"
    }
    
    $config = Get-Content $configPath -Raw | ConvertFrom-Json
    
    if (-not $config.webAppUrl) {
        throw "webAppUrl Ð½Ðµ ÑƒÐºÐ°Ð·Ð°Ð½ Ð² config.json. Ð”Ð¾Ð±Ð°Ð²ÑŒ: `"webAppUrl`": `"https://script.google.com/.../exec`""
    }
    
    # Ð¤Ð¾Ñ€Ð¼Ð¸Ñ€ÑƒÐµÐ¼ URL Ð·Ð°Ð¿Ñ€Ð¾ÑÐ°
    $url = "$($config.webAppUrl)?action=info&mode=$Mode"
    if ($Sheet) { $url += "&sheet=$Sheet" }
    
    Write-Host "Ð—Ð°Ð¿Ñ€Ð¾Ñ: $url" -ForegroundColor DarkGray
    $info = Invoke-RestMethod -Uri $url -Method Get -TimeoutSec 30
    
    # Ð’Ñ‹Ð²Ð¾Ð´ Ñ€ÐµÐ·ÑƒÐ»ÑŒÑ‚Ð°Ñ‚Ð¾Ð²
    Write-Host "ID Ñ‚Ð°Ð±Ð»Ð¸Ñ†Ñ‹: $($config.spreadsheetId)" -ForegroundColor Gray
    Write-Host "Ð’ÑÐµÐ³Ð¾ Ð»Ð¸ÑÑ‚Ð¾Ð²: $($info.totalSheets)" -ForegroundColor Green
    
    switch ($Mode) {
        "Sheets" {
            Write-Host "`nðŸ“„ Ð¡ÐŸÐ˜Ð¡ÐžÐš Ð›Ð˜Ð¡Ð¢ÐžÐ’:" -ForegroundColor Yellow
            $info.sheetNames | ForEach-Object {
                Write-Host "  â€¢ $_" -ForegroundColor White
            }
        }
        
        "Summary" {
            Write-Host "`nðŸ“Š ÐÐšÐ¢Ð˜Ð’ÐÐ«Ð• Ð›Ð˜Ð¡Ð¢Ð«:" -ForegroundColor Cyan
            $info.sheets | Where-Object { $_.rows -gt 0 } | ForEach-Object {
                Write-Host "  â€¢ $($_.name)" -NoNewline
                Write-Host " [$($_.rows) ÑÑ‚Ñ€Ð¾Ðº, $($_.cols) ÐºÐ¾Ð»Ð¾Ð½Ð¾Ðº]" -ForegroundColor Gray
            }
            
            $emptySheets = $info.sheets | Where-Object { $_.rows -eq 0 }
            if ($emptySheets) {
                Write-Host "`nðŸ“­ ÐŸÐ£Ð¡Ð¢Ð«Ð• Ð›Ð˜Ð¡Ð¢Ð«:" -ForegroundColor DarkGray
                $emptySheets | ForEach-Object {
                    Write-Host "  â€¢ $($_.name)" -ForegroundColor DarkGray
                }
            }
        }
        
        "Full" {
            Write-Host "`nðŸ“ˆ Ð”Ð•Ð¢ÐÐ›Ð¬ÐÐÐ¯ Ð˜ÐÐ¤ÐžÐ ÐœÐÐ¦Ð˜Ð¯:" -ForegroundColor Yellow
            foreach ($sheetInfo in $info.sheets) {
                Write-Host "`nâ”€â”€â”€ $($sheetInfo.name) â”€â”€â”€" -ForegroundColor Magenta
                Write-Host "Ð¡Ñ‚Ñ€Ð¾Ðº: $($sheetInfo.rows)" -ForegroundColor White -NoNewline
                Write-Host " | ÐšÐ¾Ð»Ð¾Ð½Ð¾Ðº: $($sheetInfo.cols)" -ForegroundColor White
                
                if ($sheetInfo.dataRange) {
                    Write-Host "Ð”Ð¸Ð°Ð¿Ð°Ð·Ð¾Ð½: $($sheetInfo.dataRange)" -ForegroundColor Gray
                }
                
                if ($sheetInfo.headers -and $sheetInfo.headers.Count -gt 0) {
                    Write-Host "Ð—Ð°Ð³Ð¾Ð»Ð¾Ð²ÐºÐ¸: $($sheetInfo.headers -join ', ')" -ForegroundColor Cyan
                }
                
                if ($sheetInfo.sampleData -and $sheetInfo.sampleData.Count -gt 0) {
                    Write-Host "ÐŸÑ€Ð¸Ð¼ÐµÑ€ Ð´Ð°Ð½Ð½Ñ‹Ñ…:" -ForegroundColor DarkYellow
                    $sheetInfo.sampleData | ForEach-Object {
                        Write-Host "  â†’ $_" -ForegroundColor DarkGray
                    }
                }
            }
        }
    }
    
    # Ð”ÐµÑ‚Ð°Ð»Ð¸ Ð¿Ð¾ ÐºÐ¾Ð½ÐºÑ€ÐµÑ‚Ð½Ð¾Ð¼Ñƒ Ð»Ð¸ÑÑ‚Ñƒ
    if ($Sheet -and $info.sheets.Count -eq 1) {
        $s = $info.sheets[0]
        Write-Host "`nðŸ” Ð”Ð•Ð¢ÐÐ›Ð˜ ÐŸÐž Ð›Ð˜Ð¡Ð¢Ð£ '$Sheet':" -ForegroundColor Yellow
        Write-Host "Ð¡Ñ‚Ñ€Ð¾Ðº: $($s.rows)" -ForegroundColor White
        Write-Host "ÐšÐ¾Ð»Ð¾Ð½Ð¾Ðº: $($s.cols)" -ForegroundColor White
        Write-Host "Ð”Ð¸Ð°Ð¿Ð°Ð·Ð¾Ð½ Ð´Ð°Ð½Ð½Ñ‹Ñ…: $($s.dataRange)" -ForegroundColor Gray
        
        if ($s.headers -and $s.headers.Count -gt 0) {
            Write-Host "`nðŸ“‹ Ð—ÐÐ“ÐžÐ›ÐžÐ’ÐšÐ˜:" -ForegroundColor Cyan
            for ($i = 0; $i -lt $s.headers.Count; $i++) {
                Write-Host "  $($i+1). $($s.headers[$i])" -ForegroundColor White
            }
        }
    }
    
    # Ð¡Ð¾Ñ…Ñ€Ð°Ð½ÑÐµÐ¼ Ð² Ð»Ð¾Ð³
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $logFile = "logs/table_info_${Mode}_$timestamp.json"
    $info | ConvertTo-Json -Depth 5 | Out-File $logFile
    Write-Host "`nâœ… ÐœÐµÑ‚Ð°Ð´Ð°Ð½Ð½Ñ‹Ðµ ÑÐ¾Ñ…Ñ€Ð°Ð½ÐµÐ½Ñ‹ Ð² $logFile" -ForegroundColor Green
}
catch {
    Write-Host "âŒ ÐžÐ¨Ð˜Ð‘ÐšÐ: $_" -ForegroundColor Red
}
