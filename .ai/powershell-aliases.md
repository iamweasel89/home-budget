# PowerShell Aliases for Logging

**Target audience:** AI Assistant  
**Purpose:** Specification of EXISTING PowerShell aliases for logging  
**Status:** ACTIVE (aliases already exist in current session)  
**Load order:** After launch-blocks.md

## Available Aliases (REAL)

| Alias | Full Command | Parameters | Purpose |
|-------|--------------|------------|---------|
| hblog | Start-HomeBudgetLog | (none) | Start transcript logging to logs/console_YYYYMMDD_HHMMSS.log |
| hb | Start-HomeBudgetLog | (none) | Short alias for hblog |
| hbstop | Stop-HomeBudgetLog | (none) | Stop transcript logging |
| hbe | Stop-HomeBudgetLog | (none) | Short alias for hbstop |

## Usage in ПБ

\\\powershell
# 🧱 ПУСКОВОЙ БЛОК - example with EXISTING logging aliases
hblog
try {
    Write-Host 'Step 1: Doing something...'
} catch {
    Write-Host 'Error: ' -ForegroundColor Red
} finally {
    hbstop
}
\\\

## Log File Format
- Location: logs/ folder (auto-created on first use)
- Name: console_YYYYMMDD_HHMMSS.log
- Content: Full PowerShell transcript of commands and output

## Important Notes
1. **These aliases already exist** in the current PowerShell session
2. **No installation needed** - they work out of the box
3. **Cleanup**: Old logs can be manually deleted from logs/ folder
