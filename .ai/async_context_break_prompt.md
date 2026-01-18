# Asynchronous Context Break (Асинхронный Разрыв Контекста, АРК)

**Target audience:** AI Assistant  
**Purpose:** Prevent context fragmentation in human-AI interaction  
**Russian term:** Асинхронный Разрыв Контекста (АРК)

---

## Problem Definition

**Asynchronous Context Break (АРК)** occurs when AI gives a task/command/question requiring user action AND immediately discusses what comes next. If the action fails, planned next steps are lost in context.

### Problem Structure

```
1. AI provides ACTION (requires user execution)
2. In same message: "After this we'll do X, Y, Z..."
3. ACTION fails or produces unexpected result
4. User reports the problem
5. AI focuses on troubleshooting
6. Plans "X, Y, Z" are forgotten/lost in conversation
```

### Consequences

- **Context drift:** Conversation branches, losing main thread
- **Lost focus:** Planned next steps disappear from context
- **Cognitive load:** User must remember "what was planned next"
- **Token waste:** User must restore context manually
- **Conversation fragmentation:** Multiple unfinished branches

---

## Examples of АРК

### Example 1: File Check

```
AI: "Open file config.json and check if field 'apiKey' exists.
     After that we'll configure OAuth and add refresh token."

User: "File config.json doesn't exist"

AI: [starts solving missing file problem,
     forgetting about OAuth and refresh token]
```

### Example 2: Package Installation

```
AI: "Install package: npm install lodash
     When installed — we'll create array utility,
     add tests and set up CI/CD."

User: [installation error — version conflict]

AI: [focuses on version conflict,
     utility/tests/CI-CD forgotten]
```

### Example 3: Launch Block (ПБ)

Launch Blocks (see `.ai/launch-blocks.md`) are a **specific case of АРК**:

```
AI: "Execute this ПБ:
     # 🧱 ПУСКОВОЙ БЛОК - deploy script
     clasp push
     clasp deploy
     
     After deployment we'll configure webhooks,
     set up monitoring and create documentation."

User: [ПБ fails at 'clasp push' step]

AI: [debugs deployment issue,
     webhooks/monitoring/docs forgotten]
```

**Key insight:** ПБ is just one type of action that can trigger АРК. The pattern applies to ANY action requiring user execution.

### Example 4: Simple Question

```
AI: "What's your Node.js version?
     When we know — we'll select compatible packages
     and configure build for your environment."

User: "I don't know how to check"

AI: [explains how to check version,
     forgetting about packages and build setup]
```

---

## Solution: STOP-WAIT-CONFIRM Pattern

### Rule for AI

After providing ANY action that requires user execution:

1. **STOP** — do not continue
2. **WAIT** — wait for execution result
3. **CONFIRM** — only after successful confirmation → proceed to next step

### What qualifies as "action requiring execution"

- Console command or script
- Launch Block (ПБ)
- File operation (open, check, edit)
- Question requiring user to investigate
- Any task where result is unknown until user acts

---

## Correct Behavior Examples

### ✅ CORRECT: Stop after action

```
AI: "Execute: git status"
    
    [STOP — waiting for result]

User: [sends output]

AI: "Good, I see uncommitted changes.
     Now let's make a commit..."
```

### ✅ CORRECT: Explicit checkpoint

```
AI: "This is checkpoint 2 of 5: Install dependencies
     
     Execute: npm install
     
     [After successful installation, we'll proceed to checkpoint 3]"

User: [confirms success]

AI: "Excellent. Checkpoint 3: Configure build system..."
```

### ✅ CORRECT: Clear next step mention (only if pre-agreed plan)

```
AI: "Step 2 of 5: Create project structure
     
     Execute this ПБ: [commands]
     
     After success → Step 3: Initialize Git"
```

**Note:** Mentioning next step is OK ONLY when:
- There's an explicit, pre-agreed multi-step plan
- Steps are numbered/clear
- User knows the full sequence

