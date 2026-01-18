# Launch Blocks (Пусковые Блоки, ПБ)

**Target audience:** AI Assistant  
**Purpose:** Instructions for generating executable command blocks  
**Russian term:** Пусковой Блок (ПБ)

---

## Definition

A **Launch Block (ПБ)** is a ready-to-execute command or set of commands that the user can copy and run without modification.

### Key characteristics

- **Executability:** Commands work "as is", no modification needed
- **Atomicity:** One ПБ = one complete operation
- **Proven:** Commands have been tested in the project
- **Deterministic:** Predictable, known result

### What ПБ is NOT

- NOT a theoretical explanation
- NOT a set of options to choose from
- NOT incomplete code requiring further decisions
- NOT a conceptual discussion

---

## Format
```bash
# 🧱 ПУСКОВОЙ БЛОК - clear operation name
[ready command 1]
[ready command 2]
[ready command 3]

# Verification (optional)
[verification command]
```

---

## Core Principles

### 1. Ready Commands Only

- Only specific commands ready for copy-paste
- Already tested in the real project
- Work when executed directly

### 2. Atomicity

- One ПБ = one finished operation
- No additional decisions required
- Self-contained and complete

### 3. No Theory

- Minimum explanations
- Maximum action
- No "you could do this or that"

### 4. Proven

- Commands have already worked in the project
- All dependencies are known
- Permissions, paths, variables are accounted for

---

## Rules for AI

### WHEN USER SAYS "ПБ":

1. Generate only ready console commands (bash/PowerShell)
2. No theoretical explanations, only actions
3. Format: clear title + commands for copying
4. Atomicity: one ПБ solves one task completely

### WHEN USER DOES NOT SAY "ПБ":

- You can discuss, suggest options, explain
- Theoretical foundations are allowed
- You can propose choice of approaches

---

## Atomicity Balance

One ПБ should contain a **semantically complete operation** understandable to a human.

### Criteria:

1. **Semantic integrity:**
   - ✅ "Create project structure"
   - ❌ "Create folder" + "Create file" (separately)

2. **Recoverability:**
   - If ПБ fails — it's clear WHAT didn't work
   - Can repeat only this piece

3. **Cognitive load:**
   - User remembers WHY they're doing this
   - No need to keep 10 micro-steps in mind

### Typical range: 3-7 commands

- Less than 3 → possibly too atomic
- More than 7 → risk of context break on error

**Exception:** Single command if it's a complete operation (git clone, npm install)

---

## Examples

### ✅ CORRECT ПБ:
```bash
# 🧱 ПУСКОВОЙ БЛОК - create project structure
mkdir -p scripts/{main,utils,tests}
touch scripts/main/index.js scripts/utils/helpers.js
echo '// Project initialized' > scripts/main/index.js

# Verification
ls -R scripts/
```

### ❌ INCORRECT - Too theoretical:
```
First, you need to create folders for the project...
I recommend setting up the structure...
You could organize files like this...
```

### ❌ INCORRECT - Too atomic:
```bash
# ПБ-1: Create scripts folder
mkdir scripts

# ПБ-2: Create main subfolder
mkdir scripts/main

# ПБ-3: Create index file
touch scripts/main/index.js
```

### ❌ INCORRECT - Too complex:
```bash
# ПБ: Complete project initialization
mkdir ... && git init && npm init && clasp create && 
npm install ... && git add . && git commit && clasp push &&
# ... 20+ more commands
```

---

## Platform-Specific Commands

ПБ contains ready commands for the project's target platform.
Platform is specified in project metadata (e.g., `templates/config.json`).

### Examples by platform:

**Bash:**
```bash
mkdir -p dir && touch dir/file.txt
```

**PowerShell:**
```powershell
New-Item -ItemType Directory -Path dir -Force
New-Item -ItemType File -Path dir/file.txt
```

**Node.js:**
```javascript
const fs = require('fs');
fs.mkdirSync('dir', {recursive: true});
```

The principle: show ready commands, not theoretical explanations.

---

## Philosophy

**"We've passed the discussion stage. Here's the ready solution — take it and do it."**

**Formula:** Copy → Paste → Execute → Result

---

## When to Generate ПБ

Generate ПБ when:
- ✅ User explicitly says "ПБ"
- ✅ Solution is clear and doesn't require discussion
- ✅ User needs executable commands, not theory
- ✅ The operation has been tested/proven

Do NOT generate ПБ when:
- ❌ Multiple solution approaches exist (discuss first)
- ❌ User's requirements are unclear (clarify first)
- ❌ Decision requires user's input
- ❌ This is a conceptual question

---

## Integration with Project

For the **home-budget** project:
- Platform: Google Apps Script (JavaScript), PowerShell, Bash
- Primary operations: Clasp deployment, table manipulation, script sync
- ПБ should account for project paths and structure

When generating ПБ for this project, consider:
- Project root: `C:\Users\user\Documents\GitHub\home-budget\`
- Scripts location: `scripts/`
- Configuration: `templates/config.json`
- Logs: `logs/` (if applicable)
