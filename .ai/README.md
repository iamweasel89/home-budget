# AI Assistants Documentation

This directory contains prompts and instructions for working with AI assistants on the **home-budget** project.

---

## 📁 For Humans

If you're a human reading this, these files are **instructions for AI assistants** (Claude, GPT, etc.).

**To work with AI on this project:**
1. Open a new chat session with your AI assistant
2. Upload files from `.ai/` in the recommended order (see below)
3. Say: "I'm working on home-budget project, context loaded"
4. Start asking questions or requesting Launch Blocks

For detailed workflow, see: `docs/ai-workflow.md` *(to be created)*

---

## 🤖 For AI Assistants

Files in this directory are your working instructions for the **home-budget** project.

### Files Overview

| File | Purpose | Load Order |
|------|---------|------------|
| `launch-blocks.md` | How to generate executable command blocks (ПБ) | 1 |
| `async-context-break.md` | How to prevent context fragmentation (АРК) | 2 |

### Recommended Loading Sequence

When starting a new session:

1. **First:** `launch-blocks.md`
   - Defines what Launch Blocks (ПБ) are
   - Rules for generating executable commands
   - Referenced by other files

2. **Second:** `async-context-break.md`
   - Defines Asynchronous Context Break (АРК) pattern
   - References ПБ as a specific case
   - Critical for maintaining conversation focus

### Key Concepts

**Launch Block (ПБ) = Пусковой Блок**
- Ready-to-execute command or set of commands
- User copies and runs without modification
- See `launch-blocks.md` for full specification

**АРК = Асинхронный Разрыв Контекста**
- Problem: AI plans next steps before current action completes
- Solution: STOP-WAIT-CONFIRM pattern
- See `async-context-break.md` for full specification

### Working with This Project

**Project specifics:**
- Platform: Google Apps Script (JavaScript), PowerShell, Bash
- Primary tools: Clasp, Git, Google Sheets API
- Root: `C:\Users\user\Documents\GitHub\home-budget\`

**When generating ПБ:**
- Account for project paths and structure
- Use platform-appropriate commands
- Follow АРК pattern (stop after providing ПБ)

**Key directories:**
- `scripts/` — Apps Script code
- `templates/` — Configuration files
- `docs/` — Project documentation
- `logs/` — Operation logs (if applicable)

---

## 📝 File Naming Convention

All files in `.ai/` use **kebab-case** (lowercase with dashes):
- ✅ `launch-blocks.md`
- ✅ `async-context-break.md`
- ❌ NOT: `launch_blocks.md`, `LaunchBlocks.md`

---

## 🔄 Updating Instructions

When updating AI instructions:
1. Edit the relevant `.ai/*.md` file
2. Test in a new AI session
3. Commit changes with clear message:
```bash
   git add .ai/
   git commit -m "docs(ai): updated [concept] - [what changed]"
```

---

## 📚 Future Files (Planned)

Files that may be added:
- `powershell-aliases.md` — PowerShell logging aliases
- `logged-launch-blocks.md` — ПБ with error logging wrapper
- `examples/` — Example successful AI interactions

---

## 🎯 Philosophy

This directory enables:
- **Quick context restoration** for AI in new sessions
- **Consistent behavior** across different AI models
- **Token efficiency** through structured, focused prompts
- **Knowledge preservation** of best interaction practices

**Target:** Any LLM should be able to work effectively on this project by loading these files.

