---
name: takeover-my-terminal
description: Takes over the user's active tmux terminal session (default matching pattern `wasd-*`). Checks active tmux sessions without a pager, prompts the user if multiple sessions exist, and remembers the session name in memory context.
---

# Takeover My Terminal

Trigger this skill when the user requests to take over their active tmux terminal session, types "takeover my terminal", or asks to execute/monitor commands directly inside their active tmux context.

## Workflow

### 1. List Active Tmux Sessions (No Pager)
* Run command without pager to list running tmux sessions:
  `tmux list-sessions` (or `tmux ls`)
* Avoid any interactive pager or hanging subshell invocations.

### 2. Identify Target Session (`wasd-*`)
* Search the listed sessions for session names matching the default pattern `wasd-*` (e.g., `wasd-dev`, `wasd-main`, `wasd-1`).
* **Single Session Found / Single `wasd-*` Match**: Select this session immediately.
* **Multiple Sessions Found**: 
  * If there are multiple active tmux sessions, DO NOT guess or pick randomly.
  * Stop and ask the user which tmux session to attach/use:
    *(e.g., "Multiple active tmux sessions found: `wasd-1`, `wasd-2`, `work`. Which session would you like me to take over?")*

### 3. Store Session Context in Memory
* Once a session is confirmed, explicitly record and preserve the target tmux session name in conversation memory/context.
* Refer to this stored session name for all subsequent tmux interactions during the task.

### 4. Direct Terminal Interaction Guidelines
* Send commands using `tmux send-keys -t <session_name> "<command>" C-m`.
* Capture terminal output cleanly using `tmux capture-pane -pt <session_name>` without triggering pagers.
* Ensure all shell operations execute in non-interactive / non-paging mode (`PAGER=cat` or `--no-pager`).
