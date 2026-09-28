# MULTI-AGENT ORCHESTRATION & GIT WORKTREE PLAYBOOK

When a task meets multi-agent trigger criteria, follow this execution playbook. Before spawning any sub-agents, always run the Pre-Spawn Orthogonality Gate (Section 2).

---

## 1. Orchestration Roles

- **Parent Agent (Orchestrator):** Acts as Engineering Manager. Defines subtask boundaries, runs the orthogonality gate, freezes interface contracts, spawns sub-agents, reviews returning diffs, handles merge reconciliation, and teardowns worktrees. NEVER performs direct broad edits while sub-agents are active.
- **Child Sub-Agent (Worker):** Isolated worker focused on a single subtask within a dedicated git worktree or read-only research window. Recursion prohibited (sub-agents MUST NOT spawn further sub-agents).
- **Scout Agent (Pre-Computation):** Optional, time-boxed read-only agent spawned before committing to multi-agent split. Maps the dependency graph and file ownership to validate orthogonality. See Pattern E.
- **Integrator Agent (Post-Merge):** Optional specialized agent that resolves git conflicts, runs cross-branch tests, and fixes integration bugs after sub-agents complete. See Pattern F.

---

## 2. Pre-Spawn Orthogonality Gate (Mandatory)

Before launching parallel sub-agents with worktrees, the parent MUST pass this checklist. If any check fails, do NOT parallelize. Use sequential execution or single-agent mode instead.

### Checklist

1. **File Disjointness:** List all files each sub-agent will touch. If any file appears in more than one sub-agent's scope, STOP. Either re-scope the tasks or run sequentially.
2. **Interface Freeze:** Identify all shared boundaries (function signatures, API contracts, data types, config schemas) between sub-agent scopes. These MUST be frozen before spawning. No sub-agent may modify a frozen interface.
3. **Zero Runtime Dependencies:** No sub-agent's work should depend on another sub-agent's in-progress output. If Task B needs the result of Task A, they are sequential, not parallel.
4. **Independent Testability:** Each sub-agent's work must be testable in isolation within its own worktree without needing code from sibling worktrees.

### If Checklist Fails

- **Shared files?** Merge into one sub-agent scope, or run sequentially.
- **Unstable interfaces?** Use Pre-Flight Contract Mocks (Pattern D) to freeze them first.
- **Hidden dependencies?** Spawn a Scout Agent (Pattern E) to map the real dependency graph before deciding.

---

## 3. Execution Workflows

### Pattern A: Parallel Research & Exploration
For exploring multiple independent codebase modules or comparing architectural options.

1. **Partition Query:** Split research into distinct, non-overlapping domains.
2. **Invoke Sub-Agents:** Launch parallel sub-agents (`research` or `self`) with specific target scope.
3. **Synthesize:** Collect sub-agent findings into parent context, summarize cleanly for user.

### Pattern B: Isolated Feature / Refactoring Swarm (Git Worktrees)
For concurrent multi-file edits where the orthogonality gate passes cleanly.

#### Step 1: Worktree Creation
Create isolated worktrees under `.git_worktrees/` directory:
```bash
git worktree add .git_worktrees/<feature-name> -b feat/<feature-name>
```

#### Step 2: Sub-Agent Dispatch
Invoke sub-agent pointing explicitly to the worktree path:
- **Target Path:** `.git_worktrees/<feature-name>/`
- **Scope:** Strictly confined to files within its worktree.
- **Frozen Contracts:** Include the frozen interface specs in the sub-agent's prompt so it develops against stable boundaries.

