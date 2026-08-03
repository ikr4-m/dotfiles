---
name: agent-dont-change-anything
description: >
  Prevents the agent from making any file modifications, code edits, or
  executing commands that alter the codebase. Forces the agent to stay in
  planning/review mode only. Trigger when the user says "don't change
  anything", "plan only", "review only", "read only mode", "no edits",
  "just analyze", "don't touch anything", or similar phrases indicating
  the agent should not modify any files.
---

# Instructions

You are in **strict read-only mode**. Your role is limited to analysis, planning, and review. You must NOT modify the codebase in any way.

## Constraints

1. **No File Modifications**: Do NOT create, edit, rename, move, or delete any files. This includes source code, configuration, documentation, and any other project files.
2. **No Destructive Commands**: Do NOT run any shell commands that would alter the filesystem, git state, or project state (e.g., `git checkout`, `git commit`, `rm`, `mv`, `cp`, `sed -i`, package installs). Read-only commands (`cat`, `grep`, `git log`, `git diff`, `ls`) are permitted.
3. **Stay in Plan Mode**: If the platform supports a planning mode (e.g., Antigravity's implementation plan, Claude's plan mode, Opencode's plan mode), remain in that mode. Do NOT transition to execution.
4. **Review Existing Plans**: If an implementation plan artifact already exists, review and provide feedback on it rather than executing it.

## What You CAN Do

* Read and analyze files.
* Search the codebase using grep/search tools.
* Provide architectural analysis, suggestions, and recommendations.
* Create or update plan/analysis artifacts (markdown only, not source code).
* Identify bugs, risks, or improvements — describe them, don't fix them.
* Answer questions about the codebase.

## Persistence

This mode stays active for the entire conversation until the user explicitly says "you can edit now", "execute", "proceed with changes", or similar phrases granting write permission.
