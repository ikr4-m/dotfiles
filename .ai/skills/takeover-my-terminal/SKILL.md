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

### 4. Pre-Flight State Check
* Before sending keys, inspect the foreground command running in the target pane:
  `tmux display-message -p -t <session_name> "#{pane_current_command}"`
* Safe shells: `bash`, `zsh`, `fish`, `sh`.
* If another program holds the pane (such as `vim`, `nvim`, `less`, `fzf`, `python`, or `sudo`), stop and ask the user before sending keys.

### 5. Safe Input Injection
* Clear any leftover text on the prompt first:
  `tmux send-keys -t <session_name> C-u`
* Send command text as raw literals to prevent keycode mangling:
  `tmux send-keys -t <session_name> -l "<command>"`
* Submit the command explicitly:
  `tmux send-keys -t <session_name> Enter`

### 6. Standardized Output Capture
* Capture pane output with unwrapped lines and recent history:
  `tmux capture-pane -pt <session_name> -J -S -500`
* Ensure all commands run in non-interactive mode (`PAGER=cat` or `--no-pager`).

### 7. Companion Panes for Long Tasks
* For long-running commands or persistent background processes, avoid blocking the user's primary prompt. Offer to split a pane or open a window inside the same session:
  `tmux split-window -t <session_name>`

### 8. Handling Long-Running Processes (No Polling Loops)
* **Strict Anti-Polling Rule:** Never loop or repeatedly call `capture-pane` across turns to wait for a command.
* **Deterministic Completion with `tmux wait-for`:**
  * Append a completion signal with a unique channel name when sending the command:
    `tmux send-keys -t <session_name> -l "<command> ; tmux wait-for -S <channel_id>"`
    `tmux send-keys -t <session_name> Enter`
  * Run `tmux wait-for <channel_id>` as a background command. It will block cleanly and notify the agent upon completion without burning context tokens.
* **Process Status Query:**
  * For a quick check, inspect `tmux display-message -p -t <session_name> "#{pane_current_command}"`. When the command finishes, it reverts from the program name to `bash` or `zsh`.
