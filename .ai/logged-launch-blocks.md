# Logged Launch Blocks (Logged ПБ)

**Target audience:** AI Assistant  
**Purpose:** Extended Launch Blocks with built-in error logging and recovery  
**Related:** launch-blocks.md (base concept), powershell-aliases.md (tools)

## Concept
A **Logged ПБ** is a Launch Block wrapped with logging for recoverability.

## Structure

\\\powershell
# [1] SETUP - Start logging
hblog

# [2] EXECUTION (numbered steps)
Write-Host '[STEP 1/3] Doing step 1...'
# Command 1...

Write-Host '[STEP 2/3] Doing step 2...'  
# Command 2...

Write-Host '[STEP 3/3] Doing step 3...'
# Command 3...

# [3] TEARDOWN - Stop logging
hbstop
\\\

## Recovery Flow
1. User executes Logged ПБ
2. If fails at step X → log shows exact error
3. User sends log → AI analyzes → creates new ПБ from step X

## When to Use
- Complex operations (3+ commands)
- High-risk operations (deployment, data changes)
- First-time execution of new ПБ
