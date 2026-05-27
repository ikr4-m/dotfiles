# AI Harness & Prompt Engineering at Codebase Scale

> A general guide for humans building AI rule systems, and for AI agents learning how to read and apply them.
> Covers: Cursor, Claude Code, Gemini CLI, Google Antigravity, OpenCode, OpenAI Codex, GitHub Copilot.

---

## What Is an AI Harness?

A **prompt** tells an AI what to do once.
An **AI harness** constrains what an AI is *allowed* to do across all sessions, all contributors, and all task types.

A harness is made of:
- **Rules** — behavioral constraints (what to do, what never to do)
- **Knowledge** — reference material (architecture, design system, domain model)
- **Protocol** — how the AI should reason before acting (planning loops, approval gates)
- **Skills** — specialized playbooks for specific task types

---

## Core Philosophy

### Ambiguity Is a Bug
Every gap in a rule is filled by the AI's default behavior — which is optimistic, over-helpful, and wrong for most production codebases. Write rules so no interpretation is left to chance.

### Prohibitions over Permissions
AI responds more reliably to explicit prohibitions than positive instructions.

```
# Weak
Use the new ORM for all database access.

# Strong
Importing the legacy database helper in any new file is a hard error.
It extends the legacy surface area instead of shrinking it.
```

Always pair a permission with its prohibition. "Use X" should be followed by "Never use Y."

### Compliance Degrades with Distance
Rules at the bottom of a long file get less weight than rules at the top. Rules in a file that isn't loaded get zero weight. Architecture matters as much as content.

