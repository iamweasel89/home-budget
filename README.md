# Home Budget Core
A universal personal finance system based on an event journal.

> **Cheatsheet:**
> - **One‑line install:** `iwr -useb https://raw.githubusercontent.com/iamweasel89/home-budget/main/bootstrap.ps1 | iex`
> 1.  Setup: `./setup.ps1`
> 2.  Deploy: `./launchpad/deploy.ps1 -Mode New`
> 3.  Update: `./launchpad/deploy.ps1 -Mode Sync`
> 4.  [Full instructions](#-quick-start)

## Architecture
- **Core:** `Events` sheet (journal of all operations).
- **Model:** Event sourcing (state is calculated from event history).
- **Goal:** Calculate free money available at the current moment.

## Entities
- **Event:** id, timestamp, type, amount, account_id, reference_id, target_id, category, description, status.

## Current status
- [x] Project initialization
- [x] Google Sheet creation
- [x] Events sheet creation
- [ ] Adding initial data
- [ ] Creating a dashboard

## 🚀 Quick start

### Setup on a new machine
1.  Ensure you have:
    -   Git
    -   Node.js LTS
    -   PowerShell 5+
2.  Download and run the setup script:
    ```powershell
    # Copy setup.ps1 from the repository or run:
    .\setup.ps1
    ```
    The script will:
    -   Check/install Clasp.
    -   Clone the repository.
    -   Configure (ask for Sheet ID, open browser for Google account selection).

### First deployment
1.  Navigate to the project folder:
    ```powershell
    cd "C:\Users\user\Documents\GitHub\home-budget"
    ```
2.  Run full deployment:
    ```powershell
    .\launchpad\deploy.ps1 -Mode New
    ```
3.  **In Google Sheets:**
    -   Refresh the page (F5).
    -   In the menu, select: 📊 Home Budget → Create Events Sheet.
    -   Then: 📊 Home Budget → Add Initial Data.

### Daily work
-   **Editing scripts:** Modify files in the `scripts/` folder.
-   **Deploy changes:**
    ```powershell
    .\launchpad\deploy.ps1 -Mode Sync
    ```
-   **Verification:** Refresh the sheet — changes will apply.

## 📂 Project structure
- home-budget/
  - docs/               # Documentation
  - scripts/            # Google Apps Script code
  - templates/          # Configuration (config.json)
  - launchpad/          # Launch scripts
    - deploy.ps1       # Deployment (Check/Sync/New)
    - setup.ps1        # Fresh installation
  - .gitignore
  - README.md

## 🔧 Management commands
| Action | Command |
|--------|---------|
| Check status | `.\launchpad\deploy.ps1 -Mode Check` |
| Update script | `.\launchpad\deploy.ps1 -Mode Sync` |
| Full rebuild | `.\launchpad\deploy.ps1 -Mode New` |
| Setup on new machine | `.\setup.ps1` |

## 📊 What's next?
-   Creating a dashboard to calculate "Free money now".
-   Automating Events sheet creation via script.
-   Adding family mode (multiple profiles).