---

## Incorrect Behavior Examples

### ❌ INCORRECT: Running ahead

```
AI: "Execute: git status
     After this we'll commit, push to origin,
     create pull request and configure CI."

User: "git: command not found"

AI: [solves git installation problem,
     commit/push/PR/CI forgotten]
```

### ❌ INCORRECT: Planning without confirmation

```
AI: "Check if file exists: ls config.json
     
     Once confirmed, we'll parse the JSON,
     extract credentials, validate them,
     and integrate with the auth system."

User: "File doesn't exist"

AI: [АРК occurs — parsing/validation/integration lost]
```

### ❌ INCORRECT: Multiple futures in one message

```
AI: "Try this fix: [command]
     
     If it works — great, we'll move to optimization.
     If not — we'll try approach B.
     Also we should consider refactoring module X."

User: [command partially works but with warnings]

AI: [unclear which branch to follow,
     context fragmented]
```

---

## When АРК is Acceptable

### Exception: Pre-agreed sequential plan

If user and AI have explicitly agreed on a step-by-step plan, brief mentions of next steps are acceptable:

```
AI: "We agreed on 5 steps. Here's step 2:
     
     [ПБ or command]
     
     Next: step 3 (configure environment)"
```

**Requirements:**
- Plan was discussed and approved
- Steps are clearly numbered
- User knows the full sequence
- Mention is brief (one line max)

---

## АРК vs Other Patterns

### АРК is NOT the same as:

- **Multi-turn conversation:** АРК is about PREMATURE planning, not natural conversation flow
- **Helpful suggestions:** Offering alternatives AFTER failure is fine
- **Context building:** Explaining reasoning is different from planning unconfirmed actions

### АРК IS a problem when:

- AI commits to future actions before current action succeeds
- User must manually restore "what was planned"
- Conversation branches uncontrollably
- Mental model diverges between AI and user

---

## Relationship to Launch Blocks

Launch Blocks (ПБ) and АРК are **complementary concepts**:

- **ПБ** defines HOW to provide executable commands
- **АРК** defines WHEN to stop and wait for results

**Integration:**

```markdown
When providing a ПБ:
1. Generate the ПБ (following .ai/launch-blocks.md)
2. STOP (following АРК pattern)
3. Wait for execution result
4. Only after success/failure report → continue

Never provide ПБ AND plan next steps in same message.
```

---

## Practical Guidelines for AI

### Before sending a message with an action, ask:

1. **Does this require user to execute something?**
   - If YES → apply STOP-WAIT-CONFIRM

2. **Am I planning steps beyond current action?**
   - If YES → remove those plans, wait for current action result

3. **Is there a pre-agreed multi-step plan?**
   - If YES → brief next-step mention is OK
   - If NO → STOP after current action

### Mental checklist:

- ✅ One action per message (with rare exceptions)
- ✅ Wait for result before continuing
- ✅ Keep focus on current step
- ❌ Don't plan multiple futures
- ❌ Don't branch conversation prematurely
- ❌ Don't assume success before confirmation

---

## Summary

**АРК Pattern:**
```
Action → STOP → Wait → Result → Next Action
```

**NOT:**
```
Action + Future Plans → User Reports Problem → Context Lost
```

**Key principle:** Synchronize with user's reality. Don't run ahead of actual execution.

**Philosophy:** "One step at a time. Confirm before proceeding."

---

## Integration with home-budget Project

For the **home-budget** project, АРК prevention is especially important because:

- ПБ often involve multi-step operations (Clasp, Git, file operations)
- PowerShell/Bash commands can fail in environment-specific ways
- Debugging requires clear focus on specific failure point
- Project involves multiple tools (Google Apps Script, Git, Node.js)

When working with this project:
- Always apply STOP-WAIT-CONFIRM after ПБ
- Don't plan deployment steps before confirming current step
- Keep troubleshooting focused on immediate problem
- Resume planned sequence only after explicit user confirmation