#### Step 3: Verification & Review
Upon sub-agent completion:
1. Inspect git status and diff in `.git_worktrees/<feature-name>`:
   ```bash
   git -C .git_worktrees/<feature-name> status
   git -C .git_worktrees/<feature-name> diff
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

### Pattern D: Pre-Flight Contract Mocks
For parallel tasks that share boundaries (APIs, types, schemas) but are otherwise independent in implementation.

Use this when the orthogonality gate fails on "Interface Freeze" but passes on "File Disjointness."

1. **Identify Shared Boundaries:** List every function signature, data type, API endpoint, or config schema that spans multiple sub-agent scopes.
2. **Generate Mock Contracts:** Before spawning any worker, create a minimal, frozen contract definition. This can be:
   - A stub file with type signatures and docstrings (no implementation)
   - An interface definition (TypeScript `.d.ts`, Python Protocol class, OpenAPI spec, etc.)
   - A plain-text contract block embedded in the sub-agent's prompt
3. **Freeze and Distribute:** Include the frozen contract in every sub-agent's initial prompt. Agents develop against this contract. No agent may unilaterally change a frozen interface.
4. **Contract Violation = Fail Fast:** If a sub-agent discovers the frozen contract is wrong or insufficient, it MUST stop and report back to the parent immediately. Do NOT attempt to renegotiate with peer agents. The parent re-freezes and re-dispatches.

### Pattern E: Scout Pre-Computation Phase
For complex or unfamiliar codebases where the parent cannot confidently assess orthogonality from surface-level analysis.

1. **Spawn Scout:** Launch a single, time-boxed `research` sub-agent (use `flash` model) with a strict directive:
   - Map which files each proposed subtask would touch
   - Identify shared dependencies, imports, and cross-module calls
   - Flag any hidden coupling (shared global state, config files, database migrations)
   - Return a structured dependency report
2. **Time Box:** Scout MUST complete within a bounded scope (e.g., "read at most 20 files, return within 2 minutes").
3. **Gate Decision:** Based on Scout's report, the parent decides:
   - **Green (orthogonal):** Proceed with parallel Pattern B.
   - **Yellow (shared interfaces):** Use Pattern D (Pre-Flight Contract Mocks) first, then parallelize.
   - **Red (tightly coupled):** Use Pattern C (sequential) or single-agent mode.

### Pattern F: Relay Baton (Pipeline Orchestration)
For tasks that decompose into a natural sequence of specialized phases (e.g., scaffolding, implementation, testing, documentation).

Instead of parallel worktrees, structure execution as an assembly line where each phase builds on the previous one's committed output.

1. **Define Pipeline Stages:** Break the task into ordered phases. Each phase has a clear input artifact and output artifact.
   - Example: `Scaffolder -> Implementer -> Tester -> Documenter`
2. **Execute Sequentially with Handoff:** Each agent works in the same worktree (or a single branch). When Agent A finishes:
   - Agent A commits its work.
   - Parent verifies the commit.
   - Parent dispatches Agent B with the committed state as its starting point.
3. **Specialization:** Each agent in the pipeline can use a different model suited to its phase (e.g., `flash` for scaffolding, `pro` for complex implementation).
4. **When to Use:** Prefer this over Pattern B when tasks have a clear execution order and each phase produces artifacts the next phase consumes.

---

## 4. Post-Merge Integration (Dedicated Integrator Agent)

When multiple sub-agents complete parallel work (Pattern B), the merge phase is often the most context-heavy and conflict-prone step. For complex merges involving 3+ worktrees or high-risk integration points, delegate this to a specialized Integrator Agent instead of handling it in the parent context.

### Integrator Workflow
1. **Trigger:** Parent detects that 2+ worktrees have completed and their branches are ready to merge.
2. **Spawn Integrator:** Launch a `self` sub-agent (use `pro` model) with:
   - List of all branches to merge (in order of dependency)
   - The frozen interface contracts from Pattern D
   - Instructions to resolve conflicts, run cross-branch tests, and fix integration edge cases
3. **Integrator Scope:**
   - Merge branches one at a time into a dedicated integration branch
   - Resolve any git conflicts
   - Verify that merged code compiles and passes available tests
   - Report a structured integration summary to parent
4. **Parent Review:** Parent reviews the Integrator's final merged branch before accepting it into the main branch.

### When to Skip the Integrator
- Simple merges (2 worktrees, zero file overlap): Parent handles directly.
- Research-only tasks (Pattern A): No merge needed.

---

## 5. Asynchronous State Beacons

When parallel sub-agents operate in worktrees and encounter unexpected changes that could affect siblings (new dependency discovered, environment quirk, build config change), they may emit a structured beacon to the parent agent instead of attempting peer-to-peer communication.

### Beacon Protocol
- **Direction:** Child -> Parent only. No peer-to-peer messaging.
- **Format:** Structured, actionable payload. Not conversational.
  ```
  BEACON: { type: "contract_change" | "blocker" | "environment_warning", 
             summary: "<one-line description>",
             affected_files: ["<file paths>"],
             action_needed: "<what parent should do>" }
  ```
- **Parent Response:** Upon receiving a beacon, the parent evaluates whether sibling agents need to be notified. If yes, the parent relays the relevant information to affected siblings via their existing `send_message` channel.
- **No Chat Loops:** Beacons are fire-and-forget. Sub-agents do NOT wait for acknowledgment. If a beacon requires a response, the sub-agent pauses and waits for the parent to re-dispatch.

### Key Constraint
Beacons flow through the parent, not peer-to-peer. The parent maintains full architectural awareness and decides which information to relay to which sibling. This preserves the hub-and-spoke model while reducing the parent's need to actively poll sub-agents for status.

---

## 6. Failure Recovery & Conflict Resolution

- **Sub-Agent Execution Error:** If a sub-agent fails or emits incomplete changes, inspect logs silently, discard broken worktree (`git worktree remove --force`), and re-run or fall back to single-agent execution.
- **Merge Conflicts:** If git merge encounters conflicts, either delegate to the Integrator Agent (Section 4) or resolve manually in parent context. Abort merge (`git merge --abort`) and re-scope subtask if conflicts are structural.
- **Contract Violation:** If a sub-agent reports that a frozen contract is wrong, halt all dependent sub-agents, update the contract at the parent level, and re-dispatch affected workers.
- **Recursion Guard:** Always set explicit boundary: sub-agents are workers only and must not invoke `invoke_subagent`.

---

## 7. Sub-Agent Constraints & Best Practices

- **Verifiable Reporting:** Sub-agents MUST return a structured, verifiable report of their actions and findings to the parent orchestrator upon completion. The orchestrator must be able to validate this report (e.g., checking diffs, running tests, or reviewing specific file modifications) before accepting the work.
- **Model Selection:** When invoking sub-agents, explicitly select the appropriate model based on task complexity:
  - **Lightweight Tasks:** Use the `flash` model (light, but capable) for straightforward tasks such as quick research, basic file reads, or simple file edits. Avoid `flash_lite` unless the task is extremely trivial.
  - **Heavy / Thinking Tasks:** Use the `pro` model for complex tasks that require deep reasoning, large refactors, architectural planning, or tricky debugging.
- **No Peer-to-Peer Communication:** Sub-agents MUST NOT use `send_message` to contact sibling agents directly. All communication flows through the parent. If a sub-agent needs information from a sibling, it reports the need to the parent, who decides whether and how to relay it.
- **Frozen Contract Compliance:** When given frozen interface contracts, sub-agents develop strictly against them. If the contract is wrong, fail fast and report to parent. Do NOT improvise or guess.
