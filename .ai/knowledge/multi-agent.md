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
Create isolated worktrees under `.git_worktrees/` directory:
```bash
git worktree add .git_worktrees/<feature-name> -b feat/<feature-name>
```

#### Step 2: Sub-Agent Dispatch
Invoke sub-agent pointing explicitly to the worktree path:
- **Target Path:** `.git_worktrees/<feature-name>/`
- **Scope:** Strictly confined to files within its worktree.

#### Step 3: Verification & Review
Upon sub-agent completion:
1. Inspect git status and diff in `.git_worktrees/<feature-name>`:
   ```bash
   rtk git -C .git_worktrees/<feature-name> status
   rtk git -C .git_worktrees/<feature-name> diff
   ```
2. Verify correctness and run targeted unit tests if applicable.

#### Step 4: Merge & Teardown
1. **Merge to Main Branch:**
   ```bash
   git merge feat/<feature-name> --no-ff -m "feat: merge <feature-name> sub-agent work"
   ```
2. **Cleanup Worktree and Branch:**
   ```bash
   git worktree remove .git_worktrees/<feature-name> --force
   git branch -d feat/<feature-name>
   ```

### Pattern C: Hybrid / Dependency-Aware Orchestration (Sequential + Parallel)
For tasks that have blocking dependencies (e.g., Task B cannot start until Task A establishes an API contract or refactors a core module).

1. **Dependency Mapping:** Before invoking sub-agents, identify if subtasks are truly independent or if they block each other.
2. **Hybrid Execution:**
   - Execute the blocking/foundational task sequentially first (either via the parent orchestrator or a single dedicated sub-agent).
   - Wait for the foundational task to complete and verify its correctness.
   - Once the dependency is resolved, dispatch the remaining independent subtasks in parallel.
   - **Rule of Thumb:** Do not force full parallelization if tasks inherently depend on one another. Seamlessly transition between sequential and parallel execution as needed.

---

## 3. Failure Recovery & Conflict Resolution

- **Sub-Agent Execution Error:** If a sub-agent fails or emits incomplete changes, inspect logs silently, discard broken worktree (`git worktree remove --force`), and re-run or fall back to single-agent execution.
- **Merge Conflicts:** If git merge encounters conflicts, resolve manually in parent context or abort merge (`git merge --abort`), re-scoping subtask.
- **Recursion Guard:** Always set explicit boundary: sub-agents are workers only and must not invoke `invoke_subagent`.

---

## 4. Sub-Agent Constraints & Best Practices

- **Verifiable Reporting:** Sub-agents MUST return a structured, verifiable report of their actions and findings to the parent orchestrator upon completion. The orchestrator must be able to validate this report (e.g., checking diffs, running tests, or reviewing specific file modifications) before accepting the work.
- **Model Selection:** When invoking sub-agents, explicitly select the appropriate model based on task complexity:
  - **Lightweight Tasks:** Use the `flash` model (light, but capable) for straightforward tasks such as quick research, basic file reads, or simple file edits. Avoid `flash_lite` unless the task is extremely trivial.
  - **Heavy / Thinking Tasks:** Use the `pro` model for complex tasks that require deep reasoning, large refactors, architectural planning, or tricky debugging.
