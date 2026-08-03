---
name: agent-plan-mode
description: Enforces a strict planning phase before execution. For complex tasks, it triggers a 'grill-me' style Q&A and generates an implementation plan. For simple tasks, it skips heavy planning.
---

# Plan Mode

Trigger this skill when the user wants to plan a task thoroughly without immediately executing changes, or when they use phrases like "plan mode", "make a plan", "plan only", or "let's plan".

## 1. Task Assessment
Evaluate the complexity of the user's request.

*   **Simple Tasks** (e.g., minor tweaks, answering questions, syntax fixes):
    *   Do NOT create a formal implementation plan artifact.
    *   Do NOT ask unnecessary 'grill-me' questions.
    *   Provide a quick, concise summary of the proposed solution or directly answer the question.
*   **Complex Tasks** (e.g., new features, major refactors, architectural design, unknown codebases):
    *   Proceed to the structured planning process below.

## 2. Structured Planning (For Complex Tasks)

### A. Research (No Modifications)
*   Thoroughly research the codebase using read-only tools (`grep_search`, `view_file`, `list_dir`).
*   **STRICT RULE:** Do NOT modify any source code files, run build commands, or execute any changes during this phase.

### B. Interactive Q&A ("Grill-Me" Behavior)
*   Identify underspecified requirements, edge cases, and design choices.
*   If critical information is missing, ask the user clarifying questions *before* writing the plan.
*   Wait for the user's response before proceeding.

### C. Implementation Plan Artifact
*   Once you have enough context, create a detailed `implementation_plan.md` artifact.
*   **Format:** Include the Goal, Proposed Changes (grouped by component/file), and a Verification Plan.
*   **Metadata:** Ensure `request_feedback = true` and `user_facing = true` when creating the artifact.
*   Include any remaining open questions or design warnings in the artifact using GitHub alerts (`> [!WARNING]`, `> [!IMPORTANT]`).

### D. Stop and Wait
*   After presenting the plan, **STOP**.
*   Do NOT execute the plan. Wait for the user's explicit approval to proceed.