### Defense in Depth over Elegance
DRY (Don't Repeat Yourself) is a coding principle, not a rules principle. A constraint worth enforcing should appear in at least two places — once in the always-loaded context, once in the domain-specific context.

---

## The Loading Tier System

Design rules in tiers based on when they apply:

```
Tier 1 — Always Loaded
  Project identity, tech stack, hard prohibitions, reasoning loop.
  Every session, every file, no exceptions.
  Keep this lean — only what matters unconditionally.

Tier 2 — Domain-Triggered
  Rules that apply only when editing specific files or domains.
  Loaded via glob patterns when the user opens a matching file.
  Keeps Tier 1 focused; prevents noise in unrelated contexts.

Tier 3 — Task-Triggered (Skills)
  Specialized step-by-step protocols for specific task types.
  Only active when the user explicitly invokes a skill or command.
  Best for multi-step workflows: migrations, refactors, PR prep.
```

Putting everything in Tier 1 wastes context budget and dilutes critical rules.
Putting critical safety rules only in Tier 2 means they miss sessions outside the glob.

---

## Tool Reference

### AGENTS.md — The Cross-Tool Standard

`AGENTS.md` at the project root is the closest thing to an industry standard. It is natively read by OpenCode, OpenAI Codex, Google Antigravity, and Claude Code (via `@` inclusion). When you maintain one well-structured `AGENTS.md`, most tools pick it up without additional configuration.

Where file priority conflicts exist (e.g., OpenCode prefers `AGENTS.md` over `CLAUDE.md` when both exist), `AGENTS.md` wins. Commit it to version control.

---

### Cursor

**Config:** `.cursor/rules/*.mdc`
**Frontmatter:** Yes — required for automatic loading

Cursor has the most explicit rule-loading system of the major tools — frontmatter controls exactly when each file loads. Rules without frontmatter are Manual type and only load when explicitly `@mentioned`.

```yaml
---
description: Brief description for agent-applied matching
alwaysApply: true
---
```

```yaml
---
description: Rules for API route changes
globs:
  - src/api/**/*
  - app/api/**/*
---
```

**Three loading modes:**

| Frontmatter | Mode | When it loads |
|---|---|---|
| `alwaysApply: true` | Always | Every session |
| `globs: [...]` | Auto | When matching file is open |
| `description` only | Agent | AI decides when relevant |
| *(none)* | Manual | Only when user `@mentions` it |

**Cross-references:** MDC files can `@mention` other MDC files or docs. Complex task protocols belong in dedicated files, not in always-applied rules. Cursor has no formal SKILL.md system — use `@file-name` to reference other rule files.

**Glob format must be YAML array, not comma-separated:**
```yaml
# Wrong
globs: src/api/**/*.ts, src/services/**/*.ts

# Correct
globs:
  - src/api/**/*.ts
  - src/services/**/*.ts
```

---

### Claude Code

**Config:** `CLAUDE.md`, `.claude/rules/*.md` (path-scoped), `.claude/settings.json`
**Frontmatter:** Yes — for `.claude/rules/` files (YAML `paths:` field)

**CLAUDE.md — always-loaded instructions**

Loaded hierarchically at session start:
```
/etc/claude-code/CLAUDE.md        → org policy (Linux)
~/.claude/CLAUDE.md               → user-global
./CLAUDE.md                       → project root
./.claude/CLAUDE.md               → project (alternative location)
./src/CLAUDE.md                   → subdirectory (lazy-loaded when Claude reads files there)
```

Personal overrides without polluting shared rules: `CLAUDE.local.md` (gitignored, appended after `CLAUDE.md`).

Use `@` file inclusion to avoid duplicating content across tools:
```markdown
<!-- .claude/CLAUDE.md -->
@AGENTS.md
```

**Keep individual CLAUDE.md files under ~200 lines.** Longer files consume more tokens and adherence degrades toward the bottom. Split into `.claude/rules/` for domain-specific content.

HTML comments (`<!-- -->`) are stripped before loading — use them for maintainer notes without consuming context.

**`.claude/rules/` — path-scoped rules (Claude Code's glob system)**

Claude Code has its own path-triggered rule system, equivalent to Cursor's MDC globs:

```markdown
---
paths:
  - "src/api/**/*.ts"
  - "app/api/**/*"
---

# API Rules
All new routes must use apiHandler from lib/api-handler.ts.
```

Rules without `paths:` load unconditionally (same as `alwaysApply: true` in Cursor).
Rules with `paths:` load only when Claude reads matching files (same as Cursor glob rules).
User-level rules: `~/.claude/rules/` (loaded before project rules).

**Skills:** `.claude/skills/<skill-name>/SKILL.md` — invoked via `/skill-name`. Self-contained procedural playbooks. SKILL.md supports frontmatter for `paths:` scoping, `disable-model-invocation: true` (user-only trigger), and `allowed-tools:` (tools the skill can use without prompting).

**Settings:**
```json
{
  "autoMemoryEnabled": false,
  "permissions": {
    "deny": ["Read(./.env)", "Bash(rm -rf *)"],
    "allow": ["Bash(npm run *)", "Bash(git commit *)"],
    "ask": ["Bash(git push *)"]
  }
}
```

`autoMemoryEnabled: false` — harness governs, not accumulated session state.
`permissions.deny` — absolute blocks, not instructions. The tool will not run regardless of what the AI wants.

**Memory system:** Claude Code can write persistent memories between sessions (first 200 lines or 25 KB loaded per session). Disabling auto-memory gives the harness full control. View loaded context with `/memory`.

---

### Gemini CLI

**Config:** `GEMINI.md` (project root and subdirectories), `~/.gemini/GEMINI.md` (global)
**Frontmatter:** No — plain markdown
**Source:** [Gemini CLI Docs](https://geminicli.com/docs/cli/gemini-md/)

Gemini CLI loads `GEMINI.md` hierarchically:

```
~/.gemini/GEMINI.md          → applies to all projects
./GEMINI.md                  → applies to the current repo
./src/GEMINI.md              → applies only within src/
```

Subdirectory files are additive — they stack on top of the project root file. This makes per-domain rules straightforward: put API-specific rules in `src/api/GEMINI.md`, database rules in `src/db/GEMINI.md`.

No frontmatter, no glob system — context is purely location-based.

---

### Google Antigravity

**Config:** `.agent/rules/` (workspace rules), `AGENTS.md` (cross-tool), `~/.gemini/GEMINI.md` (shared with Gemini CLI)
**Frontmatter:** No for AGENTS.md; UI-managed for `.agent/rules/`
**Source:** [Antigravity Rules & Workflows](https://antigravity.google/docs/rules-workflows)

Antigravity is a VS Code fork with an agent-first paradigm (released November 2025 with Gemini 3). It supports multiple rule entry points:

```
~/.gemini/GEMINI.md              → global, shared with Gemini CLI
./AGENTS.md                      → cross-tool format, auto-loaded
./.agent/rules/                  → workspace rules (Antigravity-specific)
./.agent/workflows/              → multi-step task workflows
~/.gemini/antigravity/skills/    → global skills
./.agents/skills/                → workspace skills
```

**Known conflict:** Antigravity and Gemini CLI both write to `~/.gemini/GEMINI.md`. If you use both tools on the same machine, global rule changes in one affect the other. Keep global rules minimal and project-specific rules in `AGENTS.md` or `.agent/rules/` to avoid this.

**Skills** follow the same directory-based pattern as Claude Code. Workspace skills in `.agents/skills/<name>/` are scoped to the project.

---

### OpenCode

**Config:** `AGENTS.md` (project root), `~/.config/opencode/AGENTS.md` (global)
**Frontmatter:** No — plain markdown
**Source:** [OpenCode Rules Docs](https://opencode.ai/docs/rules/)

OpenCode is a terminal-based AI coding agent that treats `AGENTS.md` as its primary instruction file. File priority when multiple convention files coexist: `AGENTS.md` wins over `CLAUDE.md`.

```
~/.config/opencode/AGENTS.md    → global rules, all projects
./AGENTS.md                     → project-level rules
```

Multiple instruction files can be combined via `opencode.json`:
```json
{
  "instructions": ["AGENTS.md", "docs/architecture.md"]
}
```

**Size limit:** Combined instruction files are capped at 32 KiB by default. Large knowledge documents should be referenced, not inlined.

**`/init` command:** Analyzes the project and generates or improves `AGENTS.md` automatically. Useful for bootstrapping, but review and harden the output before relying on it.

---

### OpenAI Codex

**Config:** `AGENTS.md` (project root), `~/.codex/AGENTS.md` (global), `AGENTS.override.md` (environment override)
**Frontmatter:** No — plain markdown
**Source:** [Codex Custom Instructions Docs](https://developers.openai.com/codex/guides/agents-md)

Codex builds an instruction chain at startup with the following precedence:

```
~/.codex/AGENTS.md               → global baseline
~/.codex/AGENTS.override.md      → global overrides (wins over global baseline)
./AGENTS.md                      → project rules
./AGENTS.override.md             → project overrides (wins over project rules)
```

`AGENTS.override.md` is designed for environment-specific constraints — CI, staging, production — where you want to add rules on top of the committed baseline without modifying it. Useful for keeping production-safety rules out of the main `AGENTS.md` while still enforcing them in the right context.

**Size limit:** Combined 32 KiB by default (`project_doc_max_bytes`). Empty files are skipped.

---

### GitHub Copilot

**Config:** `.github/copilot-instructions.md`
**Frontmatter:** No — plain markdown
**Scope:** Applies to all Copilot interactions in the repository

Copilot's instruction system is the most limited of the major tools — one file, no glob system, no loading tiers, no skills. Compensate by being precise:

- Put the highest-priority rules first (compliance degrades toward the bottom)
- Use `#file:path/to/file` references to pull in supplementary context without duplicating content
- Keep the file under ~8,000 tokens; Copilot truncates beyond its context budget

Copilot reads this file for Copilot Chat and inline completions. It does not affect GitHub Actions or Copilot in the CLI separately.

---

### PI.dev (pi.ai)

Not a coding agent. pi.ai by Inflection AI is a general conversational AI assistant. If you need coding agents, the tools above are the right choices.

*(There is a separate open-source "Pi coding agent" toolkit unrelated to Inflection AI, but it is not the same product.)*

---

## Rule Writing Techniques

### Trigger Phrases as Hard Gates

Instead of relying on the AI to infer intent, require an explicit human signal before high-risk operations:

```markdown
The user's prompt must contain the exact phrase "full refactor".
Without this phrase, do not perform structural rewrites.
Do not infer refactoring intent from "clean this up", "modernize", or "improve this file."
```

This works because AI models respect explicit activation conditions. A vague prompt cannot accidentally satisfy a specific phrase requirement.

### Blast Radius Zones

Communicate risk in tiers, not prose:

```markdown
RED ZONE    — Core infrastructure (auth, connection pooling, payment callbacks)
              Stop. Warn user. Do not proceed without explicit approval.

YELLOW ZONE — Shared services, high-traffic routes, real-time handlers
              Proceed with caution. Identify all consumers before changing exports.

GREEN ZONE  — Isolated features, static pages, UI components
              Proceed.
```

Three zones is the right number. More becomes noise; fewer loses precision.

### Escape Hatches for Every Hard Rule

Every hard constraint needs a defined exit path, or the AI will either stall or quietly violate the rule to make progress:

```markdown
Escape hatch: If the bug fix genuinely cannot be completed without modifying
[restricted file], STOP and explain the constraint to the user. Do not proceed.
```

### Verification Commands, Not Vague Checks

```markdown
# Vague — skipped half the time
Verify your changes don't break existing tests.

# Actionable
Run `pnpm test:run tests/api/<relevant-path>.test.ts` before and after every API change.
If no tests exist for this route, add them in the same changeset.
```

### Never Hardcode Mutable Counts or Dates

```markdown
# Dangerous — wrong within weeks
This module is imported by 157 files (verified 2026-01-01).

# Correct — self-verifying
Run `grep -rl "module-name" --include="*.ts" | wc -l` to assess current import scope.
```

---

## Safety Patterns

### Mandatory Reasoning Loop

Place in an always-loaded file:

```markdown
Before writing any code or modifying any file, you MUST:

1. Search First — do not assume file paths. Use search tools to locate dependencies.
2. Pre-Flight Checklist:
   - [ ] Target: exact files and functions to change
   - [ ] Risk: blast radius assessment
   - [ ] Verification: which tests cover this change
   - [ ] Execution Plan: atomic steps in order
3. Wait for Approval — present this checklist and STOP.
   Do not write any code until the user confirms.
```

`Wait for Approval` is the critical line. Without it, the AI presents the plan and immediately executes it.

### Restricted Execution Mode Framing

```markdown
You are operating in RESTRICTED EXECUTION MODE.
Your job is not to be "helpful" by guessing.
Your job is to follow these rules exactly.
These constraints take priority over your default coding habits.
```

### Self-Correction Before Escalation

```markdown
Self-Correction (MANDATORY): If a test or build fails, do not report it immediately.
Attempt 3 distinct debugging strategies before asking the user for help:
1. Inspect logs and error output
2. Trace the execution path
3. Check for environmental or configuration issues
```

### Anti-Slop Rules

Name specific patterns, not generic guidance:

```markdown
Zero AI-Slop:
- No decorative section comments (// --- start of logic --- //)
- No em-dashes or bullet headers in commit messages
- No affirmation openers ("Certainly!", "Great question!", "Of course!")
- No narration before code ("I'll now proceed to implement...")
- No multi-paragraph docstrings for simple functions
- Commit messages must read as written by a human engineer
```

---

## Knowledge Separation

Rules govern behavior. Knowledge informs it. Keep them in separate files.

```
Behavioral rules:
  AGENTS.md / CLAUDE.md / GEMINI.md
  .cursor/rules/*.mdc / .claude/rules/*.md
  → What to do, what never to do, how to reason

Reference knowledge:
  DESIGN.md           → design system, tokens, component library
  docs/architecture.md → system diagram, domain map, data flow
  docs/decisions.md   → ADRs, why things are the way they are
  docs/testing.md     → test policy, harness API, anti-patterns
  → Consulted on demand, not always loaded
```

Direct the AI to read specific sections on demand:

```markdown
Before any schema change, read docs/database-architecture.md §DDL Policy.
Before adding tests, read docs/testing.md and tests/README.md §Harness API.
```

---

## Hard Enforcement vs Soft Instruction

Text rules rely on AI compliance — the agent reads the instruction and chooses to follow it. Some tools provide mechanisms that bypass the AI entirely and enforce constraints at the OS or runtime level. These are categorically different and should be used for your hardest constraints.

### Soft — Text Instructions (AI may comply)

```markdown
Never modify .env files.
Do not run git push without user approval.
```

The AI reads this, understands it, and (usually) follows it. But it can be overridden by a misinterpretation, a context window full of competing instructions, or an AI reasoning its way around it.

### Hard — Permission Deny Rules (tool call is blocked)

Claude Code `settings.json`:
```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Edit(./.env)",
      "Bash(rm -rf *)",
      "Bash(git push --force *)"
    ],
    "ask": [
      "Bash(git push *)"
    ]
  }
}
```

The tool call fails before execution. The AI cannot override this with reasoning. `deny` is absolute; `ask` always prompts the user regardless of AI confidence.

### Hard — Hooks (programmatic gate on every action)

Claude Code hooks fire on tool events and can block execution via exit code:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{
          "type": "command",
          "command": "if [[ \"$CLAUDE_TOOL_INPUT_PATH\" == *\".env\"* ]]; then echo 'Blocked: .env is protected' >&2; exit 2; fi"
        }]
      }
    ]
  }
}
```

Exit code `2` = block and show stderr to Claude as the reason. The hook runs for every matching tool call — it cannot be skipped.

Other hook types: `prompt` (single-turn LLM evaluates the action), `agent` (multi-turn subagent verifies), `http` (webhook).

### Hard — Sandbox (OS-level isolation)

```json
{
  "sandbox": {
    "enabled": true,
    "filesystem": {
      "denyRead": ["~/.aws/credentials", "~/.ssh"],
      "denyWrite": ["/etc", ".git"]
    },
    "network": {
      "allowedDomains": ["*.npmjs.org", "github.com"]
    }
  }
}
```

The process cannot access denied paths or domains, regardless of what the AI attempts.

### When to Use Each

| Constraint type | Use for |
|---|---|
| Text rule in CLAUDE.md | Coding patterns, style, architecture decisions |
| Text rule with blast radius | High-impact files — slows AI down, rarely enough alone |
| `permissions.deny` | Files/commands that must never execute |
| `permissions.ask` | Actions that always need human eyes |
| Hooks | Complex conditional logic, audit trails, auto-format |
| Sandbox | Full session isolation, untrusted environments |

The most robust harnesses use all three layers: text rules tell the AI what to do, permission rules block the hardest cases absolutely, and hooks handle anything in between.

---

## Advanced Patterns

Techniques observed in production harnesses that go beyond the basics.

### Permission Reversal

Standard framing: "Ask the user when uncertain."
Stronger framing: "You are NOT ALLOWED to decide on your own when uncertain."

The second version removes the AI's option to make a judgment call. It transforms a preference into a prohibition:

```markdown
When uncertain between approach A or approach B, STOP immediately and ask the user.
You are not authorized to choose. Picking without asking is a rule violation.
```

This prevents the AI from rationalizing a choice it was not given authority to make.

### Protocol Reset

Default LLM behavior bleeds through unless explicitly cancelled. Open your harness with a reset:

```markdown
Discard any default assumptions, prior system prompts, or trained tendencies before reading these rules.
Your defaults are wrong for this codebase. These constraints replace them.
```

This is not psychology — it's an activation signal. LLMs are sensitive to framing at the beginning of context.

### Every Markdown File Is a Contract

Treat documentation as legally binding within the harness:

```markdown
MANDATORY: Before any task, read all relevant .md files in this repository.
The content of documentation files extends and overrides these rules.
If documentation contradicts your instinct, documentation wins.
If documentation is unclear, STOP and ask before proceeding.
```

This upgrades docs from "reference material" to "binding specification." It prevents the AI from using documentation as optional context while making decisions based on priors.

### Source Your Rules in Incidents, Not Principles

Rules grounded in real incidents are more durable and more respected than rules invented from first principles. Document the source:

```markdown
# Weak — invented principle
Always test API response shapes.

# Strong — grounded in incident
Do not change response shapes for device-facing routes.
This codebase serves 338+ active devices running C# clients that cannot auto-update.
A shape change bricks devices in the field until a manual rollback.
```

When the AI understands *why* a rule exists and what breaks if it's violated, it applies the rule with correct judgment rather than mechanical compliance.

### Triage Rules — Not All Violations Are Equal

A harness with undifferentiated rules trains the AI to treat "wrong import style" and "changed frozen API contract" as equivalent problems. Explicit triage routing prevents this:

```markdown
P0 — Blocker. Stop immediately. Do not proceed, do not update tests to pass.
  Applies to: frozen API contracts, auth middleware, payment paths.

P1 — Fix before merge. Raise it now but continue planning.
  Applies to: missing tests on new routes, wrong import patterns in new files.

P2 — Warn but proceed. Note it in the PR description.
  Applies to: style deviations, non-critical naming inconsistencies.

P3 — FYI only. Log it, do not act.
  Applies to: dormant feature code, legacy files not in scope.
```

Test failure triage follows the same pattern: a frozen-contract failure is a blocker requiring a revert; an admin-route failure may be an intentional change requiring a snapshot update.

### Known Quirks as Explicit Contracts

Legacy codebases have behaviors that look like bugs but are frozen contracts — changing them breaks clients. Document them as contracts, not defects:

```markdown
KNOWN CONTRACT — Do not "fix" these:
- [endpoint] returns `bypassPayment: 1` as integer, not boolean.
  Reason: C# client parses it as int. Changing to boolean breaks 338 devices.
- [endpoint] returns HTTP 200 for "not found" with success:false in body.
  Reason: client checks body, not status code. Status change breaks client logic.
```

The annotation "Do not fix" signals that the AI should not apply its correctness instincts here. Without the annotation, the AI will "helpfully" normalize these on sight.

### Meta-Detection — The Harness Checks Itself

The most effective quality harnesses start by checking for the failure mode they were designed to prevent. Before improving output, verify the problem exists:

```markdown
Phase 1 — Detection (run before any other phase):
  Does this output exhibit any of the prohibited patterns?
  If yes, enumerate them before proposing fixes.
  If no, state that clearly before proceeding.
```

Applied to code reviews: before suggesting improvements, check whether the PR violates any frozen contracts or blast-radius rules. Applied to writing: before revising, enumerate the AI-slop patterns present. Detection first prevents the AI from "improving" things that have a different root problem.

### Personality as a Measurable Constraint

Anti-slop rules that only *remove* patterns produce correct-but-lifeless output. A complete harness also *injects* what correct output should feel like:

```markdown
Zero AI-Slop removes patterns. It does not add voice.
Soulless-but-correct is also a failure mode.

Good output has a human behind it:
- Has opinions, does not just report facts
- Reacts to findings, does not just catalog them
- Acknowledges complexity instead of resolving it to false clarity
- Uses specific language, not placeholder phrases ("significant", "robust", "seamless")

Test: if someone read this output and immediately thought "AI wrote this," it failed.
```

This is most relevant for documentation, PR descriptions, commit messages, and any output that will be read by humans.

### Skill Composition — Reference, Don't Restate

When skills share a prerequisite, reference it by name rather than duplicating its content:

```markdown
# Wrong — restates shared context in every skill
Skill A: "Follow the service-first pattern. Route handler → service → ORM..."
Skill B: "Follow the service-first pattern. Route handler → service → ORM..."

# Correct — reference the authority
Skill A: "Invoke /core-patterns first. Then proceed with the following..."
Skill B: "Requires /core-patterns context. Then proceed with the following..."
```

Skill B's author is not "lazy" — they are keeping the chain single-source. When the shared pattern changes, only one file needs updating.

---

## Multi-Tool Strategy

When a project is used by multiple AI tools, use one file as the source of truth and let tool-specific files point to it:

```
AGENTS.md                        ← source of truth (committed to git)
  ↑ read directly by: OpenCode, Codex, Antigravity
  ↑ included via @AGENTS.md in: .claude/CLAUDE.md
  ↑ referenced by: .cursor/rules/core.mdc

GEMINI.md                        ← Gemini CLI / Antigravity only
  → link or duplicate the critical subset from AGENTS.md

.github/copilot-instructions.md  ← Copilot only
  → maintain separately; include the critical subset manually
```

Avoid putting rules only in tool-specific files. If a constraint is important enough to enforce, it belongs in `AGENTS.md` first.

---

## Common Mistakes

**Overloading always-applied context.**
If every rule is always loaded, nothing is prioritized. Reserve always-loaded rules for things that matter unconditionally.

**Vague prohibitions.**
"Be careful with the payment code" is not a rule. "Do not add any route under `payments/` without explicit user approval" is a rule.

**No redundancy.**
If a safety rule exists in only one place and that file fails to load, the constraint is gone. Critical rules should appear in at least two files.

**Rules without escape hatches.**
Every hard constraint needs a defined fallback. Without it, the AI resolves the contradiction silently.

**Assuming the AI reads referenced docs.**
"See docs/testing.md for the test policy" will be skipped. Essential constraints must be inline; docs are supplementary.

**Single monolith for a large codebase.**
A 100-rule AGENTS.md works when the project is small. As it grows, migrate domain-specific rules to triggered files (Cursor MDC globs, subdirectory GEMINI.md, OpenCode multi-file config) to preserve context budget.

**Static facts that decay.**
File counts, record counts, version numbers, and "as of [date]" stamps go wrong within weeks. Replace them with commands to derive the current value.

---

## Quick Reference — Tool Config Files

| Tool | Always-loaded file | Path-scoped rules | Global file | Frontmatter | Hard enforcement |
|---|---|---|---|---|---|
| Cursor | `.cursor/rules/*.mdc` (`alwaysApply`) | `.cursor/rules/*.mdc` (`globs:`) | — | Yes (required) | — |
| Claude Code | `CLAUDE.md` / `@AGENTS.md` | `.claude/rules/*.md` (`paths:`) | `~/.claude/CLAUDE.md` | Yes (for rules/) | `permissions.deny`, hooks, sandbox |
| Gemini CLI | `GEMINI.md` | Subdirectory `GEMINI.md` | `~/.gemini/GEMINI.md` | No | — |
| Google Antigravity | `AGENTS.md` + `.agent/rules/` | `.agent/rules/` | `~/.gemini/GEMINI.md` | No | — |
| OpenCode | `AGENTS.md` | Multi-file via `opencode.json` | `~/.config/opencode/AGENTS.md` | No | — |
| OpenAI Codex | `AGENTS.md` | `AGENTS.override.md` | `~/.codex/AGENTS.md` | No | — |
| GitHub Copilot | `.github/copilot-instructions.md` | — | VS Code settings | No | — |

---

## Quick Reference — Build Checklist

```
Architecture
  [ ] Always-loaded file covers: identity, tech stack, hard prohibitions, reasoning loop
  [ ] Domain rules are triggered, not always-loaded (glob / subdirectory / multi-file)
  [ ] CLAUDE.md uses @AGENTS.md inclusion — no content duplication
  [ ] AGENTS.md committed to git as cross-tool source of truth
  [ ] autoMemoryEnabled: false if harness should govern, not session state
  [ ] Skills exist for multi-step workflows

Rule Quality
  [ ] Every permission has a paired prohibition
  [ ] No static counts or dates — replaced with self-verifying commands
  [ ] Every hard constraint has an escape hatch
  [ ] Blast radius zones defined (at minimum: high / medium / low risk)
  [ ] Trigger phrases guard structural or irreversible operations
  [ ] Verification steps are runnable commands, not vague instructions
  [ ] Rules grounded in incidents or external sources, not invented principles
  [ ] Known quirks annotated as explicit contracts ("do not fix — reason: X")

Safety
  [ ] Mandatory reasoning loop with explicit "Wait for Approval"
  [ ] Self-correction protocol before escalating failures
  [ ] High-risk files/modules listed explicitly by path
  [ ] Anti-slop rules name specific patterns
  [ ] Triage levels defined (P0 blocker / P1 fix / P2 warn / P3 FYI)
  [ ] Protocol reset at harness entry ("discard defaults, these rules replace them")
  [ ] Hard constraints enforced via permissions.deny / hooks, not just text rules
  [ ] permissions.ask on any action that should always have human eyes

Quality
  [ ] Personality constraints defined, not just pattern-removal rules
  [ ] Meta-detection phase: harness checks for the failure it was designed to prevent
  [ ] Skills reference shared prerequisites, do not restate them

Redundancy
  [ ] Critical constraints appear in ≥ 2 files
  [ ] Knowledge docs are separate from behavioral rules
  [ ] Frozen/immutable items enumerated inline, not only referenced externally
```
