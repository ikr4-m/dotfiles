# MULTI-AGENT ORCHESTRATION & GIT WORKTREE PLAYBOOK

When a task meets multi-agent trigger criteria (≥2 independent research threads, isolated multi-file mutations, or parallel option exploration), follow this execution playbook.

---

## 1. Orchestration Roles

- **Parent Agent (Orchestrator):** Acts as Engineering Manager. Defines subtask boundaries, spawns parallel sub-agents, reviews returning diffs, handles merge reconciliation, and teardowns worktrees. NEVER performs direct broad edits while sub-agents are active.
- **Child Sub-Agent (Worker):** Isolated worker focused on a single subtask within a dedicated git worktree or read-only research window. Recursion prohibited (sub-agents MUST NOT spawn further sub-agents).

---

## 2. Execution Workflows

### Pattern A: Parallel Research & Exploration
For exploring multiple independent codebase modules or comparing architectural options.

1. **Partition Query:** Split research into distinct, non-overlapping domains.
2. **Invoke Sub-Agents:** Launch parallel sub-agents (`research` or `self`) with specific target scope.
3. **Synthesize:** Collect sub-agent findings into parent context; summarize cleanly for user.

### Pattern B: Isolated Feature / Refactoring Swarm (Git Worktrees)
For concurrent multi-file edits or multi-branch feature work.

#### Step 1: Worktree Creation
Create isolated worktrees under `.worktrees/` directory:
```bash
git worktree add .worktrees/<feature-name> -b feat/<feature-name>
```

#### Step 2: Sub-Agent Dispatch
Invoke sub-agent pointing explicitly to the worktree path:
- **Target Path:** `.worktrees/<feature-name>/`
- **Scope:** Strictly confined to files within its worktree.

#### Step 3: Verification & Review
Upon sub-agent completion:
1. Inspect git status and diff in `.worktrees/<feature-name>`:
   ```bash
   rtk git -C .worktrees/<feature-name> status
   rtk git -C .worktrees/<feature-name> diff
   ```
2. Verify correctness and run targeted unit tests if applicable.

#### Step 4: Merge & Teardown
1. **Merge to Main Branch:**
   ```bash
   git merge feat/<feature-name> --no-ff -m "feat: merge <feature-name> sub-agent work"
   ```
2. **Cleanup Worktree and Branch:**
   ```bash
   git worktree remove .worktrees/<feature-name> --force
   git branch -d feat/<feature-name>
   ```

---

## 3. Failure Recovery & Conflict Resolution

- **Sub-Agent Execution Error:** If a sub-agent fails or emits incomplete changes, inspect logs silently, discard broken worktree (`git worktree remove --force`), and re-run or fall back to single-agent execution.
- **Merge Conflicts:** If git merge encounters conflicts, resolve manually in parent context or abort merge (`git merge --abort`), re-scoping subtask.
- **Recursion Guard:** Always set explicit boundary: sub-agents are workers only and must not invoke `invoke_subagent`.
