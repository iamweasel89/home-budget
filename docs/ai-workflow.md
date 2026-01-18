# AI Workflow for Home Budget Project

## Quick Start
1. **Start new AI session** (Claude, GPT, etc.)
2. **Upload these files** in order:
   - `.ai/launch-blocks.md`
   - `.ai/async-context-break.md` 
   - `.ai/powershell-aliases.md` (if using PowerShell logging)
   - `.ai/logged-launch-blocks.md` (for complex operations)
3. **Say**: "I''m working on home-budget project, context loaded"
4. **Use these keywords**:
   - "ПБ" – request a Launch Block (executable commands)
   - "Logged ПБ" – request a logged version with error handling
   - "Check АРК" – remind AI about context break prevention

## Key Concepts
### Launch Blocks (ПБ)
Ready-to-execute commands. Example request: "Give me a ПБ to deploy the script"

### Async Context Break (АРК)
AI should NOT plan next steps until current action is confirmed successful.

### PowerShell Aliases
- `hblog` / `hb` – start logging
- `hbstop` / `hbe` – stop logging

## Project Context
- **Platform**: Google Sheets + Apps Script
- **Pattern**: Event Sourcing
- **Repo**: GitHub home-budget
- **Tools**: Clasp, Git, PowerShell/Bash
