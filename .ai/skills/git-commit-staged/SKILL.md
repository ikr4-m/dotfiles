---
name: git-commit-staged
description: >
  Suggests or executes a git commit based ONLY on currently staged files.
  Warns and stops immediately if no files are staged. Supports simple mode
  (title-only), detailed mode, and auto-commit mode (`git commit -m <title> [-m <desc>]`).
  Learns repository commit patterns via `git --no-pager log --oneline`. Executed without pager.
---

# Instructions

1. **Check Staged Changes First (Mandatory Guard)**:
   * Inspect staged changes strictly using non-pager command: `git --no-pager diff --cached`.
   * **No Staged Changes Guard**: If `git --no-pager diff --cached` yields no staged changes (empty output), warn the user explicitly (e.g., "No staged changes found. Please stage changes with `git add` before committing.") and **STOP IMMEDIATELY**. Do NOT attempt to commit or generate messages.
   * **No Proactive Staging**: If unstaged changes exist, DO NOT stage them automatically. Leave staging decisions strictly to the user.

2. **Learn Existing Repository Commit Patterns**:
   * Inspect recent commit history using `git --no-pager log --oneline -n 10`.
   * Analyze and match the repository's established commit message pattern (e.g., Conventional Commits `feat:`, `fix:`, scope usage, prefix style, casing, imperative mood, or specific human language).

3. **Pager-Free Execution**:
   * Execute ALL git commands strictly without interactive pagers (`git --no-pager ...` or `PAGER=cat`).

4. **Modes & Workflows**:

   * **Auto-Commit Mode**:
     * Triggered via `/git-commit-staged commit`, "commit it", "langsung commit", "do commit", or explicit request to perform the commit.
     * Generate the commit message based on staged changes and recent commit patterns.
     * Immediately execute:
       `git commit -m "<title>" -m "<body>"` (or `git commit -m "<title>"` if title-only).
     * Report the commit result to the user.

   * **Simple Mode**:
     * Triggered via `/git-commit-staged simple` or natural language requesting title-only (e.g., "simple message", "just title", "tanpa deskripsi").
     * Provide ONLY a concise commit header/title line (under 50-72 characters) without description body.

   * **Suggestion Mode (Default)**:
     * If no direct commit action is requested, present the generated commit title and detailed body for user review.
